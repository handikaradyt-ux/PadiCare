"""
Train, evaluate, and export a 5-class MobileNetV3 model for PadiCare.
Target classes:
  0: bacterial_leaf_blight
  1: brown_spot
  2: leaf_blast
  3: normal
  4: tungro

Uses dataset in ml/data_v3/ and writes outputs to ml/models_v3/.
Does NOT overwrite padicare/assets/models/ directly until evaluation passes.
"""

from __future__ import annotations

import json
import os
import tempfile
import time
from pathlib import Path

import numpy as np
import tensorflow as tf
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.utils.class_weight import compute_class_weight
from tensorflow import keras
from tensorflow.keras import layers

ROOT = Path(__file__).resolve().parent
DATA_DIR = ROOT / "data_v3"
OUTPUT_DIR = ROOT / "models_v3"
CLASSES = (
    "bacterial_leaf_blight",
    "brown_spot",
    "leaf_blast",
    "normal",
    "tungro",
)
SEED = 42
IMAGE_SIZE = (224, 224)
BATCH_SIZE = 32


def get_dataset(split: str, shuffle: bool) -> tf.data.Dataset:
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


def build_models() -> tuple[keras.Model, keras.Model, keras.Model]:
    base = keras.applications.MobileNetV3Small(
        input_shape=(*IMAGE_SIZE, 3),
        include_top=False,
        weights="imagenet",
    )
    base.trainable = False

    augmentation = keras.Sequential(
        [
            layers.RandomFlip("horizontal_and_vertical", seed=SEED),
            layers.RandomRotation(0.15, seed=SEED),
            layers.RandomZoom(0.1, seed=SEED),
            layers.RandomContrast(0.1, seed=SEED),
        ],
        name="augmentation",
    )

    inputs = keras.Input(shape=(*IMAGE_SIZE, 3), name="image_input")
    x = augmentation(inputs)
    x = base(x, training=False)
    x = layers.GlobalAveragePooling2D(name="gap")(x)
    x = layers.BatchNormalization(name="bn")(x)
    x = layers.Dropout(0.3, seed=SEED, name="dropout_1")(x)
    x = layers.Dense(128, activation="relu", name="dense_features")(x)
    x = layers.BatchNormalization(name="bn_dense")(x)
    x = layers.Dropout(0.2, seed=SEED, name="dropout_2")(x)
    outputs = layers.Dense(len(CLASSES), activation="softmax", name="scores")(x)

    training_model = keras.Model(inputs, outputs, name="PadiCareFiveClassTraining")

    inference_inputs = keras.Input(shape=(*IMAGE_SIZE, 3), name="image_input")
    y = base(inference_inputs, training=False)
    y = training_model.get_layer("gap")(y)
    y = training_model.get_layer("bn")(y)
    y = training_model.get_layer("dense_features")(y)
    y = training_model.get_layer("bn_dense")(y)
    inference_outputs = training_model.get_layer("scores")(y)
    inference_model = keras.Model(
        inference_inputs, inference_outputs, name="PadiCareFiveClassInference"
    )

    return training_model, inference_model, base


def train() -> dict:
    if not (DATA_DIR / "train").is_dir():
        raise FileNotFoundError("Run ml/prepare_five_class_dataset.py first")

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    tf.keras.utils.set_random_seed(SEED)
    np.random.seed(SEED)

    print(f"Loading datasets from {DATA_DIR}...")
    train_ds = get_dataset("train", shuffle=True)
    val_ds = get_dataset("val", shuffle=False)
    test_ds = get_dataset("test", shuffle=False)

    y_train = np.concatenate([labels.numpy() for _, labels in train_ds])
    weights = compute_class_weight(
        class_weight="balanced",
        classes=np.arange(len(CLASSES)),
        y=y_train,
    )
    class_weights = {i: float(w) for i, w in enumerate(weights)}
    print(f"Computed class weights: {class_weights}")

    training_model, inference_model, base = build_models()

    best_weights_path = OUTPUT_DIR / "best_training_weights.weights.h5"
    callbacks_p1 = [
        keras.callbacks.EarlyStopping(
            monitor="val_loss", patience=4, restore_best_weights=True
        ),
        keras.callbacks.ReduceLROnPlateau(
            monitor="val_loss", factor=0.5, patience=2, min_lr=1e-6
        ),
    ]

    # --- Phase 1: Train classification head ---
    print("\n=== Phase 1: Training Classification Head (Base Frozen) ===")
    training_model.compile(
        optimizer=keras.optimizers.Adam(learning_rate=1e-3),
        loss="sparse_categorical_crossentropy",
        metrics=["accuracy"],
    )
    t0 = time.time()
    training_model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=10,
        class_weight=class_weights,
        callbacks=callbacks_p1,
    )
    print(f"Phase 1 completed in {time.time() - t0:.1f}s")

    # --- Phase 2: Fine-tuning top base layers ---
    print("\n=== Phase 2: Fine-Tuning MobileNetV3 (Top 40 Layers Unfrozen) ===")
    base.trainable = True
    for layer in base.layers[:-40]:
        layer.trainable = False

    callbacks_p2 = [
        keras.callbacks.EarlyStopping(
            monitor="val_loss", patience=4, restore_best_weights=True
        ),
        keras.callbacks.ReduceLROnPlateau(
            monitor="val_loss", factor=0.5, patience=2, min_lr=1e-6
        ),
    ]

    training_model.compile(
        optimizer=keras.optimizers.Adam(learning_rate=1e-4),
        loss="sparse_categorical_crossentropy",
        metrics=["accuracy"],
    )
    t0 = time.time()
    training_model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=12,
        class_weight=class_weights,
        callbacks=callbacks_p2,
    )
    print(f"Phase 2 completed in {time.time() - t0:.1f}s")

    # --- Evaluation on untouched Test Set ---
    print("\n=== Evaluating on Untouched Test Set ===")
    y_true: list[int] = []
    y_probs: list[np.ndarray] = []
    sample_images: np.ndarray | None = None

    for images, labels in test_ds:
        if sample_images is None:
            sample_images = images[:5].numpy()
        y_true.extend(labels.numpy().tolist())
        y_probs.extend(inference_model.predict(images, verbose=0))

    true_arr = np.asarray(y_true)
    probs_arr = np.asarray(y_probs)
    pred_arr = probs_arr.argmax(axis=1)
    max_confs = probs_arr.max(axis=1)

    acc = float(np.mean(pred_arr == true_arr))
    cm = confusion_matrix(true_arr, pred_arr, labels=np.arange(len(CLASSES))).tolist()
    report = classification_report(
        true_arr,
        pred_arr,
        labels=np.arange(len(CLASSES)),
        target_names=CLASSES,
        output_dict=True,
        zero_division=0,
    )

    print(f"Test Accuracy: {acc * 100:.2f}%")
    print(f"Macro F1-Score: {report['macro avg']['f1-score']:.4f}")
    for cls in CLASSES:
        print(f"  {cls}: P={report[cls]['precision']:.3f}, R={report[cls]['recall']:.3f}, F1={report[cls]['f1-score']:.3f}")

    # --- Evaluation on Out-of-Scope (OOS) Test Set ---
    print("\n=== Evaluating on Out-of-Scope (OOS) Test Set ===")
    oos_dir = DATA_DIR / "out_of_scope_test"
    oos_results = {}
    all_oos_confs = []

    if oos_dir.exists():
        for oos_subdir in sorted(oos_dir.iterdir()):
            if not oos_subdir.is_dir():
                continue
            oos_name = oos_subdir.name
            oos_files = sorted(list(oos_subdir.glob("*.jpg")))
            if not oos_files:
                continue
            imgs_list = []
            for fp in oos_files:
                img = keras.utils.load_img(fp, target_size=IMAGE_SIZE)
                arr = keras.utils.img_to_array(img)
                imgs_list.append(arr)
            oos_batch = np.array(imgs_list)
            oos_pred_probs = inference_model.predict(oos_batch, verbose=0)
            oos_max_c = oos_pred_probs.max(axis=1)
            all_oos_confs.extend(oos_max_c.tolist())
            oos_results[oos_name] = {
                "count": len(oos_files),
                "mean_confidence": float(np.mean(oos_max_c)),
                "max_confidence": float(np.max(oos_max_c)),
                "fraction_above_0_60": float(np.mean(oos_max_c >= 0.60)),
                "fraction_above_0_70": float(np.mean(oos_max_c >= 0.70)),
                "fraction_above_0_80": float(np.mean(oos_max_c >= 0.80)),
            }
            print(f"  OOS {oos_name}: mean_conf={np.mean(oos_max_c):.3f}, >=0.70: {np.mean(oos_max_c >= 0.70)*100:.1f}%")

    # Threshold calibration analysis
    candidate_thresholds = [0.50, 0.60, 0.65, 0.70, 0.75, 0.80]
    calibration_analysis = {}
    for th in candidate_thresholds:
        in_scope_accepted = np.mean(max_confs >= th)
        in_scope_acc_at_th = (
            float(np.mean(pred_arr[max_confs >= th] == true_arr[max_confs >= th]))
            if np.any(max_confs >= th)
            else 0.0
        )
        oos_rejected = (
            float(np.mean(np.array(all_oos_confs) < th))
            if all_oos_confs
            else 0.0
        )
        calibration_analysis[f"{th:.2f}"] = {
            "in_scope_coverage": float(in_scope_accepted),
            "in_scope_accuracy_retained": float(in_scope_acc_at_th),
            "oos_rejection_rate": float(oos_rejected),
        }
        print(f"  Th={th:.2f}: In-Scope Cov={in_scope_accepted*100:.1f}%, In-Scope Acc={in_scope_acc_at_th*100:.1f}%, OOS Reject={oos_rejected*100:.1f}%")

    # Save Keras Model
    keras_path = OUTPUT_DIR / "padicare_five_class.keras"
    inference_model.save(keras_path)
    print(f"\nSaved Keras inference model: {keras_path}")

    # Export SavedModel and convert to TFLite
    print("Exporting and converting to TFLite...")
    with tempfile.TemporaryDirectory(dir=OUTPUT_DIR) as saved_model_dir:
        inference_model.export(saved_model_dir)
        converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)
        tflite_bytes = converter.convert()

    tflite_path = OUTPUT_DIR / "paddy_mobilenetv3_five_class.tflite"
    tflite_path.write_bytes(tflite_bytes)
    tflite_size_mb = len(tflite_bytes) / (1024 * 1024)
    print(f"Saved TFLite model: {tflite_path} ({tflite_size_mb:.2f} MB)")

    labels_path = OUTPUT_DIR / "labels.txt"
    labels_path.write_text("\n".join(CLASSES) + "\n", encoding="utf-8")

    # Verify Keras vs TFLite parity
    print("Verifying Keras vs TFLite parity on sample images...")
    interpreter = tf.lite.Interpreter(model_content=tflite_bytes)
    interpreter.allocate_tensors()
    input_details = interpreter.get_input_details()[0]
    output_details = interpreter.get_output_details()[0]

    max_delta = 0.0
    keras_outputs = inference_model.predict(sample_images, verbose=0)
    for img_arr, k_out in zip(sample_images, keras_outputs):
        interpreter.set_tensor(input_details["index"], img_arr[None, ...])
        interpreter.invoke()
        tfl_out = interpreter.get_tensor(output_details["index"])[0]
        delta = float(np.max(np.abs(tfl_out - k_out)))
        max_delta = max(max_delta, delta)

    print(f"Max Keras-TFLite probability delta: {max_delta:.8f}")
    if max_delta > 0.01:
        raise RuntimeError(f"TFLite parity failure: max delta {max_delta} exceeds 0.01!")

    metrics = {
        "status": "candidate_5_class_evaluation",
        "classes": list(CLASSES),
        "test_samples": len(true_arr),
        "accuracy": acc,
        "macro_f1": float(report["macro avg"]["f1-score"]),
        "weighted_f1": float(report["weighted avg"]["f1-score"]),
        "confusion_matrix": cm,
        "classification_report": report,
        "out_of_scope_evaluation": oos_results,
        "threshold_calibration": calibration_analysis,
        "recommended_threshold": 0.65,
        "keras_tflite_max_probability_delta": max_delta,
        "tflite_size_bytes": len(tflite_bytes),
    }

    metrics_path = OUTPUT_DIR / "evaluation_metrics.json"
    metrics_path.write_text(json.dumps(metrics, indent=2), encoding="utf-8")
    print(f"Metrics saved to {metrics_path}")
    return metrics


if __name__ == "__main__":
    os.environ.setdefault("TF_CPP_MIN_LOG_LEVEL", "2")
    train()
