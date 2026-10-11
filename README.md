# Medicine Reminder App

Offline-first Flutter app for capturing prescription images (or **entering prescriptions manually**), extracting medication fields on device, confirming details with the user, and persisting data in a **single in-app database** scoped by **local user profile** (multiple profiles per device, no cloud login). Local reminders follow human review. The product path is **OCR-first** with **prescription-image verification**; optional SmolVLM ONNX enhancement is gated behind a Phase 2 feasibility spike.

**Primary target:** Android phones (4–6 GB RAM). iOS may share OCR flows later.

## Prerequisites

| Tool | Version |
|------|---------|
| [Flutter](https://docs.flutter.dev/get-started/install) | **3.27+** (stable channel) |
| Dart | **3.7+** (bundled with Flutter) |
| Android SDK | **minSdk 30** (LiteRT-LM Gemma spike); compile/target SDK at latest stable (e.g. 35) |
| JDK | As required by your Flutter/Android Studio install |

Verify your environment:

```bash
flutter doctor
```

## Getting started

1. Clone the repository and open the project root.
2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app on a connected device or emulator:

   ```bash
   flutter run
   ```

### Gemma 3n LiteRT-LM spike (debug, optional)

Requires a **physical arm64** Android device (API 30+), Hugging Face Gemma license, and ~3.7 GB storage for `gemma-3n-E2B-it-int4.litertlm`:

```bash
flutter run --dart-define=HUGGINGFACE_TOKEN=hf_...
```

Open **Medicines → flask icon → Gemma spike**. See `tool/model_spike/gemma3n/README.md` and `docs/model-research.md` §10.

4. **Drift code generation** (required after changing database tables under `lib/data/database/`):

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

   Watch mode during development:

   ```bash
   dart run build_runner watch --delete-conflicting-outputs
   ```

## Key dependencies

| Package | Role |
|---------|------|
| `flutter_riverpod` | State management and dependency injection |
| `go_router` | Declarative navigation (capture → review → confirm flows) |
| `drift` + `sqlite3_flutter_libs` | Type-safe SQLite persistence and migrations |
| `path_provider` / `path` | App-private file paths (images, DB) |

| `google_mlkit_text_recognition` | On-device OCR (bundled Latin model) |
| `flutter_edge_ai` + `flutter_edge_ai_litertlm` | **Debug-only** Gemma 3n E2B LiteRT-LM spike (not production extraction) |

Additional packages (notifications, secure storage) are added in later phases per the implementation plan.

## Project layout

```
lib/
  app/           # MaterialApp, go_router, Riverpod providers
  features/      # prescription, medicines, reminders (UI + domain + data)
  services/      # OCR, inference, notifications glue
  shared/        # Models, validation
  data/          # Drift database, migrations, tables
docs/            # Architecture, data model, testing (see docs/architecture.md)
```

See [docs/architecture.md](docs/architecture.md) for layers, data flow, and architecture decision records (ADRs).

## Build and test commands

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
flutter build apk --release
```

Integration tests (added in later phases):

```bash
flutter test integration_test
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/offline_ocr_test.dart
```

## Offline behavior (roadmap)

- **After install:** ML Kit bundled Latin OCR works without network once the app is on device (Phase 1).
- **Optional VLM:** Large ONNX weights are downloaded on first use while online; core OCR + manual edit remains available if the VLM path is not enabled (Phase 2–3).

Details will be expanded in `docs/offline-capabilities.md` (Phase 1).

## Documentation

| Document | Purpose |
|----------|---------|
| [docs/architecture.md](docs/architecture.md) | Layers, modules, ADRs |
| `.cursor/plans/implementaion.plan.md` | Full phased implementation plan (internal) |

## License and third-party models

SmolVLM weights (if used) are [Apache-2.0](https://huggingface.co/HuggingFaceTB/SmolVLM-500M-Instruct). ML Kit and ONNX Runtime have separate terms; a consolidated NOTICE section is planned for release (Phase 7).
