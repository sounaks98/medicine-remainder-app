#!/usr/bin/env python3
"""
Desktop reference generation for SmolVLM-500M-Instruct q4f16 ONNX trio.
Adapted from HuggingFace SmolVLM ONNX sample (256M); uses pinned 500M weights locally.
"""

from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path

import numpy as np
import onnxruntime as ort
from PIL import Image
from transformers import AutoConfig, AutoProcessor

SPIKE_DIR = Path(__file__).resolve().parent
OUTPUT_DIR = SPIKE_DIR / "output"
REVISION = "a7da5b986cb59b408707209984f360a5f4ad7e47"
MODEL_ID = "HuggingFaceTB/SmolVLM-500M-Instruct"

VISION = SPIKE_DIR / "vision_encoder_q4f16.onnx"
EMBED = SPIKE_DIR / "embed_tokens_q4f16.onnx"
DECODER = SPIKE_DIR / "decoder_model_merged_q4f16.onnx"


def _empty_past_key_values(
    batch_size: int,
    num_layers: int,
    num_kv_heads: int,
    head_dim: int,
    kv_dtype: type,
) -> dict[str, np.ndarray]:
    return {
        f"past_key_values.{layer}.{kv}": np.zeros(
            [batch_size, num_kv_heads, 0, head_dim],
            dtype=kv_dtype,
        )
        for layer in range(num_layers)
        for kv in ("key", "value")
    }


def generate(
    image_path: Path,
    prompt: str,
    max_new_tokens: int,
) -> tuple[str, dict]:
    if not all(p.is_file() for p in (VISION, EMBED, DECODER)):
        raise SystemExit("Missing ONNX files. Run download_models.py first.")

    config = AutoConfig.from_pretrained(MODEL_ID, revision=REVISION)
    processor = AutoProcessor.from_pretrained(MODEL_ID, revision=REVISION)

    image = Image.open(image_path).convert("RGB")
    messages = [
        {
            "role": "user",
            "content": [
                {"type": "image"},
                {"type": "text", "text": prompt},
            ],
        }
    ]
    text = processor.apply_chat_template(messages, add_generation_prompt=True)
    inputs = processor(text=text, images=[image], return_tensors="np")

    text_cfg = getattr(config, "text_config", config)
    image_token_id = int(config.image_token_id)
    eos_token_id = int(text_cfg.eos_token_id)
    num_layers = int(text_cfg.num_hidden_layers)
    num_kv_heads = int(text_cfg.num_key_value_heads)
    head_dim = int(text_cfg.head_dim)

    so = ort.SessionOptions()
    so.log_severity_level = 3
    # Avoid ORT buffer reuse bugs on dynamic-seq prefill (q4f16 decoder).
    so.enable_mem_pattern = False
    so.enable_cpu_mem_arena = False
    providers = ["CPUExecutionProvider"]
    vision_session = ort.InferenceSession(str(VISION), so, providers=providers)
    embed_session = ort.InferenceSession(str(EMBED), so, providers=providers)
    decoder_session = ort.InferenceSession(str(DECODER), so, providers=providers)

    batch_size = int(inputs["input_ids"].shape[0])
    image_features = None
    prompt_ids = inputs["input_ids"].astype(np.int64)
    generated: list[int] = []
    t0 = time.perf_counter()

    # Full-sequence prefill each step (no KV-cache decode). Slower but avoids an
    # ORT CPU buffer-reuse failure on q4f16 after prefill→decode shape change (P2 spike).
    for _ in range(max_new_tokens):
        if generated:
            tail = np.array(generated, dtype=np.int64).reshape(1, -1)
            input_ids = np.concatenate([prompt_ids, tail], axis=-1)
        else:
            input_ids = prompt_ids

        inputs_embeds = embed_session.run(None, {"input_ids": input_ids})[0]

        if image_features is None:
            image_features = vision_session.run(
                ["image_features"],
                {
                    "pixel_values": inputs["pixel_values"].astype(np.float32),
                    "pixel_attention_mask": inputs["pixel_attention_mask"].astype(np.bool_),
                },
            )[0]

        mask = input_ids == image_token_id
        if mask.any():
            inputs_embeds[mask] = image_features.reshape(-1, image_features.shape[-1]).astype(
                inputs_embeds.dtype,
            )

        attention_mask = np.ones(input_ids.shape, dtype=np.int64)
        position_ids = np.cumsum(attention_mask, axis=-1).astype(np.int64)
        past_key_values = _empty_past_key_values(
            batch_size,
            num_layers,
            num_kv_heads,
            head_dim,
            np.float16,
        )

        logits, *_present = decoder_session.run(
            None,
            {
                "inputs_embeds": inputs_embeds.astype(np.float32),
                "attention_mask": attention_mask,
                "position_ids": position_ids,
                **past_key_values,
            },
        )

        next_id = int(logits[:, -1].argmax(-1).item())
        generated.append(next_id)

        if next_id == eos_token_id:
            break

    elapsed = time.perf_counter() - t0
    text_out = processor.tokenizer.decode(generated, skip_special_tokens=True)
    stats = {
        "tokens_generated": len(generated),
        "elapsed_seconds": round(elapsed, 3),
        "tokens_per_second": round(len(generated) / elapsed, 3) if elapsed > 0 else 0,
        "revision": REVISION,
        "quantization": "q4f16",
        "generation_mode": "full_sequence_prefill_per_token",
    }
    return text_out, stats


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--image",
        type=Path,
        default=None,
        help="Input image (default: synthetic 512x512 RGB)",
    )
    parser.add_argument(
        "--prompt",
        default="Describe this image in one sentence.",
    )
    parser.add_argument("--max-new-tokens", type=int, default=64)
    args = parser.parse_args()

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    if args.image is None:
        img_path = OUTPUT_DIR / "synthetic_rx_like.png"
        if not img_path.is_file():
            arr = np.full((512, 512, 3), 255, dtype=np.uint8)
            arr[40:80, 40:400] = 30
            Image.fromarray(arr).save(img_path)
        image_path = img_path
    else:
        image_path = args.image

    text_out, stats = generate(image_path, args.prompt, args.max_new_tokens)

    result = {
        "prompt": args.prompt,
        "image": str(image_path),
        "output_text": text_out,
        **stats,
    }
    out_file = OUTPUT_DIR / "reference_generation.json"
    out_file.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(text_out)
    print(json.dumps(stats, indent=2))
    print(f"wrote {out_file}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
