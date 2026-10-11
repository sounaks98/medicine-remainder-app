import 'dart:convert';

import 'package:medicine_remainder_app/shared/models/medication_extraction_draft.dart';
/// JSON schema constants and strict parse/serialize for medication drafts (P4-01).
abstract final class MedicationSchema {
  static const int currentVersion = 1;
  static const String schemaName = 'medication_schema_v1';

  static const _allowedRootKeys = {
    'schemaVersion',
    'schemaName',
    'prescriptionId',
    'userId',
    'medicines',
    'rawOcrText',
    'rawModelOutput',
    'extractionMethod',
    'createdAt',
  };

  static const _allowedMedicineKeys = {
    'name',
    'strength',
    'strengthUnit',
    'doseInstructions',
    'route',
    'frequency',
    'duration',
    'timing',
    'startAt',
    'endAt',
    'originalSourceText',
  };

  static String encodeDraft(MedicationExtractionDraft draft) {
    return jsonEncode(draft.toJson());
  }

  static MedicationSchemaParseResult parseDraftJson(String rawJson) {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map) {
        return MedicationSchemaParseResult.failure('Root must be a JSON object');
      }
      final map = Map<String, Object?>.from(decoded);
      final extraRoot = map.keys.toSet().difference(_allowedRootKeys);
      if (extraRoot.isNotEmpty) {
        return MedicationSchemaParseResult.failure(
          'Unexpected root keys: ${extraRoot.join(', ')}',
        );
      }

      final schemaVersion = map['schemaVersion'];
      if (schemaVersion is! int || schemaVersion != currentVersion) {
        return MedicationSchemaParseResult.failure(
          'schemaVersion must be $currentVersion',
        );
      }

      final prescriptionId = map['prescriptionId'];
      if (prescriptionId is! String || prescriptionId.isEmpty) {
        return MedicationSchemaParseResult.failure('prescriptionId is required');
      }

      final userId = map['userId'];
      if (userId is! String) {
        return MedicationSchemaParseResult.failure('userId is required');
      }

      final medicinesRaw = map['medicines'];
      if (medicinesRaw is! List) {
        return MedicationSchemaParseResult.failure('medicines must be an array');
      }

      final medicines = <MedicineDraft>[];
      for (final entry in medicinesRaw) {
        if (entry is! Map) {
          return MedicationSchemaParseResult.failure(
            'Each medicine must be an object',
          );
        }
        final medicineMap = Map<String, Object?>.from(entry);
        final extraMedicine =
            medicineMap.keys.toSet().difference(_allowedMedicineKeys);
        if (extraMedicine.isNotEmpty) {
          return MedicationSchemaParseResult.failure(
            'Unexpected medicine keys: ${extraMedicine.join(', ')}',
          );
        }
        for (final fieldName in _allowedMedicineKeys) {
          final field = medicineMap[fieldName];
          if (field is! Map) {
            return MedicationSchemaParseResult.failure(
              'Medicine.$fieldName must be an object',
            );
          }
        }
        medicines.add(MedicineDraft.fromJson(medicineMap));
      }

      final createdAtRaw = map['createdAt'];
      if (createdAtRaw is! String) {
        return MedicationSchemaParseResult.failure('createdAt is required');
      }
      final createdAt = DateTime.tryParse(createdAtRaw);
      if (createdAt == null) {
        return MedicationSchemaParseResult.failure('createdAt must be ISO8601');
      }

      final draft = MedicationExtractionDraft(
        schemaVersion: schemaVersion,
        prescriptionId: prescriptionId,
        userId: userId,
        medicines: medicines,
        rawOcrText: map['rawOcrText'] as String?,
        rawModelOutput: map['rawModelOutput'] as String?,
        extractionMethod: ExtractionMethod.fromJsonValue(
          map['extractionMethod'] as String?,
        ),
        createdAt: createdAt.toUtc(),
      );

      return MedicationSchemaParseResult.success(draft);
    } on FormatException catch (e) {
      return MedicationSchemaParseResult.failure('Invalid JSON: ${e.message}');
    } catch (e) {
      return MedicationSchemaParseResult.failure('Parse error: $e');
    }
  }
}

final class MedicationSchemaParseResult {
  const MedicationSchemaParseResult._({
    this.draft,
    this.errorMessage,
  });

  final MedicationExtractionDraft? draft;
  final String? errorMessage;

  bool get isSuccess => draft != null;

  static MedicationSchemaParseResult success(MedicationExtractionDraft draft) {
    return MedicationSchemaParseResult._(draft: draft);
  }

  static MedicationSchemaParseResult failure(String message) {
    return MedicationSchemaParseResult._(errorMessage: message);
  }
}
