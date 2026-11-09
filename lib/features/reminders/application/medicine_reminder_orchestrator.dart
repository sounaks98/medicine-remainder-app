import 'package:medicine_remainder_app/features/medicines/data/medicine_repository.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_record.dart';
import 'package:medicine_remainder_app/features/reminders/data/drift_reminder_repository.dart';
import 'package:medicine_remainder_app/features/reminders/data/notification_scheduler.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';
import 'package:medicine_remainder_app/features/reminders/domain/meal_schedule_resolver.dart';
import 'package:medicine_remainder_app/features/reminders/domain/reminder_event_id.dart';
import 'package:medicine_remainder_app/features/reminders/domain/reminder_notification_copy.dart';
import 'package:medicine_remainder_app/features/reminders/domain/reminder_schedule_planner.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';
import 'package:uuid/uuid.dart';

/// Schedules and cancels local notifications for confirmed medicines.
class MedicineReminderOrchestrator {
  MedicineReminderOrchestrator({
    required MedicineRepository medicineRepository,
    required DriftReminderRepository reminderRepository,
    required NotificationScheduler notificationScheduler,
    Uuid? uuid,
  })  : _medicineRepository = medicineRepository,
        _reminderRepository = reminderRepository,
        _notificationScheduler = notificationScheduler,
        _uuid = uuid ?? const Uuid();

  final MedicineRepository _medicineRepository;
  final DriftReminderRepository _reminderRepository;
  final NotificationScheduler _notificationScheduler;
  final Uuid _uuid;

  static const _maxNotificationsPerMedicine = 128;
  static const _planner = ReminderSchedulePlanner();

  Future<void> cancelPendingForMedicine({
    required String userId,
    required String medicineId,
  }) async {
    final eventIds =
        await _reminderRepository.listEventIdsForMedicine(medicineId);
    for (final eventId in eventIds) {
      await _notificationScheduler.cancel(
        ReminderNotificationIds.forEvent(
          userId: userId,
          reminderEventId: eventId,
        ),
      );
    }
    await _reminderRepository.deleteEventsForMedicine(medicineId);
  }

  Future<int> scheduleMedicine({
    required String userId,
    required String displayName,
    required MedicationRecord record,
    required UserMealProfile mealProfile,
  }) async {
    final schedule = MedicationReminderSchedule.decodeJson(
      record.reminderScheduleJson,
    );
    if (schedule == null) {
      return 0;
    }

    _validateMealSchedule(schedule, mealProfile);

    final now = DateTime.now();
    final fireTimes = _planner
        .expand(schedule: schedule, mealProfile: mealProfile)
        .where((t) => t.isAfter(now))
        .take(_maxNotificationsPerMedicine);

    final title = ReminderNotificationCopy.title(displayName: displayName);
    final body = ReminderNotificationCopy.body(medicine: record);

    var scheduled = 0;
    for (final fireAt in fireTimes) {
      final eventId = _uuid.v4();
      await _reminderRepository.insertPendingEvent(
        id: eventId,
        userId: userId,
        medicineId: record.id,
        fireAt: fireAt,
      );
      await _notificationScheduler.schedule(
        notificationId: ReminderNotificationIds.forEvent(
          userId: userId,
          reminderEventId: eventId,
        ),
        fireAtLocal: fireAt,
        title: title,
        body: body,
        payload: '{"userId":"$userId","medicineId":"${record.id}"}',
      );
      scheduled++;
    }
    return scheduled;
  }

  Future<int> rescheduleAllForUser({
    required String userId,
    required String displayName,
    required UserMealProfile mealProfile,
  }) async {
    final medicines =
        await _medicineRepository.listConfirmed(userId: userId);
    var total = 0;
    for (final record in medicines) {
      await cancelPendingForMedicine(userId: userId, medicineId: record.id);
      total += await scheduleMedicine(
        userId: userId,
        displayName: displayName,
        record: record,
        mealProfile: mealProfile,
      );
    }
    return total;
  }

  void _validateMealSchedule(
    MedicationReminderSchedule schedule,
    UserMealProfile mealProfile,
  ) {
    if (schedule.mode != ReminderScheduleMode.mealBased) {
      return;
    }
    if (!mealProfile.isMealConfigured(schedule.meal.meal)) {
      throw StateError(
        'Set ${schedule.meal.meal.label.toLowerCase()} time in profile '
        'settings before using meal-based reminders.',
      );
    }
  }

  /// Ensures at least one future fire time exists for meal-based rows.
  int countUpcoming({
    required MedicationReminderSchedule schedule,
    required UserMealProfile mealProfile,
  }) {
    if (schedule.mode == ReminderScheduleMode.mealBased &&
        !mealProfile.isMealConfigured(schedule.meal.meal)) {
      return 0;
    }
    try {
      return _planner
          .expand(schedule: schedule, mealProfile: mealProfile)
          .where((t) => t.isAfter(DateTime.now()))
          .take(_maxNotificationsPerMedicine)
          .length;
    } on MissingMealTimeException {
      return 0;
    }
  }
}
