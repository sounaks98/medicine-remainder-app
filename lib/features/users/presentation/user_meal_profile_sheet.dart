import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/app/di/user_providers.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';

Future<void> showUserMealProfileSheet({
  required BuildContext context,
  required String userId,
  required VoidCallback onSaved,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: UserMealProfileSheet(userId: userId, onSaved: onSaved),
    ),
  );
}

class UserMealProfileSheet extends ConsumerStatefulWidget {
  const UserMealProfileSheet({
    super.key,
    required this.userId,
    required this.onSaved,
  });

  final String userId;
  final VoidCallback onSaved;

  @override
  ConsumerState<UserMealProfileSheet> createState() =>
      _UserMealProfileSheetState();
}

class _UserMealProfileSheetState extends ConsumerState<UserMealProfileSheet> {
  UserMealProfile? _profile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profile ??= ref.read(userMealProfileStoreProvider).read(widget.userId);
  }

  Future<void> _pickTime(MealSlot meal) async {
    final profile = _profile!;
    final initial = profile.timeForMeal(meal) ?? const TimeOfDay(hour: 8, minute: 0);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    setState(() {
      switch (meal) {
        case MealSlot.breakfast:
          _profile = profile.copyWith(
            breakfast: picked,
            breakfastSkipped: false,
          );
        case MealSlot.lunch:
          _profile = profile.copyWith(lunch: picked, lunchSkipped: false);
        case MealSlot.dinner:
          _profile = profile.copyWith(dinner: picked, dinnerSkipped: false);
      }
    });
  }

  Future<void> _save() async {
    await ref
        .read(userMealProfileStoreProvider)
        .save(widget.userId, _profile!);
    widget.onSaved();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Usual meal times',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Used for meal-based reminders on this device. You can skip meals '
              'without fixed times.',
            ),
            const SizedBox(height: 16),
            for (final meal in MealSlot.values) ...[
              _mealRow(meal),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: const Text('Save meal times')),
          ],
        ),
      ),
    );
  }

  Widget _mealRow(MealSlot meal) {
    final profile = _profile!;
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
          onPressed: skipped ? null : () => _pickTime(meal),
          child: Text(skipped ? 'Skipped' : 'Set time'),
        ),
        IconButton(
          tooltip: skipped ? 'Enable meal' : 'Skip meal',
          onPressed: () {
            setState(() {
              final current = _profile!;
              switch (meal) {
                case MealSlot.breakfast:
                  _profile = current.copyWith(
                    breakfastSkipped: !current.breakfastSkipped,
                  );
                case MealSlot.lunch:
                  _profile = current.copyWith(
                    lunchSkipped: !current.lunchSkipped,
                  );
                case MealSlot.dinner:
                  _profile = current.copyWith(
                    dinnerSkipped: !current.dinnerSkipped,
                  );
              }
            });
          },
          icon: Icon(skipped ? Icons.check_circle_outline : Icons.close),
        ),
      ],
    );
  }
}

abstract final class MedicineReviewTimeFormat {
  static String format(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }
}
