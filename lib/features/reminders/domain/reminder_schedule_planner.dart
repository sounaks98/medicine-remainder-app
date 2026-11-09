import 'package:medicine_remainder_app/features/reminders/domain/interval_occurrence_generator.dart';
import 'package:medicine_remainder_app/features/reminders/domain/meal_schedule_resolver.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_course.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';

/// Expands confirmed schedule rules into local fire instants (deterministic).
class ReminderSchedulePlanner {
  const ReminderSchedulePlanner();

  List<DateTime> expand({
    required MedicationReminderSchedule schedule,
    required UserMealProfile mealProfile,
  }) {
    switch (schedule.mode) {
      case ReminderScheduleMode.mealBased:
        return _expandMealBased(schedule, mealProfile);
      case ReminderScheduleMode.intervalBased:
        return IntervalOccurrenceGenerator.generate(
          schedule: schedule.interval,
          course: schedule.course,
        );
    }
  }

  List<DateTime> _expandMealBased(
    MedicationReminderSchedule schedule,
    UserMealProfile mealProfile,
  ) {
    final course = schedule.course;
    final start = CourseDateMath.dateOnly(course.startDate);
    final end = CourseDateMath.inclusiveEndDate(course.startDate, course.durationDays);
    final instants = <DateTime>[];

    for (var day = start;
        !day.isAfter(end);
        day = DateTime(day.year, day.month, day.day + 1)) {
      final resolution = MealScheduleResolver.resolve(
        schedule: schedule.meal,
        profile: mealProfile,
        onLocalDate: day,
      );
      instants.add(resolution.fireAtLocal);
    }
    return instants;
  }
}
