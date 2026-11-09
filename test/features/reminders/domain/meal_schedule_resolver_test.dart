import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/reminders/domain/meal_schedule_resolver.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';

void main() {
  final profile = UserMealProfile(
    breakfast: const TimeOfDay(hour: 8, minute: 0),
    lunch: const TimeOfDay(hour: 13, minute: 0),
    dinner: const TimeOfDay(hour: 20, minute: 0),
  );

  test('default 5 minutes before breakfast', () {
    final resolution = MealScheduleResolver.resolve(
      schedule: const MealBasedSchedule(
        meal: MealSlot.breakfast,
        relationship: MealRelationship.before,
      ),
      profile: profile,
      onLocalDate: DateTime(2026, 10, 16),
    );
    expect(resolution.reminderTime.hour, 7);
    expect(resolution.reminderTime.minute, 55);
    expect(resolution.previewLabel, contains('5 minutes before breakfast'));
  });

  test('after lunch with custom offset', () {
    final resolution = MealScheduleResolver.resolve(
      schedule: const MealBasedSchedule(
        meal: MealSlot.lunch,
        relationship: MealRelationship.after,
        offsetMinutes: 15,
      ),
      profile: profile,
      onLocalDate: DateTime(2026, 10, 16),
    );
    expect(resolution.reminderTime.hour, 13);
    expect(resolution.reminderTime.minute, 15);
  });

  test('with meal uses meal time', () {
    final resolution = MealScheduleResolver.resolve(
      schedule: const MealBasedSchedule(
        meal: MealSlot.dinner,
        relationship: MealRelationship.withMeal,
      ),
      profile: profile,
      onLocalDate: DateTime(2026, 10, 16),
    );
    expect(resolution.reminderTime.hour, 20);
    expect(resolution.reminderTime.minute, 0);
  });

  test('missing meal time throws', () {
    expect(
      () => MealScheduleResolver.resolve(
        schedule: const MealBasedSchedule(
          meal: MealSlot.breakfast,
          relationship: MealRelationship.before,
        ),
        profile: const UserMealProfile(),
        onLocalDate: DateTime(2026, 10, 16),
      ),
      throwsA(isA<MissingMealTimeException>()),
    );
  });
}
