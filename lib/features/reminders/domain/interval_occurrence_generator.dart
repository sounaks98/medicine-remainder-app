import 'package:flutter/material.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_course.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';

/// Deterministic interval occurrences within inclusive course dates (local).
abstract final class IntervalOccurrenceGenerator {
  static List<DateTime> generate({
    required IntervalBasedSchedule schedule,
    required MedicationCourse course,
  }) {
    final occurrences = <DateTime>[];
    final startDay = CourseDateMath.dateOnly(course.startDate);
    final endDay = CourseDateMath.inclusiveEndDate(
      course.startDate,
      course.durationDays,
    );

    var cursor = DateTime(
      startDay.year,
      startDay.month,
      startDay.day,
      schedule.firstDoseTime.hour,
      schedule.firstDoseTime.minute,
    );

    final interval = Duration(hours: schedule.intervalHours);
    final endExclusive = endDay.add(const Duration(days: 1));

    while (cursor.isBefore(endExclusive)) {
      if (CourseDateMath.isWithinInclusiveCourse(cursor, course)) {
        occurrences.add(cursor);
      }
      cursor = cursor.add(interval);
      if (occurrences.length > 10_000) {
        break;
      }
    }

    return occurrences;
  }

  static String previewLabel({
    required IntervalBasedSchedule schedule,
    required MedicationCourse course,
  }) {
    final first = generate(schedule: schedule, course: course).firstOrNull;
    if (first == null) {
      return 'Every ${schedule.intervalHours} hours (no occurrences in course)';
    }
    final t = TimeOfDay.fromDateTime(first);
    return 'Every ${schedule.intervalHours} h from ${_formatTime(t)} on course days';
  }

  static String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }
}
