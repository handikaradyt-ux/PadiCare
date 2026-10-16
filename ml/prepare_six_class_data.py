"""Prepare an isolated six-class pilot without changing the shipped model.

The original three-class train/validation/test assignments are retained. The
three classes previously held out as out-of-scope are split once with seed 42.
Generated images are deliberately excluded.
"""

from __future__ import annotations

import json
import os
import shutil
from pathlib import Path

from sklearn.model_selection import train_test_split


ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / "data"
DESTINATION = ROOT / "data_v2"
PILOT_CLASSES = (
    "bacterial_leaf_blight",
    "brown_spot",
    "leaf_blast",
    "leaf_scald",
    "narrow_brown_spot",
    "normal",
)
NEW_CLASSES = ("leaf_blast", "leaf_scald", "narrow_brown_spot")
SEED = 42


def _images(directory: Path) -> list[Path]:
    return sorted(path for path in directory.iterdir() if path.suffix.lower() in {".jpg", ".jpeg", ".png"})


def _place(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists():
        if destination.stat().st_size != source.stat().st_size:
            raise ValueError(f"Existing destination differs: {destination}")
        return
    try:
        os.link(source, destination)
    except OSError:
        shutil.copy2(source, destination)


def prepare() -> dict:
    if not SOURCE.is_dir():
        raise FileNotFoundError(f"Source dataset missing: {SOURCE}")

    summary: dict[str, object] = {
        "purpose": "experimental six-class pilot; not shipped in PadiCare",
        "source": "Project-AgML rice leaf disease classification BD, CC BY 4.0",
        "seed": SEED,
        "classes": list(PILOT_CLASSES),
        "splits": {split: {} for split in ("train", "val", "test")},
        "notes": [
            "Original three-class split assignments preserved.",
            "Former out-of-scope images are now training/evaluation candidates, not unknown-class test data.",
            "Synthetic test_images_synthetic images are excluded.",
        ],
    }

    for class_name in PILOT_CLASSES:
        if class_name in NEW_CLASSES:
            images = _images(SOURCE / "out_of_scope_test" / class_name)
            if len(images) < 10:
                raise ValueError(f"Too few images for {class_name}: {len(images)}")
            train, remainder = train_test_split(images, test_size=0.30, random_state=SEED)
            val, test = train_test_split(remainder, test_size=0.50, random_state=SEED)
            partitions = {"train": train, "val": val, "test": test}
        else:
            partitions = {
                split: _images(SOURCE / split / class_name)
                for split in ("train", "val", "test")
            }

        for split, images in partitions.items():
            for image in images:
                _place(image, DESTINATION / split / class_name / image.name)
            summary["splits"][split][class_name] = len(images)

    report = ROOT / "models_v2" / "dataset_manifest.json"
    report.parent.mkdir(parents=True, exist_ok=True)
    report.write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(json.dumps(summary, indent=2))
    return summary


if __name__ == "__main__":
    prepare()
