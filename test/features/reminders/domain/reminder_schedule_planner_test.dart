import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_course.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';
import 'package:medicine_remainder_app/features/reminders/domain/reminder_schedule_planner.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';

void main() {
  test('meal-based planner expands one instant per course day', () {
    const planner = ReminderSchedulePlanner();
    final schedule = MedicationReminderSchedule(
      mode: ReminderScheduleMode.mealBased,
      meal: const MealBasedSchedule(
        meal: MealSlot.breakfast,
        relationship: MealRelationship.before,
        offsetMinutes: 5,
      ),
      interval: IntervalBasedSchedule(
        intervalHours: 8,
        firstDoseTime: const TimeOfDay(hour: 8, minute: 0),
      ),
      course: MedicationCourse(
        startDate: DateTime(2026, 10, 16),
        durationDays: 3,
      ),
    );
    final profile = UserMealProfile(
      breakfast: const TimeOfDay(hour: 8, minute: 0),
    );
    final instants = planner.expand(schedule: schedule, mealProfile: profile);
    expect(instants.length, 3);
    expect(instants.first.hour, 7);
    expect(instants.first.minute, 55);
  });
}
