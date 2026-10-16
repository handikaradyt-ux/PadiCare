"""
Audit and prepare five-class rice leaf disease dataset for PadiCare.
Target classes:
  0: bacterial_leaf_blight
  1: brown_spot
  2: leaf_blast
  3: normal
  4: tungro

Out-of-scope test classes for rejection calibration:
  - hispa (insect pest)
  - dead_heart (stem borer symptom)
  - leaf_scald (fungal, insufficient volume)
  - narrow_brown_spot (fungal, visual confounder)

Sources (all CC-BY-4.0 verified):
  1. Sethy et al., Mendeley Data / AgML India (2020/2024)
  2. Paddy Doctor, IEEE Dataport / AgML (2022)
  3. Masud et al., PLOS ONE / AgML Bangladesh (2026)
"""

from __future__ import annotations

import hashlib
import io
import json
import os
import random
from collections import defaultdict
from pathlib import Path
from PIL import Image
import pyarrow.parquet as pq
from sklearn.model_selection import train_test_split

ROOT = Path(__file__).resolve().parent
DESTINATION = ROOT / "data_v3"
SEED = 42

TARGET_CLASSES = [
    "bacterial_leaf_blight",
    "brown_spot",
    "leaf_blast",
    "normal",
    "tungro",
]

TARGET_PER_CLASS = 600
OOS_PER_CLASS = 100


def extract_and_prepare() -> dict:
    random.seed(SEED)
    print("=== AUDIT AND EXTRACT 5-CLASS DATASET ===")

    seen_hashes = set()
    records_by_class = defaultdict(list)
    records_by_source = defaultdict(lambda: defaultdict(int))
    oos_records = defaultdict(list)

    # 1. AgML India (Sethy et al., CC-BY-4.0)
    india_parquet = ROOT.parent / "dataset_sources" / "rice_leaf_disease_india.parquet"
    if india_parquet.exists():
        print(f"Reading India dataset: {india_parquet}")
        table = pq.read_table(india_parquet)
        img_col = table["image"]
        lbl_col = table["label"]
        india_map = {
            0: "bacterial_leaf_blight",
            1: "leaf_blast",
            2: "brown_spot",
            3: "tungro",
        }
        for i in range(len(table)):
            lbl_idx = lbl_col[i].as_py()
            if lbl_idx not in india_map:
                continue
            cls_name = india_map[lbl_idx]
            raw_bytes = img_col[i]["bytes"].as_py()
            h = hashlib.sha256(raw_bytes).hexdigest()
            if h in seen_hashes:
                continue
            seen_hashes.add(h)
            try:
                img = Image.open(io.BytesIO(raw_bytes))
                img.verify()
            except Exception:
                continue
            records_by_class[cls_name].append({
                "source": "AgML_India_Sethy",
                "bytes": raw_bytes,
                "sha256": h,
            })
            records_by_source["AgML_India_Sethy"][cls_name] += 1
        print("India dataset loaded.")

    # 2. Paddy Doctor (IEEE Dataport, CC-BY-4.0)
    for part_name in ["paddy_doctor_part0.parquet", "paddy_doctor_part1.parquet"]:
        pd_parquet = ROOT.parent / "dataset_sources" / part_name
        if pd_parquet.exists():
            print(f"Reading Paddy Doctor: {pd_parquet}")
            table = pq.read_table(pd_parquet)
            img_col = table["image"]
            lbl_col = table["label"]
            pd_target_map = {
                0: "bacterial_leaf_blight",
                3: "leaf_blast",
                4: "brown_spot",
                8: "normal",
                9: "tungro",
            }
            pd_oos_map = {
                5: "dead_heart",
                7: "hispa",
            }
            for i in range(len(table)):
                lbl_idx = lbl_col[i].as_py()
                raw_bytes = img_col[i]["bytes"].as_py()
                h = hashlib.sha256(raw_bytes).hexdigest()
                if h in seen_hashes:
                    continue
                seen_hashes.add(h)
                try:
                    img = Image.open(io.BytesIO(raw_bytes))
                    img.verify()
                except Exception:
                    continue

                if lbl_idx in pd_target_map:
                    cls_name = pd_target_map[lbl_idx]
                    records_by_class[cls_name].append({
                        "source": "PaddyDoctor_IEEE",
                        "bytes": raw_bytes,
                        "sha256": h,
                    })
                    records_by_source["PaddyDoctor_IEEE"][cls_name] += 1
                elif lbl_idx in pd_oos_map:
                    oos_name = pd_oos_map[lbl_idx]
                    oos_records[oos_name].append({
                        "source": "PaddyDoctor_IEEE",
                        "bytes": raw_bytes,
                        "sha256": h,
                    })
                    records_by_source["PaddyDoctor_IEEE"][oos_name] += 1

    # 3. AgML Bangladesh (Masud et al., CC-BY-4.0) from local ml/data/
    local_data = ROOT / "data"
    if local_data.exists():
        print("Reading local AgML Bangladesh dataset...")
        bd_target_map = {
            "bacterial_leaf_blight": "bacterial_leaf_blight",
            "brown_spot": "brown_spot",
            "normal": "normal",
        }
        for split in ["train", "val", "test"]:
            for cls_folder, target_cls in bd_target_map.items():
                folder = local_data / split / cls_folder
                if not folder.exists():
                    continue
                for img_path in folder.glob("*.jpg"):
                    raw_bytes = img_path.read_bytes()
                    h = hashlib.sha256(raw_bytes).hexdigest()
                    if h in seen_hashes:
                        continue
                    seen_hashes.add(h)
                    records_by_class[target_cls].append({
                        "source": "AgML_BD_Masud",
                        "bytes": raw_bytes,
                        "sha256": h,
                    })
                    records_by_source["AgML_BD_Masud"][target_cls] += 1

        oos_folder = local_data / "out_of_scope_test"
        if oos_folder.exists():
            for oos_name in ["leaf_blast", "leaf_scald", "narrow_brown_spot"]:
                folder = oos_folder / oos_name
                if not folder.exists():
                    continue
                for img_path in folder.glob("*.jpg"):
                    raw_bytes = img_path.read_bytes()
                    h = hashlib.sha256(raw_bytes).hexdigest()
                    if h in seen_hashes:
                        continue
                    seen_hashes.add(h)
                    if oos_name == "leaf_blast":
                        records_by_class["leaf_blast"].append({
                            "source": "AgML_BD_Masud",
                            "bytes": raw_bytes,
                            "sha256": h,
                        })
                        records_by_source["AgML_BD_Masud"]["leaf_blast"] += 1
                    else:
                        oos_records[oos_name].append({
                            "source": "AgML_BD_Masud",
                            "bytes": raw_bytes,
                            "sha256": h,
                        })
                        records_by_source["AgML_BD_Masud"][oos_name] += 1

    print("\n--- Available unique images per target class ---")
    for cls in TARGET_CLASSES:
        print(f"  {cls}: {len(records_by_class[cls])}")
    print("\n--- Available unique images per OOS class ---")
    for cls in oos_records:
        print(f"  {cls}: {len(oos_records[cls])}")

    # Prepare stratified balanced dataset
    summary = {
        "dataset_name": "PadiCare 5-Class Multi-Source Rice Leaf Disease Dataset",
        "access_date": "2026-10-13",
        "classes": TARGET_CLASSES,
        "seed": SEED,
        "sources": {
            "AgML_India_Sethy": {
                "reference": "Sethy et al., Mendeley Data V2 (2024), doi:10.17632/fwcj7stb8r.2",
                "license": "CC-BY-4.0",
            },
            "PaddyDoctor_IEEE": {
                "reference": "Chithambaram et al., IEEE Dataport (2022), doi:10.21227/hz4v-af08",
                "license": "CC-BY-4.0",
            },
            "AgML_BD_Masud": {
                "reference": "Masud et al., PLOS ONE (2026), CC-BY-4.0",
                "license": "CC-BY-4.0",
            },
        },
        "records_by_source": {k: dict(v) for k, v in records_by_source.items()},
        "splits": {
            "train": {},
            "val": {},
            "test": {},
        },
        "out_of_scope_test": {},
    }

    # Clear destination
    for split in ["train", "val", "test"]:
        for cls in TARGET_CLASSES:
            out_dir = DESTINATION / split / cls
            out_dir.mkdir(parents=True, exist_ok=True)

    oos_dir = DESTINATION / "out_of_scope_test"
    oos_dir.mkdir(parents=True, exist_ok=True)

    # Subsample to TARGET_PER_CLASS with fixed seed and split 70 / 15 / 15
    for cls in TARGET_CLASSES:
        items = records_by_class[cls]
        random.seed(SEED)
        random.shuffle(items)
        selected = items[:TARGET_PER_CLASS]

        train_items, temp_items = train_test_split(
            selected, test_size=0.30, random_state=SEED
        )
        val_items, test_items = train_test_split(
            temp_items, test_size=0.50, random_state=SEED
        )

        partitions = {"train": train_items, "val": val_items, "test": test_items}
        for split_name, split_list in partitions.items():
            split_dir = DESTINATION / split_name / cls
            summary["splits"][split_name][cls] = len(split_list)
            for idx, item in enumerate(split_list):
                fp = split_dir / f"{cls}_{idx:04d}.jpg"
                fp.write_bytes(item["bytes"])

    # Prepare OOS test sets
    for oos_name, items in oos_records.items():
        random.seed(SEED)
        random.shuffle(items)
        selected_oos = items[:OOS_PER_CLASS]
        target_dir = oos_dir / oos_name
        target_dir.mkdir(parents=True, exist_ok=True)
        summary["out_of_scope_test"][oos_name] = len(selected_oos)
        for idx, item in enumerate(selected_oos):
            fp = target_dir / f"{oos_name}_{idx:04d}.jpg"
            fp.write_bytes(item["bytes"])

    manifest_path = DESTINATION / "dataset_manifest.json"
    manifest_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print("\nDataset extraction and manifest generation complete!")
    print(f"Manifest written to: {manifest_path}")
    print(json.dumps(summary["splits"], indent=2))
    return summary


if __name__ == "__main__":
    extract_and_prepare()
