import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/app/di/database_providers.dart';
import 'package:medicine_remainder_app/app/di/providers.dart';
import 'package:medicine_remainder_app/app/di/user_providers.dart';
import 'package:medicine_remainder_app/features/prescription/data/prescription_repository.dart';
import 'package:medicine_remainder_app/features/medicines/application/medicine_reminder_deleter.dart';
import 'package:medicine_remainder_app/features/prescription/domain/prescription_review_submitter.dart';
import 'package:medicine_remainder_app/features/reminders/application/medicine_reminder_orchestrator.dart';
import 'package:medicine_remainder_app/features/reminders/data/drift_reminder_repository.dart';
import 'package:medicine_remainder_app/features/reminders/data/notification_scheduler.dart';

final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  throw StateError(
    'notificationSchedulerProvider must be overridden in ProviderScope',
  );
});

final driftReminderRepositoryProvider = Provider<DriftReminderRepository>((ref) {
  return DriftReminderRepository(ref.watch(appDatabaseProvider));
});

final prescriptionRepositoryProvider = Provider<PrescriptionRepository>((ref) {
  return PrescriptionRepository(
    database: ref.watch(appDatabaseProvider),
    imageStore: ref.watch(prescriptionImageStoreProvider),
  );
});

final medicineReminderOrchestratorProvider =
    Provider<MedicineReminderOrchestrator>((ref) {
  return MedicineReminderOrchestrator(
    medicineRepository: ref.watch(medicineRepositoryProvider),
    reminderRepository: ref.watch(driftReminderRepositoryProvider),
    notificationScheduler: ref.watch(notificationSchedulerProvider),
  );
});

final medicineReminderDeleterProvider = Provider<MedicineReminderDeleter>((ref) {
  return MedicineReminderDeleter(
    medicineRepository: ref.watch(medicineRepositoryProvider),
    reminderRepository: ref.watch(driftReminderRepositoryProvider),
    notificationScheduler: ref.watch(notificationSchedulerProvider),
  );
});

final prescriptionReviewSubmitterProvider =
    Provider<PrescriptionReviewSubmitter>((ref) {
  return PrescriptionReviewSubmitter(
    medicineRepository: ref.watch(medicineRepositoryProvider),
    prescriptionRepository: ref.watch(prescriptionRepositoryProvider),
    reminderOrchestrator: ref.watch(medicineReminderOrchestratorProvider),
    notificationScheduler: ref.watch(notificationSchedulerProvider),
    userRepository: ref.watch(userRepositoryProvider),
    mealProfileStore: ref.watch(userMealProfileStoreProvider),
  );
});
