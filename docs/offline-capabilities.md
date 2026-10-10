# Offline capabilities

This document describes what works **without network access** after the app is installed, and how to verify the Phase 1 OCR path manually.

## Prerequisites (one-time, online or offline)

| Requirement | Notes |
|-------------|--------|
| Install the debug or release APK on a physical Android device | Emulator works if Google Play services / ML Kit are available |
| Grant **camera** permission | Only if you test capture; gallery import needs **photos** permission on newer Android |
| Latin prescription images | English/Latin script; bundled ML Kit model (not Devanagari) |

**Bundled OCR:** The app depends on `com.google.mlkit:text-recognition:16.0.1` (Latin model ships in the APK). No separate OCR model download is required.

**Not required for OCR smoke test:** SmolVLM ONNX weights, account sign-in, or backend connectivity.

## What works offline (Phase 1)

| Feature | Offline? | Notes |
|---------|----------|--------|
| Import prescription image (gallery) | Yes | Saved under app-private storage |
| Capture prescription photo | Yes | Same storage rules |
| Image preprocess (EXIF rotate, resize) | Yes | On-device only |
| ML Kit Latin OCR | Yes | After install; no network call for recognition |
| OCR review screen | Yes | Displays image + text; **does not** write medicines to the database |

Future phases (VLM download, cloud sync, push) are out of scope here.

## Airplane-mode OCR smoke test

Use this checklist on a **physical device** with a printed or on-screen prescription image (de-identified sample).

1. **Prepare**
   - Build and install: `flutter build apk` then install, or `flutter run` once while online.
   - Copy a sample prescription image to the device gallery (or use a test printout).

2. **Go offline**
   - Enable **Airplane mode**.
   - Confirm Wi‑Fi and mobile data are off.

3. **Import image**
   - Open the app → **Add prescription** (FAB) → **Choose from gallery**.
   - Pick the sample image and wait for the “saved on device” confirmation.

4. **Document check (step 1)**
   - After import, the app opens **Check document** and scores whether the image looks like a prescription (rules today; SmolVLM when installed).

5. **Unified review (step 2)**
   - Tap **Continue to review** and wait for a single extraction pass (OCR + rules, merged with VLM when available).
   - [ ] Prescription details (doctor, facility, etc.) and medicine rows appear — **not** raw OCR text.
   - [ ] No network required.
   - [ ] Confirming a row does not add to the home medicines list until persistence ships (Phase 5).

6. **Failure signals**
   - Empty text on a sharp printed label → retry with better lighting; see benchmarks (Phase 7).
   - Immediate crash on OCR → check `minSdk >= 24` and ML Kit dependency in `android/app/build.gradle.kts`.

## Automated tests (host machine)

These run on the CI/dev machine and do **not** replace the airplane-mode check above:

```bash
flutter test test/features/prescription/presentation/prescription_review_screen_test.dart
flutter test test/services/inference/ocr_rules_extraction_service_test.dart
```

## Related docs

- [architecture.md](architecture.md) — extraction pipeline and review gates
- [android/README.md](../android/README.md) — SDK levels and ML Kit artifact pin
