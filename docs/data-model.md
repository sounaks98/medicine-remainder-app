# Data model (schema v2 scheduling)

## Hybrid reminder schedule (v2)

User-confirmed rules are stored separately from prescription OCR text:

| Concept | Storage |
|---------|---------|
| Prescription frequency/timing (OCR) | `medicines.frequency`, `medicines.timing` (unchanged; review-only text) |
| Confirmed schedule rules | `medicines.reminderScheduleJson` (JSON, schema version 1) |
| Usual meal times | `SharedPreferences` key `user_meal_profile_{userId}` |
| Generated fire times | `reminder_events` (Phase 6; derived from rules + meal profile) |

`reminderScheduleJson` encodes `MedicationReminderSchedule`: mode (`mealBased` | `intervalBased`), meal or interval payload, and `MedicationCourse` (`startDate`, `durationDays`). End date is **inclusive** and derived as `startDate + (durationDays - 1)` calendar days.

Legacy rows with null `reminderScheduleJson` are not auto-mapped to meal/interval modes.

---

# Data model (schema v1)

This document matches the Drift schema and `medication_schema_v1` JSON types implemented in the app.

## Tenancy

- Single SQLite database (`AppDatabase`, `schemaVersion = 2`).
- Every tenant table includes `userId` referencing `users.id`.
- Foreign keys are enabled (`PRAGMA foreign_keys = ON`).

## Core enums

| Enum | Values |
|------|--------|
| `FieldConfidence` | `known`, `uncertain`, `missing` |
| `ReviewStatus` | `draft`, `confirmed`, `rejected` |
| `Provenance` | `ocr`, `vlm`, `user`, `rules` |
| `ExtractionMethod` | `ocr_only`, `ocr_rules`, `smolvlm_onnx`, `manual` |

## JSON extraction (`medication_schema_v1`)

Pre-confirmation drafts are serialized with:

- `schemaVersion` (int, currently `1`)
- `schemaName` (`medication_schema_v1`)
- `prescriptionId`, `userId`
- `medicines[]` with fields: `name`, `strength`, `strengthUnit`, `doseInstructions`, `route`, `frequency`, `duration`, `timing`, `startAt`, `endAt`, `originalSourceText`
- Each medicine field is an object: `value`, `confidence`, optional `sourceText`, `provenance`, optional `warnings`
- Optional `rawOcrText`, `rawModelOutput`
- `extractionMethod`, `createdAt` (ISO-8601 UTC)

Parsing rejects unknown root or medicine keys (VLM hallucination guard).

## Tables

### `users`

| Column | Type |
|--------|------|
| `id` | TEXT PK |
| `displayName` | TEXT |
| `createdAt` / `updatedAt` | DATETIME |

### `prescriptions`

| Column | Type |
|--------|------|
| `id` | TEXT PK |
| `userId` | TEXT FK → `users` (ON DELETE CASCADE) |
| `capturedAt` | DATETIME |
| `validFrom` / `validTo` | DATETIME nullable |
| `source` | TEXT (`camera`, `gallery`, `manual`) |
| `imagePath` | TEXT nullable (encrypted file under app documents) |
| `reviewStatus` | TEXT |
| `humanReviewedAt` | DATETIME nullable |
| EHR metadata columns | TEXT nullable |
| `createdAt` / `updatedAt` | DATETIME |

### `medicines`

Confirmed medicine snapshots (one row per confirmed line item).

| Column | Type |
|--------|------|
| `id` | TEXT PK |
| `userId` | TEXT FK → `users` (CASCADE) |
| `prescriptionId` | TEXT FK → `prescriptions` (CASCADE) |
| `name`, `strength`, `strengthUnit`, `doseInstructions`, `route`, `frequency`, `duration`, `timing` | TEXT |
| `startAt` / `endAt` | TEXT nullable |
| `reviewStatus` | TEXT |
| `confirmedAt` | DATETIME nullable |
| `confirmedByUser` | BOOL |
| `scheduleRuleId` | TEXT nullable |
| `frequencyConfidence` | TEXT |
| `reminderScheduleJson` | TEXT nullable (v2) |

### `reminder_events` / `adherence_entries`

Placeholder v1 tables for Phase 6; FK cascade from `medicines` / `reminder_events`.

## Confirmation gate

- `ExtractionValidator` blocks auto-scheduling until `reviewStatus = confirmed` and `confirmedByUser = true`.
- `PrescriptionImport.confirmExtraction` is the only path that creates `MedicationRecord` rows (DB or in-memory session when no repository is wired).

## Prescription images

- Stored under `{appDocuments}/prescriptions/tmp/`.
- Payloads are AES-encrypted (`MRX1` header + IV + ciphertext); key in `flutter_secure_storage` (`prescription_image_aes_key_v1`).
- `PrescriptionRepository.deletePrescription` deletes the DB row (cascades medicines) and removes the image file.

## Migrations

- Version **1**: initial create via Drift `onCreate`.
- Version **2**: add `medicines.reminderScheduleJson` (nullable).
- `DatabaseMigrations.currentVersion` must stay in sync with `AppDatabase.schemaVersion`.
