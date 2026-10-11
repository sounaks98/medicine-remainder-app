#!/usr/bin/env python3
"""Download SmolVLM q4f16 ONNX trio (+ aux configs) per assets/models/model_manifest.json."""

from __future__ import annotations

import hashlib
import json
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MANIFEST = ROOT / "assets" / "models" / "model_manifest.json"
OUT_DIR = Path(__file__).resolve().parent


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def download(url: str, dest: Path, expected_size: int | None) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.is_file():
        if expected_size is not None and dest.stat().st_size == expected_size:
            print(f"skip (size ok): {dest.name}")
            return
        print(f"re-download: {dest.name} (size mismatch or unknown)")

    print(f"downloading {dest.name} ...")
    urllib.request.urlretrieve(url, dest)
    if expected_size is not None and dest.stat().st_size != expected_size:
        raise SystemExit(
            f"size mismatch for {dest.name}: got {dest.stat().st_size}, expected {expected_size}"
        )


def main() -> int:
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    checksums: dict[str, str] = {}

    for art in manifest["onnxArtifacts"]:
        dest = OUT_DIR / art["fileName"]
        download(art["url"], dest, art.get("sizeBytes"))
        checksums[art["fileName"]] = sha256_file(dest)
        print(f"  sha256 {art['fileName']}: {checksums[art['fileName']]}")

    for art in manifest.get("auxiliaryArtifacts", []):
        dest = OUT_DIR / art["fileName"]
        download(art["url"], dest, None)

    for art in manifest["onnxArtifacts"]:
        art["sha256"] = checksums[art["fileName"]]

    MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"updated checksums in {MANIFEST}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
