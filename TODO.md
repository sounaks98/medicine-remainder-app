# Prioritized task tracker

Living checklist synced with [§12](.cursor/plans/implementaion.plan.md#12-prioritized-todomd-checklist) of the implementation plan. Update **Status** as work completes (`done` | `todo` | `blocked`).

**Phase 3** applies only if **P2-07** is **go**; if **no-go**, skip P3-01–P3-07 and continue at P4-01.

## Phase 0

| ID | P | Task | Paths | Deps | Acceptance | Verify | Status |
|----|---|------|-------|------|------------|--------|--------|
| P0-01 | P0 | `flutter create` + enable Android only if desired | `/` | — | APK builds | `flutter build apk` | done |
| P0-02 | P0 | Folder layout per §6 | `lib/**` | P0-01 | Analyze clean | `flutter analyze` | done |
| P0-03 | P0 | Add Riverpod, go_router, drift deps | `pubspec.yaml` | P0-01 | pub get ok | `flutter pub get` | done |
| P0-04 | P0 | `README.md` + `docs/architecture.md` | `docs/` | P0-02 | Onboarding steps | review | done |
| P0-05 | P0 | Sync `TODO.md` from §12 | `TODO.md` | P0-04 | All IDs present | review | done |
| P0-06 | P1 | Android minSdk 24, ML Kit bundled note | `android/` | P0-01 | manifest valid | build | todo |

## Phase 1

| ID | P | Task | Paths | Deps | Acceptance | Verify | Status |
|----|---|------|-------|------|------------|--------|--------|
| P1-01 | P0 | Image capture + gallery | `capture_screen.dart`, `prescription_image_store.dart` | P0-02 | Image saved private | widget test | todo |
| P1-02 | P0 | Image preprocess (rotate, resize) | `image_preprocessor.dart` | P1-01 | EXIF fixed | unit test | todo |
| P1-03 | P0 | ML Kit OCR service | `mlkit_ocr_service.dart` | P0-06 | Text non-empty on sample | device test | todo |
| P1-04 | P0 | OCR review UI | `ocr_review_screen.dart` | P1-03 | Shows image+text | widget test | todo |
| P1-05 | P1 | Offline smoke doc | `docs/offline-capabilities.md` | P1-04 | Steps reproducible | airplane mode | todo |
| P1-06 | P1 | Baseline rules parser stub | `ocr_rules_extraction_service.dart` | P1-03 | Draft with mostly `missing` | unit test | todo |

## Phase 2

| ID | P | Task | Paths | Deps | Acceptance | Verify | Status |
|----|---|------|-------|------|------------|--------|--------|
| P2-01 | P0 | Pin model revision manifest | `assets/models/model_manifest.json` | P0-01 | URLs + sizes | review | todo |
| P2-02 | P0 | Download q4f16 trio to local spike dir | `tool/model_spike/` | P2-01 | Files match HF sizes | script | todo |
| P2-03 | P0 | Inspect ONNX ops/IO with onnxruntime Python | `tool/model_spike/inspect_onnx.py` | P2-02 | Report in model-research | run script | todo |
| P2-04 | P0 | Desktop end-to-end generation | `tool/model_spike/run_reference.py` | P2-03 | Coherent answer | compare output | todo |
| P2-05 | P0 | Android ORT load each session | `android/.../SmolVlmOnnxBridge.kt` or spike app | P2-03 | No load error | logcat | todo |
| P2-06 | P0 | Memory + latency on 4GB device | `docs/model-research.md` | P2-05 | Metrics recorded | profiler | todo |
| P2-07 | P0 | Go/no-go decision recorded | `docs/model-research.md` | P2-06 | Explicit go/no-go | review | todo |

## Phase 3 (blocked until P2-07 go)

| ID | P | Task | Paths | Deps | Acceptance | Verify | Status |
|----|---|------|-------|------|------------|--------|--------|
| P3-01 | P0 | `MedicationExtractionService` interface | `medication_extraction_service.dart` | P1-06 | Swappable impls | analyze | blocked |
| P3-02 | P0 | Model download + checksum | `model_asset_manager.dart` | P2-01 | Resume download | integration | blocked |
| P3-03 | P0 | Tokenizer + chat template | `tokenizer_service.dart` | P2-04 | Tokens match reference | unit test | blocked |
| P3-04 | P0 | Idefics3 image preprocess | `image_preprocessor.dart` | P2-04 | Tensor shape match | unit test | blocked |
| P3-05 | P0 | Generation loop + KV cache | `smolvlm_generation_loop.dart` | P2-05 | ≥50 tokens | device test | blocked |
| P3-06 | P1 | JSON prompt + parse | `smolvlm_onnx_extraction_service.dart` | P3-05 | Valid draft JSON | integration | blocked |
| P3-07 | P1 | Cancel + dispose | same | P3-05 | No leak after 10x | device test | blocked |

## Phase 4

| ID | P | Task | Paths | Deps | Acceptance | Verify | Status |
|----|---|------|-------|------|------------|--------|--------|
| P4-01 | P0 | `medication_schema_v1` Dart types | `shared/models/**` | P1-06 | JSON serialize | unit test | todo |
| P4-02 | P0 | `ExtractionValidator` | `extraction_validator.dart` | P4-01 | Blocks auto-schedule | unit test | todo |
| P4-03 | P0 | Extraction review UI | `extraction_review_screen.dart` | P4-01 | Edit all fields | widget test | todo |
| P4-04 | P0 | Confirm → record only | `prescription_import.dart` | P4-03 | No confirm = no DB | integration | todo |
| P4-05 | P1 | Malformed output tests | `test/` | P4-02 | Never crashes | `flutter test` | todo |

## Phase 5

| ID | P | Task | Paths | Deps | Acceptance | Verify | Status |
|----|---|------|-------|------|------------|--------|--------|
| P5-01 | P0 | Drift schema v1 | `app_database.dart` | P4-01 | Migrations work | unit test | todo |
| P5-02 | P0 | Repositories | `medicine_repository.dart` | P5-01 | CRUD | unit test | todo |
| P5-03 | P1 | Encrypt prescription images | `prescription_image_store.dart` | P5-02 | Files not plain | inspection | todo |
| P5-04 | P1 | Delete cascades | migrations | P5-01 | Image removed | unit test | todo |
| P5-05 | P1 | `docs/data-model.md` | `docs/` | P5-01 | Matches code | review | todo |

## Phase 6

| ID | P | Task | Paths | Deps | Acceptance | Verify | Status |
|----|---|------|-------|------|------------|--------|--------|
| P6-01 | P0 | Schedule generator | `reminder_planner.dart` | P4-04 | Deterministic times | unit test | todo |
| P6-02 | P0 | Notification scheduler | `notification_scheduler.dart` | P6-01 | Fires at time | device | todo |
| P6-03 | P0 | Boot receiver reschedule | `BootReceiver.kt` | P6-02 | Post-reboot fire | reboot test | todo |
| P6-04 | P1 | Adherence logging | `adherence_screen.dart` | P6-02 | taken/skipped stored | unit test | todo |
| P6-05 | P1 | Duplicate prevention | `reminder_repository.dart` | P6-02 | No double notify | unit test | todo |

## Phase 7

| ID | P | Task | Paths | Deps | Acceptance | Verify | Status |
|----|---|------|-------|------|------------|--------|--------|
| P7-01 | P1 | Benchmark harness | `tool/benchmark/` | P4-05 | Manifest driven | run locally | todo |
| P7-02 | P1 | Release APK on 4/6 GB phones | — | P6-03 | No OOM in OCR path | manual | todo |
| P7-03 | P1 | `docs/testing.md` complete | `docs/` | P7-01 | All commands | review | todo |
| P7-04 | P2 | Known limitations section | `README.md` | P2-07 | Accurate | review | todo |
