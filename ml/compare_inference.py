"""
Compare and verify 5-class TFLite inference on Python with test images.
Tests target classes and out-of-scope images to verify model calibration.
"""

from __future__ import annotations

import json
import os
from pathlib import Path
import numpy as np
import tensorflow as tf
from PIL import Image

BASE_DIR = Path(__file__).resolve().parent
MODEL_PATH = BASE_DIR / "models_v3" / "paddy_mobilenetv3_five_class.tflite"
LABELS_PATH = BASE_DIR / "models_v3" / "labels.txt"
DATA_DIR = BASE_DIR / "data_v3" / "test"
OOS_DIR = BASE_DIR / "data_v3" / "out_of_scope_test"

with open(LABELS_PATH, "r", encoding="utf-8") as f:
    labels = [line.strip() for line in f if line.strip()]

interpreter = tf.lite.Interpreter(model_path=str(MODEL_PATH))
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print("=== 5-Class TFLite Model Metadata ===")
print("Input shape & dtype :", input_details[0]["shape"], input_details[0]["dtype"])
print("Output shape & dtype:", output_details[0]["shape"], output_details[0]["dtype"])
print("Labels:", labels)

def predict_image(img_path: Path) -> dict:
    img = Image.open(img_path).convert("RGB")
    img_resized = img.resize((224, 224), Image.Resampling.BILINEAR)
    img_array = np.array(img_resized, dtype=np.float32)
    img_tensor = np.expand_dims(img_array, axis=0)  # Shape (1, 224, 224, 3) in [0, 255]

    interpreter.set_tensor(input_details[0]["index"], img_tensor)
    interpreter.invoke()
    output_data = interpreter.get_tensor(output_details[0]["index"])[0]

    pred_idx = int(np.argmax(output_data))
    pred_label = labels[pred_idx]
    confidence = float(output_data[pred_idx])

    return {
        "image_file": str(img_path.name),
        "predicted_label": pred_label,
        "confidence": confidence,
        "is_uncertain_at_0_65": bool(confidence < 0.65),
        "probabilities": {labels[i]: round(float(output_data[i]), 4) for i in range(len(labels))},
    }

results = {"in_scope_tests": [], "out_of_scope_tests": []}

print("\n=== In-Scope Test Samples (1 from each class) ===")
for cls_name in labels:
    cls_folder = DATA_DIR / cls_name
    first_file = next(cls_folder.glob("*.jpg"))
    res = predict_image(first_file)
    res["true_class"] = cls_name
    res["is_correct"] = bool(res["predicted_label"] == cls_name)
    results["in_scope_tests"].append(res)
    print(f"\n[{cls_name}] -> Pred: {res['predicted_label']} (conf: {res['confidence']:.3f}, correct: {res['is_correct']})")
    print(f"  Probs: {res['probabilities']}")

print("\n=== Out-of-Scope Test Samples (Rejection Check) ===")
for oos_name in ["dead_heart", "hispa", "leaf_scald", "narrow_brown_spot"]:
    folder = OOS_DIR / oos_name
    if folder.exists():
        first_file = next(folder.glob("*.jpg"))
        res = predict_image(first_file)
        res["oos_source"] = oos_name
        results["out_of_scope_tests"].append(res)
        print(f"\n[OOS: {oos_name}] -> Pred: {res['predicted_label']} (conf: {res['confidence']:.3f}, uncertain: {res['is_uncertain_at_0_65']})")
        print(f"  Probs: {res['probabilities']}")

out_file = BASE_DIR / "models_v3" / "sample_verification_results.json"
with open(out_file, "w", encoding="utf-8") as f:
    json.dump(results, f, indent=2)

print(f"\nVerification results saved to {out_file}")
