import 'package:medicine_remainder_app/shared/models/medication_field.dart';

/// Pre-confirmation extraction payload (`medication_schema_v1`).
class MedicationExtractionDraft {
  const MedicationExtractionDraft({
    required this.schemaVersion,
    required this.prescriptionId,
    required this.userId,
    required this.medicines,
    this.rawOcrText,
    this.rawModelOutput,
    required this.extractionMethod,
    required this.createdAt,
  });

  final int schemaVersion;
  final String prescriptionId;
  final String userId;
  final List<MedicineDraft> medicines;
  final String? rawOcrText;
  final String? rawModelOutput;
  final ExtractionMethod extractionMethod;
  final DateTime createdAt;

  MedicationExtractionDraft copyWith({
    int? schemaVersion,
    String? prescriptionId,
    String? userId,
    List<MedicineDraft>? medicines,
    String? rawOcrText,
    String? rawModelOutput,
    ExtractionMethod? extractionMethod,
    DateTime? createdAt,
  }) {
    return MedicationExtractionDraft(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      userId: userId ?? this.userId,
      medicines: medicines ?? this.medicines,
      rawOcrText: rawOcrText ?? this.rawOcrText,
      rawModelOutput: rawModelOutput ?? this.rawModelOutput,
      extractionMethod: extractionMethod ?? this.extractionMethod,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'schemaName': 'medication_schema_v1',
      'prescriptionId': prescriptionId,
      'userId': userId,
      'medicines': medicines.map((m) => m.toJson()).toList(),
      if (rawOcrText != null) 'rawOcrText': rawOcrText,
      if (rawModelOutput != null) 'rawModelOutput': rawModelOutput,
      'extractionMethod': extractionMethod.jsonValue,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }
}

enum ExtractionMethod {
  ocrOnly,
  ocrRules,
  smolvlmOnnx,
  manual;

  String get jsonValue {
    switch (this) {
      case ExtractionMethod.ocrOnly:
        return 'ocr_only';
      case ExtractionMethod.ocrRules:
        return 'ocr_rules';
      case ExtractionMethod.smolvlmOnnx:
        return 'smolvlm_onnx';
      case ExtractionMethod.manual:
        return 'manual';
    }
  }

  static ExtractionMethod fromJsonValue(String? raw) {
    switch (raw) {
      case 'ocr_only':
        return ExtractionMethod.ocrOnly;
      case 'ocr_rules':
        return ExtractionMethod.ocrRules;
      case 'smolvlm_onnx':
        return ExtractionMethod.smolvlmOnnx;
      case 'manual':
        return ExtractionMethod.manual;
      default:
        return ExtractionMethod.ocrRules;
    }
  }
}

class MedicineDraft {
  const MedicineDraft({
    required this.name,
    required this.strength,
    required this.strengthUnit,
    required this.doseInstructions,
    required this.route,
    required this.frequency,
    required this.duration,
    required this.timing,
    required this.startAt,
    required this.endAt,
    required this.originalSourceText,
  });

  final MedicationField<String> name;
  final MedicationField<String> strength;
  final MedicationField<String> strengthUnit;
  final MedicationField<String> doseInstructions;
  final MedicationField<String> route;
  final MedicationField<String> frequency;
  final MedicationField<String> duration;
  final MedicationField<String> timing;
  final MedicationField<String> startAt;
  final MedicationField<String> endAt;
  final MedicationField<String> originalSourceText;

  MedicineDraft copyWith({
    MedicationField<String>? name,
    MedicationField<String>? strength,
    MedicationField<String>? strengthUnit,
    MedicationField<String>? doseInstructions,
    MedicationField<String>? route,
    MedicationField<String>? frequency,
    MedicationField<String>? duration,
    MedicationField<String>? timing,
    MedicationField<String>? startAt,
    MedicationField<String>? endAt,
    MedicationField<String>? originalSourceText,
  }) {
    return MedicineDraft(
      name: name ?? this.name,
      strength: strength ?? this.strength,
      strengthUnit: strengthUnit ?? this.strengthUnit,
      doseInstructions: doseInstructions ?? this.doseInstructions,
      route: route ?? this.route,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      timing: timing ?? this.timing,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      originalSourceText: originalSourceText ?? this.originalSourceText,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name.toJson(),
      'strength': strength.toJson(),
      'strengthUnit': strengthUnit.toJson(),
      'doseInstructions': doseInstructions.toJson(),
      'route': route.toJson(),
      'frequency': frequency.toJson(),
      'duration': duration.toJson(),
      'timing': timing.toJson(),
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'originalSourceText': originalSourceText.toJson(),
    };
  }

  static MedicineDraft fromJson(Map<String, Object?> json) {
    return MedicineDraft(
      name: MedicationField.stringFromJson(
        Map<String, Object?>.from(json['name'] as Map),
      ),
      strength: MedicationField.stringFromJson(
        Map<String, Object?>.from(json['strength'] as Map),
      ),
      strengthUnit: MedicationField.stringFromJson(
        Map<String, Object?>.from(json['strengthUnit'] as Map),
      ),
      doseInstructions: MedicationField.stringFromJson(
        Map<String, Object?>.from(json['doseInstructions'] as Map),
      ),
      route: MedicationField.stringFromJson(
        Map<String, Object?>.from(json['route'] as Map),
      ),
      frequency: MedicationField.stringFromJson(
        Map<String, Object?>.from(json['frequency'] as Map),
      ),
      duration: MedicationField.stringFromJson(
        Map<String, Object?>.from(json['duration'] as Map),
      ),
      timing: MedicationField.stringFromJson(
        Map<String, Object?>.from(json['timing'] as Map),
      ),
      startAt: MedicationField.stringFromJson(
        Map<String, Object?>.from(json['startAt'] as Map),
      ),
      endAt: MedicationField.stringFromJson(
        Map<String, Object?>.from(json['endAt'] as Map),
      ),
      originalSourceText: MedicationField.stringFromJson(
        Map<String, Object?>.from(json['originalSourceText'] as Map),
      ),
    );
  }
}
