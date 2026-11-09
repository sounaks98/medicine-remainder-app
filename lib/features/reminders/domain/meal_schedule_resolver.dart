import 'package:flutter/material.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';

class MealScheduleResolution {
  const MealScheduleResolution({
    required this.fireAtLocal,
    required this.reminderTime,
    required this.previewLabel,
  });

  /// Full local date-time (handles offsets that cross midnight).
  final DateTime fireAtLocal;
  final TimeOfDay reminderTime;
  final String previewLabel;
}

class MissingMealTimeException implements Exception {
  MissingMealTimeException(this.meal);

  final MealSlot meal;

  @override
  String toString() =>
      'Meal time for ${meal.label} is not configured in your profile.';
}

abstract final class MealScheduleResolver {
  static const defaultOffsetMinutes = 5;

  static MealScheduleResolution resolve({
    required MealBasedSchedule schedule,
    required UserMealProfile profile,
    required DateTime onLocalDate,
  }) {
    final mealTime = profile.timeForMeal(schedule.meal);
    if (mealTime == null) {
      throw MissingMealTimeException(schedule.meal);
    }

    final base = DateTime(
      onLocalDate.year,
      onLocalDate.month,
      onLocalDate.day,
      mealTime.hour,
      mealTime.minute,
    );

    final DateTime reminderInstant;
    final String relationLabel;

    switch (schedule.relationship) {
      case MealRelationship.withMeal:
        reminderInstant = base;
        relationLabel = 'with ${schedule.meal.label.toLowerCase()}';
      case MealRelationship.before:
        final minutes = schedule.offsetMinutes;
        reminderInstant = base.subtract(Duration(minutes: minutes));
        relationLabel = '$minutes minutes before ${schedule.meal.label.toLowerCase()}';
      case MealRelationship.after:
        final minutes = schedule.offsetMinutes;
        reminderInstant = base.add(Duration(minutes: minutes));
        relationLabel = '$minutes minutes after ${schedule.meal.label.toLowerCase()}';
    }

    final time = TimeOfDay.fromDateTime(reminderInstant);
    return MealScheduleResolution(
      fireAtLocal: reminderInstant,
      reminderTime: time,
      previewLabel: 'Remind $relationLabel (${_formatTime(time)})',
    );
  }

  static String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }
}
