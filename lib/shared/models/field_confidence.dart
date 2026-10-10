/// Per-field extraction confidence and provenance (schema v1).
enum FieldConfidence {
  known,
  uncertain,
  missing,
}

enum ReviewStatus {
  draft,
  confirmed,
  rejected,
}

enum Provenance {
  ocr,
  vlm,
  user,
  rules,
}

enum AdherenceStatus {
  taken,
  skipped,
  unknown,
}
