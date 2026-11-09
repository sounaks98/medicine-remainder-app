import 'package:medicine_remainder_app/features/medicines/domain/medication_record.dart';

abstract final class ReminderNotificationCopy {
  static String title({
    required String displayName,
  }) {
    return '$displayName — Medicine reminder';
  }

  static String body({required MedicationRecord medicine}) {
    final strength = medicine.strength.trim().isEmpty
        ? ''
        : ' ${medicine.strength}${medicine.strengthUnit}';
    final dose = medicine.doseInstructions.trim();
    final parts = <String>[
      '${medicine.name.trim()}$strength'.trim(),
      if (dose.isNotEmpty) dose,
    ];
    return parts.join(' · ');
  }
}
