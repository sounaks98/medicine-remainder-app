# SmolVLM ONNX spike tools (Phase 2)

## Setup

```bash
pip install -r tool/model_spike/requirements.txt
python tool/model_spike/download_models.py
```

## Commands

| Script | Purpose |
|--------|---------|
| `download_models.py` | Fetch q4f16 trio + configs; updates SHA-256 in `assets/models/model_manifest.json` |
| `inspect_onnx.py` | Writes `inspect_report.json` (ops + I/O tensors) |
| `run_reference.py` | Desktop generation; output under `output/reference_generation.json` |

## Android ORT load test

See `docs/model-research.md` §5 for `adb push` paths and `connectedDebugAndroidTest`.
