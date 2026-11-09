import 'package:medicine_remainder_app/features/medicines/data/medicine_repository.dart';
import 'package:medicine_remainder_app/features/reminders/data/drift_reminder_repository.dart';
import 'package:medicine_remainder_app/features/reminders/data/notification_scheduler.dart';
import 'package:medicine_remainder_app/features/reminders/domain/reminder_event_id.dart';

/// Removes a confirmed medicine and cancels its pending local notifications.
class MedicineReminderDeleter {
  MedicineReminderDeleter({
    required MedicineRepository medicineRepository,
    required DriftReminderRepository reminderRepository,
    required NotificationScheduler notificationScheduler,
  })  : _medicineRepository = medicineRepository,
        _reminderRepository = reminderRepository,
        _notificationScheduler = notificationScheduler;

  final MedicineRepository _medicineRepository;
  final DriftReminderRepository _reminderRepository;
  final NotificationScheduler _notificationScheduler;

  Future<void> delete({
    required String userId,
    required String medicineId,
  }) async {
    final eventIds =
        await _reminderRepository.listEventIdsForMedicine(medicineId);
    for (final eventId in eventIds) {
      final notificationId = ReminderNotificationIds.forEvent(
        userId: userId,
        reminderEventId: eventId,
      );
      await _notificationScheduler.cancel(notificationId);
    }
    await _medicineRepository.delete(medicineId);
  }
}
