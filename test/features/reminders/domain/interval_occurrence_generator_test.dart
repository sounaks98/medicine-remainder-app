import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/features/reminders/domain/interval_occurrence_generator.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_course.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';

void main() {
  test('generates every-8h occurrences within inclusive course', () {
    final course = MedicationCourse(
      startDate: DateTime(2026, 10, 16),
      durationDays: 2,
    );
    final schedule = IntervalBasedSchedule(
      intervalHours: 8,
      firstDoseTime: const TimeOfDay(hour: 8, minute: 0),
    );
    final occurrences = IntervalOccurrenceGenerator.generate(
      schedule: schedule,
      course: course,
    );
    expect(occurrences.first, DateTime(2026, 10, 16, 8, 0));
    expect(occurrences[1], DateTime(2026, 10, 16, 16, 0));
    expect(occurrences[2], DateTime(2026, 10, 17, 0, 0));
    expect(occurrences.last.isBefore(DateTime(2026, 10, 18)), isTrue);
  });
}
