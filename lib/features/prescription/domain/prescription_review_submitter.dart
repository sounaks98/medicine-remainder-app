import 'package:medicine_remainder_app/features/medicines/data/medicine_repository.dart';

import 'package:medicine_remainder_app/features/medicines/domain/medication_record.dart';

import 'package:medicine_remainder_app/features/prescription/data/prescription_repository.dart';

import 'package:medicine_remainder_app/features/prescription/domain/prescription_review_bundle.dart';

import 'package:medicine_remainder_app/features/prescription/presentation/editable_medicine_row.dart';

import 'package:medicine_remainder_app/features/reminders/application/medicine_reminder_orchestrator.dart';

import 'package:medicine_remainder_app/features/reminders/data/notification_scheduler.dart';

import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';

import 'package:medicine_remainder_app/features/reminders/domain/medication_course.dart';

import 'package:medicine_remainder_app/features/users/data/user_meal_profile_store.dart';

import 'package:medicine_remainder_app/features/users/data/user_repository.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';

import 'package:medicine_remainder_app/shared/models/field_confidence.dart'
    show FieldConfidence, ReviewStatus;



class PrescriptionReviewSubmitResult {

  const PrescriptionReviewSubmitResult({

    required this.medicinesSaved,

    required this.remindersScheduled,

  });



  final int medicinesSaved;

  final int remindersScheduled;

}



class PrescriptionReviewSubmitter {

  PrescriptionReviewSubmitter({

    required MedicineRepository medicineRepository,

    required PrescriptionRepository prescriptionRepository,

    required MedicineReminderOrchestrator reminderOrchestrator,

    required NotificationScheduler notificationScheduler,

    required UserRepository userRepository,

    required UserMealProfileStore mealProfileStore,

  })  : _medicineRepository = medicineRepository,

        _prescriptionRepository = prescriptionRepository,

        _reminderOrchestrator = reminderOrchestrator,

        _notificationScheduler = notificationScheduler,

        _userRepository = userRepository,

        _mealProfileStore = mealProfileStore;



  final MedicineRepository _medicineRepository;

  final PrescriptionRepository _prescriptionRepository;

  final MedicineReminderOrchestrator _reminderOrchestrator;

  final NotificationScheduler _notificationScheduler;

  final UserRepository _userRepository;

  final UserMealProfileStore _mealProfileStore;



  Future<PrescriptionReviewSubmitResult> submit({

    required String userId,

    required String imagePath,

    required PrescriptionReviewBundle bundle,

    required List<EditableMedicineRow> rows,

  }) async {

    final confirmed = rows.where((r) => r.confirmed).toList();

    if (confirmed.isEmpty) {

      throw StateError('Confirm at least one medicine before submitting.');

    }



    final user = await _userRepository.getUser(userId);

    if (user == null) {

      throw StateError('Profile not found.');

    }



    final mealProfile = _mealProfileStore.read(userId);



    for (final row in confirmed) {

      if (row.reminderSchedule.mode == ReminderScheduleMode.mealBased) {

        final meal = row.reminderSchedule.meal.meal;

        if (!mealProfile.isMealConfigured(meal)) {

          throw StateError(

            'Set ${meal.label.toLowerCase()} time in profile settings '

            'before submitting meal-based reminders.',

          );

        }

        final upcoming = _reminderOrchestrator.countUpcoming(

          schedule: row.reminderSchedule,

          mealProfile: mealProfile,

        );

        if (upcoming == 0) {

          throw StateError(

            'No upcoming reminders for ${meal.label.toLowerCase()}. '

            'Choose a later meal time in profile settings or adjust the course '

            'start date so the next dose is still in the future.',

          );

        }

      }

    }



    final permitted = await _notificationScheduler.requestPermissionIfNeeded();

    if (!permitted) {

      throw StateError('Notification permission is required to set reminders.');

    }

    await _notificationScheduler.ensureAndroidAlarmSchedulingReady();



    final now = DateTime.now().toUtc();

    final prescriptionId = bundle.draft.prescriptionId;



    await _prescriptionRepository.save(

      PrescriptionRecord(

        id: prescriptionId,

        userId: userId,

        capturedAt: bundle.draft.createdAt,

        source: 'gallery',

        imagePath: imagePath,

        reviewStatus: ReviewStatus.confirmed,

        humanReviewedAt: now,

        createdAt: bundle.draft.createdAt,

        updatedAt: now,

      ),

    );



    var remindersScheduled = 0;



    for (final row in confirmed) {

      final course = row.reminderSchedule.course;

      final record = MedicationRecord(

        id: row.id,

        userId: userId,

        prescriptionId: prescriptionId,

        name: row.name.trim(),

        strength: row.strength.trim(),

        strengthUnit: row.strengthUnit,

        doseInstructions: row.count.trim().isNotEmpty

            ? row.count.trim()

            : row.prescriptionInstructionsSummary,

        route: row.route.trim(),

        frequency: row.prescriptionFrequency.trim(),

        duration: '${course.durationDays} days',

        timing: row.prescriptionTiming.trim(),

        startAt: CourseDateMath.toDateString(course.startDate),

        endAt: CourseDateMath.toDateString(course.inclusiveEndDate),

        reviewStatus: ReviewStatus.confirmed,

        confirmedAt: now,

        confirmedByUser: true,

        reminderScheduleJson: row.reminderSchedule.encodeJson(),

        frequencyConfidence: FieldConfidence.known,

      );



      await _medicineRepository.save(record);



      remindersScheduled += await _reminderOrchestrator.scheduleMedicine(

        userId: userId,

        displayName: user.displayName,

        record: record,

        mealProfile: mealProfile,

      );

    }



    if (remindersScheduled == 0) {

      throw StateError(

        'Medicines were saved but no reminders were scheduled. '

        'Check profile meal times and that at least one dose time is still ahead.',

      );

    }



    return PrescriptionReviewSubmitResult(

      medicinesSaved: confirmed.length,

      remindersScheduled: remindersScheduled,

    );

  }

}


