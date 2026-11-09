#!/usr/bin/env python3
"""Download Gemma 3n E2B LiteRT-LM weights from Hugging Face and prepare packaging chunks.

Writes:
  models/gemma3n/gemma-3n-E2B-it-int4.litertlm
  models/gemma3n/CHECKSUM.txt          (sha256 + byte size for Gradle / app)
  models/gemma3n/gemma.part0..part2    (each chunk <= 1.2 GiB for APK / asset packs)

Requires Hugging Face Gemma license on the account used for HF_TOKEN or HUGGINGFACE_TOKEN.
"""

from __future__ import annotations

import argparse
import hashlib
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "models" / "gemma3n"
HF_REPO = "google/gemma-3n-E2B-it-litert-lm"
ARTIFACT_NAME = "gemma-3n-E2B-it-int4.litertlm"
CHECKSUM_FILE = "CHECKSUM.txt"
CHUNK_BASENAME = "gemma.part"
NUM_CHUNKS = 3
# Play / APK packaging target: keep each chunk under 1.2 GiB (see GEMMA3N_ANDROID_DEPLOYMENT.md).
MAX_CHUNK_BYTES = int(1.2 * 1024**3)
READ_BUFFER = 8 * 1024 * 1024


def hf_token() -> str | None:
    for key in ("HF_TOKEN", "HUGGINGFACE_TOKEN", "HUGGING_FACE_HUB_TOKEN"):
        value = os.environ.get(key)
        if value:
            return value.strip()
    return None


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(READ_BUFFER), b""):
            digest.update(block)
    return digest.hexdigest()


def parse_checksum_file(path: Path) -> dict[str, str]:
    data: dict[str, str] = {}
    if not path.is_file():
        return data
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        data[key.strip()] = value.strip()
    return data


def write_checksum_file(
    path: Path,
    *,
    sha256: str,
    size_bytes: int,
    chunk_paths: list[Path],
) -> None:
    lines = [
        f"artifact={ARTIFACT_NAME}",
        f"sha256={sha256}",
        f"size_bytes={size_bytes}",
        f"chunk_count={len(chunk_paths)}",
        f"max_chunk_bytes={MAX_CHUNK_BYTES}",
    ]
    for index, chunk in enumerate(chunk_paths):
        lines.append(f"chunk_{index}={chunk.name}")
        lines.append(f"chunk_{index}_bytes={chunk.stat().st_size}")
        lines.append(f"chunk_{index}_sha256={sha256_file(chunk)}")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def artifact_is_valid(path: Path, expected_size: int | None, expected_sha256: str | None) -> bool:
    if not path.is_file():
        return False
    size = path.stat().st_size
    if expected_size is not None and size != expected_size:
        print(
            f"refusing short or mismatched file {path.name}: "
            f"on-disk {size} bytes, expected {expected_size}",
            file=sys.stderr,
        )
        return False
    if expected_sha256:
        actual = sha256_file(path)
        if actual.lower() != expected_sha256.lower():
            print(
                f"checksum mismatch for {path.name}: expected {expected_sha256}, got {actual}",
                file=sys.stderr,
            )
            return False
    return True


def hub_expected_metadata(token: str | None) -> tuple[int | None, str | None]:
    from huggingface_hub import HfApi

    api = HfApi(token=token)
    paths = api.get_paths_info(repo_id=HF_REPO, paths=[ARTIFACT_NAME], token=token)
    if not paths:
        return None, None
    info = paths[0]
    return info.size, getattr(info, "lfs", None) and getattr(info.lfs, "sha256", None)


def download_artifact(dest: Path, token: str | None, force: bool) -> Path:
    from huggingface_hub import hf_hub_download
    from huggingface_hub.errors import HfHubHTTPError

    expected_size, expected_sha256 = hub_expected_metadata(token)
    checksum_path = OUT_DIR / CHECKSUM_FILE
    recorded = parse_checksum_file(checksum_path)
    if not expected_sha256 and recorded.get("sha256"):
        expected_sha256 = recorded["sha256"]
    if expected_size is None and recorded.get("size_bytes"):
        try:
            expected_size = int(recorded["size_bytes"])
        except ValueError:
            pass

    if not force and artifact_is_valid(dest, expected_size, expected_sha256):
        print(f"skip download (size and sha256 ok): {dest}")
        return dest

    if dest.is_file() and not force:
        print(f"removing incomplete or invalid artifact: {dest.name}")
        dest.unlink()

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    print(f"downloading {HF_REPO}/{ARTIFACT_NAME} → {dest} ...")

    try:
        downloaded = hf_hub_download(
            repo_id=HF_REPO,
            filename=ARTIFACT_NAME,
            local_dir=str(OUT_DIR),
            local_dir_use_symlinks=False,
            resume_download=True,
            token=token,
        )
    except HfHubHTTPError as exc:
        status = exc.response.status_code if exc.response is not None else None
        if status in (401, 403):
            print(
                "Hugging Face rejected the request (HTTP "
                f"{status}). Accept the Gemma license at "
                f"https://huggingface.co/{HF_REPO} and set HF_TOKEN or "
                "HUGGINGFACE_TOKEN.",
                file=sys.stderr,
            )
            raise SystemExit(1) from exc
        raise

    resolved = Path(downloaded)
    if resolved.name != ARTIFACT_NAME:
        # hf_hub_download may nest under local_dir; normalize to OUT_DIR / ARTIFACT_NAME.
        target = OUT_DIR / ARTIFACT_NAME
        if resolved != target:
            if target.is_file():
                target.unlink()
            resolved.replace(target)
        resolved = target

    size = resolved.stat().st_size
    if expected_size is not None and size != expected_size:
        resolved.unlink(missing_ok=True)
        raise SystemExit(
            f"download size mismatch: got {size} bytes, hub reports {expected_size}"
        )

    return resolved


def split_artifact(source: Path, out_dir: Path) -> list[Path]:
    size = source.stat().st_size
    chunk_size = (size + NUM_CHUNKS - 1) // NUM_CHUNKS
    if chunk_size > MAX_CHUNK_BYTES:
        min_chunks = (size + MAX_CHUNK_BYTES - 1) // MAX_CHUNK_BYTES
        raise SystemExit(
            f"{ARTIFACT_NAME} is {size} bytes; {NUM_CHUNKS} chunks would need "
            f"{chunk_size} bytes each (max {MAX_CHUNK_BYTES}). "
            f"Need at least {min_chunks} chunks — update packaging constants."
        )

    for index in range(NUM_CHUNKS):
        stale = out_dir / f"{CHUNK_BASENAME}{index}"
        stale.unlink(missing_ok=True)

    chunk_paths: list[Path] = []
    consumed = 0
    with source.open("rb") as reader:
        for index in range(NUM_CHUNKS):
            if index == NUM_CHUNKS - 1:
                remaining = size - consumed
            else:
                remaining = chunk_size
            if remaining <= 0:
                break
            dest = out_dir / f"{CHUNK_BASENAME}{index}"
            with dest.open("wb") as writer:
                left = remaining
                while left > 0:
                    block = reader.read(min(READ_BUFFER, left))
                    if not block:
                        raise SystemExit(
                            f"unexpected EOF while splitting at chunk {index}"
                        )
                    writer.write(block)
                    left -= len(block)
                    consumed += len(block)
            if dest.stat().st_size > MAX_CHUNK_BYTES:
                raise SystemExit(
                    f"chunk {dest.name} exceeds limit: "
                    f"{dest.stat().st_size} > {MAX_CHUNK_BYTES}"
                )
            chunk_paths.append(dest)
            print(f"  wrote {dest.name} ({dest.stat().st_size} bytes)")

    if consumed != size:
        raise SystemExit(
            f"split verification failed: consumed {consumed} of {size} bytes"
        )

    return chunk_paths


def verify_concatenation(source: Path, chunks: list[Path]) -> None:
    digest = hashlib.sha256()
    total = 0
    for chunk in chunks:
        with chunk.open("rb") as handle:
            for block in iter(lambda: handle.read(READ_BUFFER), b""):
                digest.update(block)
                total += len(block)
    if total != source.stat().st_size:
        raise SystemExit("chunk total size does not match source artifact")
    if digest.hexdigest() != sha256_file(source):
        raise SystemExit("concatenated chunk sha256 does not match source artifact")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--force",
        action="store_true",
        help="Re-download even when the on-disk artifact matches hub size and sha256.",
    )
    parser.add_argument(
        "--skip-split",
        action="store_true",
        help="Only download / verify; do not rewrite gemma.part* chunks.",
    )
    args = parser.parse_args()

    token = hf_token()
    if token is None:
        print(
            "warning: no HF_TOKEN / HUGGINGFACE_TOKEN set; gated download may fail",
            file=sys.stderr,
        )

    dest = OUT_DIR / ARTIFACT_NAME
    artifact_path = download_artifact(dest, token, args.force)

    file_sha = sha256_file(artifact_path)
    file_size = artifact_path.stat().st_size
    print(f"artifact sha256: {file_sha}")
    print(f"artifact size:   {file_size} bytes")

    chunk_paths: list[Path] = []
    if not args.skip_split:
        print(f"splitting into {NUM_CHUNKS} chunks (max {MAX_CHUNK_BYTES} bytes each) ...")
        chunk_paths = split_artifact(artifact_path, OUT_DIR)
        verify_concatenation(artifact_path, chunk_paths)

    checksum_path = OUT_DIR / CHECKSUM_FILE
    if chunk_paths:
        write_checksum_file(
            checksum_path,
            sha256=file_sha,
            size_bytes=file_size,
            chunk_paths=chunk_paths,
        )
    else:
        existing_chunks = sorted(OUT_DIR.glob(f"{CHUNK_BASENAME}*"))
        if existing_chunks:
            write_checksum_file(
                checksum_path,
                sha256=file_sha,
                size_bytes=file_size,
                chunk_paths=existing_chunks,
            )
        else:
            checksum_path.write_text(
                "\n".join(
                    [
                        f"artifact={ARTIFACT_NAME}",
                        f"sha256={file_sha}",
                        f"size_bytes={file_size}",
                    ]
                )
                + "\n",
                encoding="utf-8",
            )

    print(f"wrote {checksum_path.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
