#!/usr/bin/env python3
"""Inspect SmolVLM q4f16 ONNX graphs: opset, operators, I/O tensor metadata."""

from __future__ import annotations

import json
import sys
from collections import Counter
from pathlib import Path

import onnx
from onnx import helper

SPIKE_DIR = Path(__file__).resolve().parent
MODELS = [
    "vision_encoder_q4f16.onnx",
    "embed_tokens_q4f16.onnx",
    "decoder_model_merged_q4f16.onnx",
]
OUT_JSON = SPIKE_DIR / "inspect_report.json"


def _dim_str(dim) -> str:
    if dim.dim_param:
        return dim.dim_param
    if dim.dim_value:
        return str(dim.dim_value)
    return "?"


def _shape(tensor_type) -> list[str]:
    if not tensor_type.HasField("shape"):
        return []
    return [_dim_str(d) for d in tensor_type.shape.dim]


def inspect_model(path: Path) -> dict:
    model = onnx.load(str(path), load_external_data=False)
    graph = model.graph
    ops = Counter(node.op_type for node in graph.node)
    inputs = []
    for vi in graph.input:
        tt = vi.type.tensor_type
        inputs.append(
            {
                "name": vi.name,
                "elem_type": helper.tensor_dtype_to_string(tt.elem_type),
                "shape": _shape(tt),
            }
        )
    outputs = []
    for vi in graph.output:
        tt = vi.type.tensor_type
        outputs.append(
            {
                "name": vi.name,
                "elem_type": helper.tensor_dtype_to_string(tt.elem_type),
                "shape": _shape(tt),
            }
        )
    return {
        "file": path.name,
        "size_bytes": path.stat().st_size,
        "ir_version": model.ir_version,
        "opset_imports": [
            {"domain": o.domain or "ai.onnx", "version": o.version}
            for o in model.opset_import
        ],
        "node_count": len(graph.node),
        "operators": dict(sorted(ops.items(), key=lambda x: (-x[1], x[0]))),
        "inputs": inputs,
        "outputs": outputs,
    }


def main() -> int:
    report = {"models": []}
    for name in MODELS:
        path = SPIKE_DIR / name
        if not path.is_file():
            print(f"missing: {path}", file=sys.stderr)
            return 1
        print(f"inspecting {name} ...")
        report["models"].append(inspect_model(path))

    OUT_JSON.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {OUT_JSON}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
