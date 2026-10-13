"""
Audit and extract rice leaf dataset for PadiCare.
Dataset: Masud et al., PLOS ONE 2026 / Project-AgML (CC-BY-4.0)
Extracts unique images, removes duplicates, and performs stratified 70/15/15 train/val/test split.
"""

import os
import io
import json
import hashlib
from collections import defaultdict
import pyarrow.parquet as pq
from PIL import Image
from sklearn.model_selection import train_test_split

PARQUET_PATH = r"C:\Users\ASUS\.cache\huggingface\hub\datasets--Project-AgML--rice_leaf_disease_classification_bd\snapshots\5c95947033c83bba8a5944abff5b235e924596b0\data\train-00000-of-00001.parquet"
OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "data")

CLASS_MAPPING = {
    0: "bacterial_leaf_blight",
    1: "brown_spot",
    2: "normal",  # PRD target: healthy -> normal
}

OUT_OF_SCOPE_MAPPING = {
    3: "leaf_blast",
    4: "leaf_scald",
    5: "narrow_brown_spot"
}

def audit_and_extract():
    print(f"Reading parquet file: {PARQUET_PATH}")
    table = pq.read_table(PARQUET_PATH)
    images_col = table["image"]
    labels_col = table["label"]
    total_records = len(labels_col)
    print(f"Total records in dataset: {total_records}")

    records_by_class = defaultdict(list)
    out_of_scope_records = defaultdict(list)
    seen_hashes = set()
    duplicate_count = 0

    for i in range(total_records):
        raw_bytes = images_col[i]["bytes"].as_py()
        orig_path = images_col[i]["path"].as_py() if "path" in images_col[i] else f"img_{i}.jpg"
        lbl = labels_col[i].as_py()

        sha256 = hashlib.sha256(raw_bytes).hexdigest()
        if sha256 in seen_hashes:
            duplicate_count += 1
            continue
        seen_hashes.add(sha256)

        record = {
            "index": i,
            "filename": orig_path if orig_path else f"img_{i}.jpg",
            "bytes": raw_bytes,
            "sha256": sha256,
        }

        if lbl in CLASS_MAPPING:
            records_by_class[CLASS_MAPPING[lbl]].append(record)
        elif lbl in OUT_OF_SCOPE_MAPPING:
            out_of_scope_records[OUT_OF_SCOPE_MAPPING[lbl]].append(record)

    print(f"Filtered out {duplicate_count} duplicate images. Unique images: {len(seen_hashes)}")

    summary = {
        "dataset_name": "Project-AgML Rice Leaf Disease Classification (Masud et al., PLOS ONE 2026)",
        "source_license": "CC-BY-4.0",
        "total_raw_records": total_records,
        "duplicate_count": duplicate_count,
        "unique_records": len(seen_hashes),
        "target_classes": {},
        "out_of_scope_classes": {},
        "splits": {
            "train": {},
            "val": {},
            "test": {}
        }
    }

    # Prepare directories
    for split in ["train", "val", "test"]:
        for cls_name in CLASS_MAPPING.values():
            os.makedirs(os.path.join(OUTPUT_DIR, split, cls_name), exist_ok=True)

    for cls_name in OUT_OF_SCOPE_MAPPING.values():
        os.makedirs(os.path.join(OUTPUT_DIR, "out_of_scope_test", cls_name), exist_ok=True)

    # Perform stratified split per target class
    RANDOM_SEED = 42

    for cls_name, items in records_by_class.items():
        summary["target_classes"][cls_name] = len(items)

        # 70% train, 30% temp (which splits 15% val, 15% test)
        train_items, temp_items = train_test_split(items, test_size=0.30, random_state=RANDOM_SEED)
        val_items, test_items = train_test_split(temp_items, test_size=0.50, random_state=RANDOM_SEED)

        summary["splits"]["train"][cls_name] = len(train_items)
        summary["splits"]["val"][cls_name] = len(val_items)
        summary["splits"]["test"][cls_name] = len(test_items)

        for split_name, split_list in [("train", train_items), ("val", val_items), ("test", test_items)]:
            split_dir = os.path.join(OUTPUT_DIR, split_name, cls_name)
            for idx, item in enumerate(split_list):
                file_path = os.path.join(split_dir, f"{cls_name}_{idx:04d}.jpg")
                with open(file_path, "wb") as f:
                    f.write(item["bytes"])

    # Save out_of_scope images for testing ambiguity and threshold
    for cls_name, items in out_of_scope_records.items():
        summary["out_of_scope_classes"][cls_name] = len(items)
        target_dir = os.path.join(OUTPUT_DIR, "out_of_scope_test", cls_name)
        for idx, item in enumerate(items):
            file_path = os.path.join(target_dir, f"{cls_name}_{idx:04d}.jpg")
            with open(file_path, "wb") as f:
                f.write(item["bytes"])

    report_path = os.path.join(os.path.dirname(__file__), "dataset_audit.json")
    with open(report_path, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2)

    print("\nDataset Audit and Extraction Complete:")
    print(json.dumps(summary, indent=2))
    return summary

if __name__ == "__main__":
    audit_and_extract()
