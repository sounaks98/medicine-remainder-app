import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_course.dart';

enum ReminderScheduleMode { mealBased, intervalBased }

enum MealSlot { breakfast, lunch, dinner }

enum MealRelationship { before, withMeal, after }

/// User-confirmed meal-relative reminder rule (source of truth for meal mode).
class MealBasedSchedule {
  const MealBasedSchedule({
    required this.meal,
    required this.relationship,
    this.offsetMinutes = 5,
  }) : assert(offsetMinutes >= 0);

  final MealSlot meal;
  final MealRelationship relationship;
  final int offsetMinutes;

  MealBasedSchedule copyWith({
    MealSlot? meal,
    MealRelationship? relationship,
    int? offsetMinutes,
  }) {
    return MealBasedSchedule(
      meal: meal ?? this.meal,
      relationship: relationship ?? this.relationship,
      offsetMinutes: offsetMinutes ?? this.offsetMinutes,
    );
  }

  Map<String, Object?> toJson() => {
        'meal': meal.name,
        'relationship': relationship.name,
        'offsetMinutes': offsetMinutes,
      };

  factory MealBasedSchedule.fromJson(Map<String, Object?> json) {
    return MealBasedSchedule(
      meal: MealSlot.values.byName(json['meal'] as String),
      relationship: MealRelationship.values.byName(json['relationship'] as String),
      offsetMinutes: json['offsetMinutes'] as int? ?? 5,
    );
  }
}

/// User-confirmed interval rule (does not infer from "twice daily" text).
class IntervalBasedSchedule {
  const IntervalBasedSchedule({
    required this.intervalHours,
    required this.firstDoseTime,
  }) : assert(intervalHours > 0);

  final int intervalHours;
  final TimeOfDay firstDoseTime;

  IntervalBasedSchedule copyWith({
    int? intervalHours,
    TimeOfDay? firstDoseTime,
  }) {
    return IntervalBasedSchedule(
      intervalHours: intervalHours ?? this.intervalHours,
      firstDoseTime: firstDoseTime ?? this.firstDoseTime,
    );
  }

  Map<String, Object?> toJson() => {
        'intervalHours': intervalHours,
        'firstDoseHour': firstDoseTime.hour,
        'firstDoseMinute': firstDoseTime.minute,
      };

  factory IntervalBasedSchedule.fromJson(Map<String, Object?> json) {
    return IntervalBasedSchedule(
      intervalHours: json['intervalHours'] as int,
      firstDoseTime: TimeOfDay(
        hour: json['firstDoseHour'] as int,
        minute: json['firstDoseMinute'] as int,
      ),
    );
  }
}

/// Confirmed hybrid schedule for one medicine row.
class MedicationReminderSchedule {
  const MedicationReminderSchedule({
    required this.mode,
    required this.meal,
    required this.interval,
    required this.course,
  });

  final ReminderScheduleMode mode;
  final MealBasedSchedule meal;
  final IntervalBasedSchedule interval;
  final MedicationCourse course;

  MedicationReminderSchedule copyWith({
    ReminderScheduleMode? mode,
    MealBasedSchedule? meal,
    IntervalBasedSchedule? interval,
    MedicationCourse? course,
  }) {
    return MedicationReminderSchedule(
      mode: mode ?? this.mode,
      meal: meal ?? this.meal,
      interval: interval ?? this.interval,
      course: course ?? this.course,
    );
  }

  Map<String, Object?> toJson() => {
        'schemaVersion': 1,
        'mode': mode.name,
        'meal': meal.toJson(),
        'interval': interval.toJson(),
        'course': course.toJson(),
      };

  factory MedicationReminderSchedule.fromJson(Map<String, Object?> json) {
    return MedicationReminderSchedule(
      mode: ReminderScheduleMode.values.byName(json['mode'] as String),
      meal: MealBasedSchedule.fromJson(
        Map<String, Object?>.from(json['meal'] as Map),
      ),
      interval: IntervalBasedSchedule.fromJson(
        Map<String, Object?>.from(json['interval'] as Map),
      ),
      course: MedicationCourse.fromJson(
        Map<String, Object?>.from(json['course'] as Map),
      ),
    );
  }

  String encodeJson() => jsonEncode(toJson());

  static MedicationReminderSchedule? decodeJson(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return MedicationReminderSchedule.fromJson(
      Map<String, Object?>.from(jsonDecode(raw) as Map),
    );
  }

  static MedicationReminderSchedule defaults() {
    return MedicationReminderSchedule(
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
      course: MedicationCourse.startingToday(durationDays: 7),
    );
  }
}
