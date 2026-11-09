# Testing

## Hybrid reminder schedule (meal / interval)

| Area | Command |
|------|---------|
| Course inclusive end dates | `flutter test test/features/reminders/domain/course_date_test.dart` |
| Meal resolver (5 min default, with/after/before, missing meal) | `flutter test test/features/reminders/domain/meal_schedule_resolver_test.dart` |
| Interval occurrence bounds | `flutter test test/features/reminders/domain/interval_occurrence_generator_test.dart` |
| Review prescription UI | `flutter test test/features/prescription/presentation/prescription_review_screen_test.dart` |

## Gemma 3n (unit, no weights)

| Area | Command |
|------|---------|
| Fence strip, mapper, model status, materialize idempotency | `flutter test test/services/inference/gemma/` |
| Kotlin JSON / checksum (JVM) | `cd android && ./gradlew :app:testDebugUnitTest` |

Device validation and release APK/AAB checks: [GEMMA3N_ANDROID_DEPLOYMENT.md](../GEMMA3N_ANDROID_DEPLOYMENT.md).

## Full suite

```bash
flutter analyze
flutter test
```

## Manual checklist (scheduling)

- Set meal times from Review prescription app bar → meal times.
- Meal-based card shows preview label; confirm disabled until meal time exists.
- Interval mode does not auto-fill from OCR “twice daily” text (instructions stay in Additional details).
- Start date + duration recalculates inclusive end date on edit.
