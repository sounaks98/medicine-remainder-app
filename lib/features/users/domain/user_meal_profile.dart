import 'package:flutter/material.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';

/// Per-profile usual meal times (local device; not medical dosing).
class UserMealProfile {
  const UserMealProfile({
    this.breakfast,
    this.lunch,
    this.dinner,
    this.breakfastSkipped = false,
    this.lunchSkipped = false,
    this.dinnerSkipped = false,
  });

  final TimeOfDay? breakfast;
  final TimeOfDay? lunch;
  final TimeOfDay? dinner;
  final bool breakfastSkipped;
  final bool lunchSkipped;
  final bool dinnerSkipped;

  TimeOfDay? timeForMeal(MealSlot meal) {
    switch (meal) {
      case MealSlot.breakfast:
        return breakfastSkipped ? null : breakfast;
      case MealSlot.lunch:
        return lunchSkipped ? null : lunch;
      case MealSlot.dinner:
        return dinnerSkipped ? null : dinner;
    }
  }

  bool isMealConfigured(MealSlot meal) => timeForMeal(meal) != null;

  UserMealProfile copyWith({
    TimeOfDay? breakfast,
    TimeOfDay? lunch,
    TimeOfDay? dinner,
    bool? breakfastSkipped,
    bool? lunchSkipped,
    bool? dinnerSkipped,
    bool clearBreakfast = false,
    bool clearLunch = false,
    bool clearDinner = false,
  }) {
    return UserMealProfile(
      breakfast: clearBreakfast ? null : (breakfast ?? this.breakfast),
      lunch: clearLunch ? null : (lunch ?? this.lunch),
      dinner: clearDinner ? null : (dinner ?? this.dinner),
      breakfastSkipped: breakfastSkipped ?? this.breakfastSkipped,
      lunchSkipped: lunchSkipped ?? this.lunchSkipped,
      dinnerSkipped: dinnerSkipped ?? this.dinnerSkipped,
    );
  }

  Map<String, Object?> toJson() => {
        'breakfastHour': breakfast?.hour,
        'breakfastMinute': breakfast?.minute,
        'lunchHour': lunch?.hour,
        'lunchMinute': lunch?.minute,
        'dinnerHour': dinner?.hour,
        'dinnerMinute': dinner?.minute,
        'breakfastSkipped': breakfastSkipped,
        'lunchSkipped': lunchSkipped,
        'dinnerSkipped': dinnerSkipped,
      };

  factory UserMealProfile.fromJson(Map<String, Object?> json) {
    TimeOfDay? readTime(String hourKey, String minuteKey) {
      final h = json[hourKey];
      final m = json[minuteKey];
      if (h == null || m == null) {
        return null;
      }
      return TimeOfDay(hour: h as int, minute: m as int);
    }

    return UserMealProfile(
      breakfast: readTime('breakfastHour', 'breakfastMinute'),
      lunch: readTime('lunchHour', 'lunchMinute'),
      dinner: readTime('dinnerHour', 'dinnerMinute'),
      breakfastSkipped: json['breakfastSkipped'] as bool? ?? false,
      lunchSkipped: json['lunchSkipped'] as bool? ?? false,
      dinnerSkipped: json['dinnerSkipped'] as bool? ?? false,
    );
  }
}

extension MealSlotLabel on MealSlot {
  String get label {
    switch (this) {
      case MealSlot.breakfast:
        return 'Breakfast';
      case MealSlot.lunch:
        return 'Lunch';
      case MealSlot.dinner:
        return 'Dinner';
    }
  }
}
