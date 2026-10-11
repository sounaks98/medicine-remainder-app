import 'package:medicine_remainder_app/shared/models/field_confidence.dart';
import 'package:medicine_remainder_app/shared/models/medication_extraction_draft.dart';

/// Confirmed medication entity (post user review).
class MedicationRecord {
  const MedicationRecord({
    required this.id,
    required this.userId,
    required this.prescriptionId,
    required this.name,
    required this.strength,
    required this.strengthUnit,
    required this.doseInstructions,
    required this.route,
    required this.frequency,
    required this.duration,
    required this.timing,
    this.startAt,
    this.endAt,
    required this.reviewStatus,
    required this.confirmedAt,
    required this.confirmedByUser,
    this.scheduleRuleId,
    this.frequencyConfidence = FieldConfidence.known,
  });

  final String id;
  final String userId;
  final String prescriptionId;
  final String name;
  final String strength;
  final String strengthUnit;
  final String doseInstructions;
  final String route;
  final String frequency;
  final String duration;
  final String timing;
  final String? startAt;
  final String? endAt;
  final ReviewStatus reviewStatus;
  final DateTime? confirmedAt;
  final bool confirmedByUser;
  final String? scheduleRuleId;
  final FieldConfidence frequencyConfidence;

  static MedicationRecord fromConfirmedDraft({
    required String medicineId,
    required String userId,
    required MedicineDraft medicine,
    required String prescriptionId,
    required DateTime confirmedAt,
  }) {
    return MedicationRecord(
      id: medicineId,
      userId: userId,
      prescriptionId: prescriptionId,
      name: medicine.name.value?.trim() ?? '',
      strength: medicine.strength.value?.trim() ?? '',
      strengthUnit: medicine.strengthUnit.value?.trim() ?? '',
      doseInstructions: medicine.doseInstructions.value?.trim() ?? '',
      route: medicine.route.value?.trim() ?? '',
      frequency: medicine.frequency.value?.trim() ?? '',
      duration: medicine.duration.value?.trim() ?? '',
      timing: medicine.timing.value?.trim() ?? '',
      startAt: medicine.startAt.value,
      endAt: medicine.endAt.value,
      reviewStatus: ReviewStatus.confirmed,
      confirmedAt: confirmedAt,
      confirmedByUser: true,
      frequencyConfidence: medicine.frequency.confidence,
    );
  }
}
