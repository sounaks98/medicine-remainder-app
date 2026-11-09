import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_record.dart';
import 'package:medicine_remainder_app/features/reminders/domain/reminder_notification_copy.dart';
import 'package:medicine_remainder_app/shared/models/field_confidence.dart';

void main() {
  test('title includes display name', () {
    expect(
      ReminderNotificationCopy.title(displayName: 'Priya'),
      'Priya — Medicine reminder',
    );
  });

  test('body includes medicine name and strength', () {
    final medicine = MedicationRecord(
      id: 'm1',
      userId: 'u1',
      prescriptionId: 'rx1',
      name: 'Metformin',
      strength: '500',
      strengthUnit: 'mg',
      doseInstructions: 'After breakfast',
      route: 'oral',
      frequency: '',
      duration: '7 days',
      timing: '',
      reviewStatus: ReviewStatus.confirmed,
      confirmedAt: DateTime.utc(2026),
      confirmedByUser: true,
    );
    expect(
      ReminderNotificationCopy.body(medicine: medicine),
      'Metformin 500mg · After breakfast',
    );
  });
}
