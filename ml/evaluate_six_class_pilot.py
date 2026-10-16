"""Evaluate and export the saved six-class pilot without retraining."""

from __future__ import annotations

import json
import tempfile
from pathlib import Path

import numpy as np
import tensorflow as tf
from sklearn.metrics import classification_report, confusion_matrix
from tensorflow import keras

from train_six_class_pilot import BATCH_SIZE, CLASSES, DATA_DIR, IMAGE_SIZE, OUTPUT_DIR


def evaluate() -> dict:
    OUTPUT_DIR.mkdir(exist_ok=True)
    model = keras.models.load_model(OUTPUT_DIR / "padicare_six_class.keras")
    test_ds = keras.utils.image_dataset_from_directory(
        DATA_DIR / "test",
        labels="inferred",
        label_mode="int",
        class_names=list(CLASSES),
        image_size=IMAGE_SIZE,
        batch_size=BATCH_SIZE,
        shuffle=False,
    )
    labels: list[int] = []
    probabilities: list[np.ndarray] = []
    sample_images: np.ndarray | None = None
    for images, batch_labels in test_ds:
        if sample_images is None:
            sample_images = images[: min(5, len(images))].numpy()
        labels.extend(batch_labels.numpy().tolist())
        probabilities.extend(model.predict(images, verbose=0))

    y_true = np.asarray(labels)
    y_prob = np.asarray(probabilities)
    y_pred = y_prob.argmax(axis=1)
    metrics = {
        "status": "experimental pilot; not deployed",
        "classes": list(CLASSES),
        "test_samples": len(y_true),
        "accuracy": float(np.mean(y_pred == y_true)),
        "confusion_matrix": confusion_matrix(
            y_true, y_pred, labels=np.arange(len(CLASSES))
        ).tolist(),
        "classification_report": classification_report(
            y_true,
            y_pred,
            labels=np.arange(len(CLASSES)),
            target_names=CLASSES,
            output_dict=True,
            zero_division=0,
        ),
        "unknown_class_evaluation": "pending independent data",
        "note": "The previous 0.60 threshold is not calibrated for this model.",
    }
    metrics_path = OUTPUT_DIR / "evaluation_metrics.json"
    metrics_path.write_text(json.dumps(metrics, indent=2), encoding="utf-8")

    with tempfile.TemporaryDirectory(dir=OUTPUT_DIR) as saved_model_dir:
        model.export(saved_model_dir)
        converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)
        tflite_bytes = converter.convert()
    (OUTPUT_DIR / "padicare_six_class.tflite").write_bytes(tflite_bytes)
    (OUTPUT_DIR / "labels.txt").write_text("\n".join(CLASSES) + "\n", encoding="utf-8")

    interpreter = tf.lite.Interpreter(model_content=tflite_bytes)
    interpreter.allocate_tensors()
    input_info = interpreter.get_input_details()[0]
    output_info = interpreter.get_output_details()[0]
    assert sample_images is not None
    expected = model.predict(sample_images, verbose=0)
    max_delta = 0.0
    for image, keras_output in zip(sample_images, expected):
        interpreter.set_tensor(input_info["index"], image[None, ...])
        interpreter.invoke()
        actual = interpreter.get_tensor(output_info["index"])[0]
        max_delta = max(max_delta, float(np.max(np.abs(actual - keras_output))))
    metrics["keras_tflite_max_probability_delta"] = max_delta
    metrics_path.write_text(json.dumps(metrics, indent=2), encoding="utf-8")
    if max_delta > 0.01:
        raise RuntimeError(f"Keras/TFLite mismatch: {max_delta:.4f}")
    print(json.dumps(metrics, indent=2))
    return metrics


if __name__ == "__main__":
    evaluate()
