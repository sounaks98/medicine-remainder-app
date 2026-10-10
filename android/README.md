# Android module

## SDK levels

| Setting | Value | Notes |
|---------|-------|--------|
| `minSdk` | **24** | ML Kit bundled Latin OCR; room for notification APIs used later |
| `compileSdk` | **35** | Latest stable at project setup; raise with Play policy |
| `targetSdk` | **35** | Match `compileSdk` unless Play Console requires otherwise |

Configured in [`app/build.gradle.kts`](app/build.gradle.kts).

## ML Kit text recognition (Phase 1)

Offline Latin OCR uses the **bundled** Android artifact (model ships in the APK/AAB), not the thin Play Services–downloaded model.

When [`google_mlkit_text_recognition`](https://pub.dev/packages/google_mlkit_text_recognition) is added (task **P1-03**), declare the bundled dependency in `app/build.gradle.kts`:

```kotlin
dependencies {
    implementation("com.google.mlkit:text-recognition:16.0.1")
}
```

- Artifact: `com.google.mlkit:text-recognition:16.0.1`
- Docs: [ML Kit text recognition (Android)](https://developers.google.com/ml-kit/vision/text-recognition/v2/android)
- Terms: [Google ML Kit terms](https://developers.google.com/ml-kit/terms)

The Flutter plugin may pull a compatible version transitively; pinning `16.0.1` keeps the bundled Latin model explicit and reproducible across builds.
