import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:medicine_remainder_app/shared/models/medication_extraction_draft.dart';
import 'package:medicine_remainder_app/shared/models/medication_field.dart';

/// Rejects invalid or hallucinated schedules before confirmation (P4-02).
class ExtractionValidator {
  const ExtractionValidator();

  /// Human confirmation is always required before reminders or DB persistence.
  bool canAutoSchedule({
    required ReviewStatus reviewStatus,
    required bool confirmedByUser,
  }) {
    return reviewStatus == ReviewStatus.confirmed && confirmedByUser;
  }

  /// Validates a draft prior to user confirm; returns blocking errors and warnings.
  ExtractionValidationResult validateDraft(MedicationExtractionDraft draft) {
    final errors = <String>[];
    final warnings = <String>[];

    if (draft.medicines.isEmpty) {
      errors.add('Add at least one medicine before confirming.');
    }

    for (var i = 0; i < draft.medicines.length; i++) {
      final medicine = draft.medicines[i];
      final label = 'Medicine ${i + 1}';

      if (_isEmpty(medicine.name)) {
        errors.add('$label: name is required.');
      }

      for (final field in _trackedFields(medicine)) {
        if (field.confidence == FieldConfidence.uncertain &&
            field.value != null &&
            field.value!.isNotEmpty) {
          warnings.add(
            '$label: ${field.label} is uncertain — review before confirming.',
          );
        }
      }

      if (!_isEmpty(medicine.frequency) &&
          medicine.frequency.confidence == FieldConfidence.uncertain) {
        warnings.add(
          '$label: frequency looks uncertain; reminders stay blocked until you confirm.',
        );
      }
    }

    if (!canAutoSchedule(
      reviewStatus: ReviewStatus.draft,
      confirmedByUser: false,
    )) {
      warnings.add(
        'Reminders and schedules stay disabled until you tap Confirm.',
      );
    }

    return ExtractionValidationResult(
      errors: errors,
      warnings: warnings,
      blocksAutoSchedule: true,
    );
  }

  /// Whether schedule expansion is allowed for a confirmed medicine snapshot.
  bool canScheduleMedicine({
    required ReviewStatus reviewStatus,
    required bool confirmedByUser,
    required String? frequency,
    FieldConfidence frequencyConfidence = FieldConfidence.missing,
  }) {
    if (!canAutoSchedule(
      reviewStatus: reviewStatus,
      confirmedByUser: confirmedByUser,
    )) {
      return false;
    }
    if (frequency == null || frequency.trim().isEmpty) {
      return false;
    }
    return frequencyConfidence != FieldConfidence.uncertain;
  }

  static bool _isEmpty(MedicationField<String> field) {
    final value = field.value;
    return value == null || value.trim().isEmpty;
  }

  static List<_NamedField> _trackedFields(MedicineDraft medicine) {
    return [
      _NamedField('name', medicine.name),
      _NamedField('strength', medicine.strength),
      _NamedField('strength unit', medicine.strengthUnit),
      _NamedField('dose instructions', medicine.doseInstructions),
      _NamedField('route', medicine.route),
      _NamedField('frequency', medicine.frequency),
      _NamedField('duration', medicine.duration),
      _NamedField('timing', medicine.timing),
    ];
  }
}

final class ExtractionValidationResult {
  const ExtractionValidationResult({
    required this.errors,
    required this.warnings,
    required this.blocksAutoSchedule,
  });

  final List<String> errors;
  final List<String> warnings;
  final bool blocksAutoSchedule;

  bool get canConfirm => errors.isEmpty;
}

class _NamedField {
  const _NamedField(this.label, this.field);

  final String label;
  final MedicationField<String> field;

  FieldConfidence get confidence => field.confidence;
  String? get value => field.value;
}
