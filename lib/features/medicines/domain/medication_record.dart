import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

/// Confirmed medication entity (post user review).
class MedicationRecord {
  const MedicationRecord({
    required this.id,
    required this.prescriptionId,
    required this.reviewStatus,
    required this.confirmedAt,
    required this.confirmedByUser,
    this.scheduleRuleId,
  });

  final String id;
  final String prescriptionId;
  final ReviewStatus reviewStatus;
  final DateTime? confirmedAt;
  final bool confirmedByUser;
  final String? scheduleRuleId;
}
