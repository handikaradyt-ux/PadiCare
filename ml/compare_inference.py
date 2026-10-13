"""
Compare and verify TFLite inference on Python with test images.
Prints exact tensor inputs and softmax outputs for sample images from each class.
"""

import os
import json
import numpy as np
import tensorflow as tf
from PIL import Image

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, "models", "paddy_mobilenetv3.tflite")
LABELS_PATH = os.path.join(BASE_DIR, "models", "labels.txt")
DATA_DIR = os.path.join(BASE_DIR, "data", "test")

with open(LABELS_PATH, "r") as f:
    labels = [line.strip() for line in f if line.strip()]

interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print("=== TFLite Model Metadata ===")
print("Input details:", input_details[0]["shape"], input_details[0]["dtype"])
print("Output details:", output_details[0]["shape"], output_details[0]["dtype"])
print("Labels:", labels)

samples = [
    ("bacterial_leaf_blight", "bacterial_leaf_blight_0000.jpg"),
    ("brown_spot", "brown_spot_0000.jpg"),
    ("normal", "normal_0000.jpg"),
]

results = []

print("\n=== Verification on Sample Test Images ===")
for cls_name, fname in samples:
    img_path = os.path.join(DATA_DIR, cls_name, fname)
    if not os.path.exists(img_path):
        # Pick first available image in that class directory
        files = os.listdir(os.path.join(DATA_DIR, cls_name))
        img_path = os.path.join(DATA_DIR, cls_name, files[0])
        fname = files[0]

    img = Image.open(img_path).convert("RGB")
    img_resized = img.resize((224, 224), Image.Resampling.BILINEAR)
    img_array = np.array(img_resized, dtype=np.float32)
    img_tensor = np.expand_dims(img_array, axis=0)  # Shape (1, 224, 224, 3) with [0, 255]

    interpreter.set_tensor(input_details[0]["index"], img_tensor)
    interpreter.invoke()
    output_data = interpreter.get_tensor(output_details[0]["index"])[0]

    pred_idx = int(np.argmax(output_data))
    pred_label = labels[pred_idx]
    confidence = float(output_data[pred_idx])

    res = {
        "true_class": cls_name,
        "image_file": img_path,
        "predicted_class": pred_label,
        "confidence": confidence,
        "all_probabilities": {labels[i]: float(output_data[i]) for i in range(len(labels))},
    }
    results.append(res)
    print(f"\nImage: {cls_name}/{fname}")
    print(f"  True Label     : {cls_name}")
    print(f"  Predicted Label: {pred_label}")
    print(f"  Confidence     : {confidence:.4f}")
    print(f"  Probabilities  : {res['all_probabilities']}")

out_file = os.path.join(BASE_DIR, "models", "sample_verification_results.json")
with open(out_file, "w") as f:
    json.dump(results, f, indent=2)
print(f"\nVerification results saved to {out_file}")
