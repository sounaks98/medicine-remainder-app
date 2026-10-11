import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

/// Single extracted or user-edited field with confidence metadata (schema v1).
class MedicationField<T> {
  const MedicationField({
    this.value,
    required this.confidence,
    this.sourceText,
    required this.provenance,
    this.warnings = const [],
  });

  final T? value;
  final FieldConfidence confidence;
  final String? sourceText;
  final Provenance provenance;
  final List<String> warnings;

  MedicationField<T> copyWith({
    T? value,
    FieldConfidence? confidence,
    String? sourceText,
    Provenance? provenance,
    List<String>? warnings,
  }) {
    return MedicationField<T>(
      value: value ?? this.value,
      confidence: confidence ?? this.confidence,
      sourceText: sourceText ?? this.sourceText,
      provenance: provenance ?? this.provenance,
      warnings: warnings ?? this.warnings,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'value': value,
      'confidence': confidence.name,
      if (sourceText != null) 'sourceText': sourceText,
      'provenance': provenance.name,
      if (warnings.isNotEmpty) 'warnings': warnings,
    };
  }

  static MedicationField<String> stringFromJson(Map<String, Object?> json) {
    return MedicationField<String>(
      value: json['value'] as String?,
      confidence: _confidenceFromJson(json['confidence']),
      sourceText: json['sourceText'] as String?,
      provenance: _provenanceFromJson(json['provenance']),
      warnings: _warningsFromJson(json['warnings']),
    );
  }

  static FieldConfidence _confidenceFromJson(Object? raw) {
    if (raw is String) {
      return FieldConfidence.values.firstWhere(
        (e) => e.name == raw,
        orElse: () => FieldConfidence.missing,
      );
    }
    return FieldConfidence.missing;
  }

  static Provenance _provenanceFromJson(Object? raw) {
    if (raw is String) {
      return Provenance.values.firstWhere(
        (e) => e.name == raw,
        orElse: () => Provenance.rules,
      );
    }
    return Provenance.rules;
  }

  static List<String> _warningsFromJson(Object? raw) {
    if (raw is List) {
      return raw.whereType<String>().toList();
    }
    return const [];
  }
}
