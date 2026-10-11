# Gemma 3n E2B LiteRT-LM spike (Phase G1)

Artifact: **`gemma-3n-E2B-it-int4.litertlm`** from [google/gemma-3n-E2B-it-litert-lm](https://huggingface.co/google/gemma-3n-E2B-it-litert-lm).

## Requirements

- Physical **arm64** Android device (**minSdk 30**). LiteRT-LM does not run on x86 emulators.
- Hugging Face account with Gemma license accepted.
- Build/run with token (never commit):

```bash
flutter run --dart-define=HUGGINGFACE_TOKEN=hf_...
```

## In-app spike

Debug builds: **Medicines** screen → **Gemma spike** (flask icon).

## Optional: sideload for development

```bash
adb push gemma-3n-E2B-it-int4.litertlm /data/local/tmp/
```

Then use “Import from file” on the spike screen if implemented, or install via the in-app download button.

## SmolVLM experiment

The ONNX SmolVLM spike remains documented separately in `docs/model-research.md` §1–8. This directory is an independent LiteRT-LM track.
