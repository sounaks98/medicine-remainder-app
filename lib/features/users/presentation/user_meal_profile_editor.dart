import 'package:flutter/material.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';
import 'package:medicine_remainder_app/features/users/presentation/user_meal_profile_sheet.dart';

class UserMealProfileEditor extends StatelessWidget {
  const UserMealProfileEditor({
    super.key,
    required this.profile,
    required this.onChanged,
  });

  final UserMealProfile profile;
  final ValueChanged<UserMealProfile> onChanged;

  Future<void> _pickTime(BuildContext context, MealSlot meal) async {
    final initial =
        profile.timeForMeal(meal) ?? const TimeOfDay(hour: 20, minute: 0);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) {
      return;
    }
    switch (meal) {
      case MealSlot.breakfast:
        onChanged(
          profile.copyWith(breakfast: picked, breakfastSkipped: false),
        );
      case MealSlot.lunch:
        onChanged(profile.copyWith(lunch: picked, lunchSkipped: false));
      case MealSlot.dinner:
        onChanged(profile.copyWith(dinner: picked, dinnerSkipped: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final meal in MealSlot.values) ...[
          _mealRow(context, meal),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _mealRow(BuildContext context, MealSlot meal) {
    final skipped = switch (meal) {
      MealSlot.breakfast => profile.breakfastSkipped,
      MealSlot.lunch => profile.lunchSkipped,
      MealSlot.dinner => profile.dinnerSkipped,
    };
    final time = profile.timeForMeal(meal);
    return Row(
      children: [
        Expanded(child: Text(meal.label)),
        if (!skipped && time != null)
          Text(MedicineReviewTimeFormat.format(time)),
        const SizedBox(width: 8),
        TextButton(
          onPressed: skipped ? null : () => _pickTime(context, meal),
          child: Text(skipped ? 'Skipped' : 'Set time'),
        ),
        IconButton(
          tooltip: skipped ? 'Enable meal' : 'Skip meal',
          onPressed: () {
            switch (meal) {
              case MealSlot.breakfast:
                onChanged(
                  profile.copyWith(
                    breakfastSkipped: !profile.breakfastSkipped,
                  ),
                );
              case MealSlot.lunch:
                onChanged(
                  profile.copyWith(lunchSkipped: !profile.lunchSkipped),
                );
              case MealSlot.dinner:
                onChanged(
                  profile.copyWith(dinnerSkipped: !profile.dinnerSkipped),
                );
            }
          },
          icon: Icon(skipped ? Icons.check_circle_outline : Icons.close),
        ),
      ],
    );
  }
}
