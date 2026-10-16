"""Train and evaluate an experimental six-class PadiCare model.

This script writes only to ml/models_v2. It never replaces the Android model.
Run prepare_six_class_data.py first. The final test split is evaluated once.
"""

from __future__ import annotations

import json
import os
import tempfile
from pathlib import Path

import numpy as np
import tensorflow as tf
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.utils.class_weight import compute_class_weight
from tensorflow import keras
from tensorflow.keras import layers


ROOT = Path(__file__).resolve().parent
DATA_DIR = ROOT / "data_v2"
OUTPUT_DIR = ROOT / "models_v2"
CLASSES = (
    "bacterial_leaf_blight",
    "brown_spot",
    "leaf_blast",
    "leaf_scald",
    "narrow_brown_spot",
    "normal",
)
SEED = 42
IMAGE_SIZE = (224, 224)
BATCH_SIZE = 16


def _dataset(split: str, shuffle: bool) -> tf.data.Dataset:
    return keras.utils.image_dataset_from_directory(
        DATA_DIR / split,
        labels="inferred",
        label_mode="int",
        class_names=list(CLASSES),
        image_size=IMAGE_SIZE,
        batch_size=BATCH_SIZE,
        shuffle=shuffle,
        seed=SEED if shuffle else None,
    ).prefetch(tf.data.AUTOTUNE)


def _build_models() -> tuple[keras.Model, keras.Model, keras.Model]:
    base = keras.applications.MobileNetV3Small(
        input_shape=(*IMAGE_SIZE, 3),
        include_top=False,
        weights="imagenet",
    )
    base.trainable = False
    augmentation = keras.Sequential(
        [
            layers.RandomFlip("horizontal_and_vertical", seed=SEED),
            layers.RandomRotation(0.1, seed=SEED),
            layers.RandomZoom(0.1, seed=SEED),
        ],
        name="augmentation",
    )
    inputs = keras.Input(shape=(*IMAGE_SIZE, 3))
    x = base(augmentation(inputs), training=False)
    x = layers.GlobalAveragePooling2D(name="gap")(x)
    x = layers.BatchNormalization(name="bn")(x)
    x = layers.Dropout(0.3, seed=SEED)(x)
    x = layers.Dense(64, activation="relu", name="features")(x)
    x = layers.Dropout(0.2, seed=SEED)(x)
    outputs = layers.Dense(len(CLASSES), activation="softmax", name="scores")(x)
    training_model = keras.Model(inputs, outputs, name="PadiCareSixClassPilot")

    inference_inputs = keras.Input(shape=(*IMAGE_SIZE, 3))
    y = base(inference_inputs, training=False)
    y = training_model.get_layer("gap")(y)
    y = training_model.get_layer("bn")(y)
    y = training_model.get_layer("features")(y)
    inference_outputs = training_model.get_layer("scores")(y)
    inference_model = keras.Model(inference_inputs, inference_outputs)
    return training_model, inference_model, base


def _compile(model: keras.Model, learning_rate: float) -> None:
    model.compile(
        optimizer=keras.optimizers.Adam(learning_rate=learning_rate),
        loss="sparse_categorical_crossentropy",
        metrics=["accuracy"],
    )


def _callbacks() -> list[keras.callbacks.Callback]:
    return [
        keras.callbacks.EarlyStopping(
            monitor="val_loss", patience=4, restore_best_weights=True
        ),
        keras.callbacks.ReduceLROnPlateau(
            monitor="val_loss", factor=0.5, patience=2, min_lr=1e-6
        ),
    ]


def train() -> dict:
    if not (DATA_DIR / "train").is_dir():
        raise FileNotFoundError("Run ml/prepare_six_class_data.py first")
    OUTPUT_DIR.mkdir(exist_ok=True)
    tf.keras.utils.set_random_seed(SEED)
    np.random.seed(SEED)

    train_ds = _dataset("train", shuffle=True)
    val_ds = _dataset("val", shuffle=False)
    test_ds = _dataset("test", shuffle=False)

    y_train = np.concatenate([labels.numpy() for _, labels in train_ds])
    weights = compute_class_weight(
        class_weight="balanced",
        classes=np.arange(len(CLASSES)),
        y=y_train,
    )
    class_weights = {i: float(value) for i, value in enumerate(weights)}
    model, inference_model, base = _build_models()

    _compile(model, learning_rate=1e-3)
    model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=12,
        class_weight=class_weights,
        callbacks=_callbacks(),
    )

    base.trainable = True
    for layer in base.layers[:-40]:
        layer.trainable = False
    _compile(model, learning_rate=2e-4)
    model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=12,
        class_weight=class_weights,
        callbacks=_callbacks(),
    )

    y_true: list[int] = []
    y_probs: list[np.ndarray] = []
    sample_images: np.ndarray | None = None
    for images, labels in test_ds:
        if sample_images is None:
            sample_images = images[: min(5, len(images))].numpy()
        y_true.extend(labels.numpy().tolist())
        y_probs.extend(inference_model.predict(images, verbose=0))
    true = np.asarray(y_true)
    probs = np.asarray(y_probs)
    predicted = probs.argmax(axis=1)
    metrics = {
        "status": "experimental pilot; not deployed",
        "classes": list(CLASSES),
        "test_samples": len(true),
        "accuracy": float(np.mean(predicted == true)),
        "confusion_matrix": confusion_matrix(
            true, predicted, labels=np.arange(len(CLASSES))
        ).tolist(),
        "classification_report": classification_report(
            true,
            predicted,
            labels=np.arange(len(CLASSES)),
            target_names=CLASSES,
            output_dict=True,
            zero_division=0,
        ),
        "unknown_class_evaluation": "pending independent data",
        "note": "The previous 0.60 threshold is not calibrated for this model.",
    }

    keras_path = OUTPUT_DIR / "padicare_six_class.keras"
    inference_model.save(keras_path)
    # TF 2.21 + Keras 3 does not support from_keras_model on this host.
    with tempfile.TemporaryDirectory(dir=OUTPUT_DIR) as saved_model_dir:
        inference_model.export(saved_model_dir)
        converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)
        tflite_bytes = converter.convert()
    (OUTPUT_DIR / "padicare_six_class.tflite").write_bytes(tflite_bytes)
    (OUTPUT_DIR / "labels.txt").write_text(
        "\n".join(CLASSES) + "\n", encoding="utf-8"
    )

    interpreter = tf.lite.Interpreter(model_content=tflite_bytes)
    interpreter.allocate_tensors()
    input_info = interpreter.get_input_details()[0]
    output_info = interpreter.get_output_details()[0]
    max_delta = 0.0
    assert sample_images is not None
    expected = inference_model.predict(sample_images, verbose=0)
    for image, keras_output in zip(sample_images, expected):
        interpreter.set_tensor(input_info["index"], image[None, ...])
        interpreter.invoke()
        actual = interpreter.get_tensor(output_info["index"])[0]
        max_delta = max(max_delta, float(np.max(np.abs(actual - keras_output))))
    metrics["keras_tflite_max_probability_delta"] = max_delta
    if max_delta > 0.01:
        raise RuntimeError(f"Keras/TFLite mismatch: {max_delta:.4f}")

    (OUTPUT_DIR / "evaluation_metrics.json").write_text(
        json.dumps(metrics, indent=2), encoding="utf-8"
    )
    print(json.dumps(metrics, indent=2))
    return metrics


if __name__ == "__main__":
    os.environ.setdefault("TF_CPP_MIN_LOG_LEVEL", "2")
    train()
