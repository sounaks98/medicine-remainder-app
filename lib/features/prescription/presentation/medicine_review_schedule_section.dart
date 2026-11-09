import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_remainder_app/app/router.dart';
import 'package:medicine_remainder_app/features/prescription/presentation/editable_medicine_row.dart';
import 'package:medicine_remainder_app/features/reminders/domain/interval_occurrence_generator.dart';
import 'package:medicine_remainder_app/features/reminders/domain/meal_schedule_resolver.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_course.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';

class MedicineReviewScheduleSection extends StatelessWidget {
  const MedicineReviewScheduleSection({
    super.key,
    required this.row,
    required this.readOnly,
    required this.mealProfile,
    required this.userId,
    required this.onChanged,
  });

  final EditableMedicineRow row;
  final bool readOnly;
  final UserMealProfile mealProfile;
  final String userId;
  final VoidCallback onChanged;

  static const _intervalPresets = [4, 6, 8, 12, 24];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final schedule = row.reminderSchedule;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Reminder schedule', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        SegmentedButton<ReminderScheduleMode>(
          segments: const [
            ButtonSegment(
              value: ReminderScheduleMode.mealBased,
              label: Text('Meal-based'),
            ),
            ButtonSegment(
              value: ReminderScheduleMode.intervalBased,
              label: Text('Interval-based'),
            ),
          ],
          selected: {schedule.mode},
          onSelectionChanged: readOnly
              ? null
              : (selection) {
                  row.reminderSchedule = schedule.copyWith(mode: selection.first);
                  onChanged();
                },
        ),
        const SizedBox(height: 12),
        if (schedule.mode == ReminderScheduleMode.mealBased)
          _mealBasedFields(context)
        else
          _intervalFields(context),
        const SizedBox(height: 16),
        Text('Treatment duration', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        _courseFields(context),
        const SizedBox(height: 8),
        _schedulePreview(context),
      ],
    );
  }

  Widget _mealBasedFields(BuildContext context) {
    final meal = row.reminderSchedule.meal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownMenu<MealSlot>(
          initialSelection: meal.meal,
          label: const Text('Meal'),
          dropdownMenuEntries: MealSlot.values
              .map((m) => DropdownMenuEntry(value: m, label: m.label))
              .toList(),
          onSelected: readOnly
              ? null
              : (value) {
                  if (value == null) return;
                  row.reminderSchedule = row.reminderSchedule.copyWith(
                    meal: meal.copyWith(meal: value),
                  );
                  onChanged();
                },
        ),
        const SizedBox(height: 8),
        DropdownMenu<MealRelationship>(
          initialSelection: meal.relationship,
          label: const Text('Meal relationship'),
          dropdownMenuEntries: const [
            DropdownMenuEntry(
              value: MealRelationship.before,
              label: 'Before meal',
            ),
            DropdownMenuEntry(
              value: MealRelationship.withMeal,
              label: 'With meal',
            ),
            DropdownMenuEntry(
              value: MealRelationship.after,
              label: 'After meal',
            ),
          ],
          onSelected: readOnly
              ? null
              : (value) {
                  if (value == null) return;
                  row.reminderSchedule = row.reminderSchedule.copyWith(
                    meal: meal.copyWith(relationship: value),
                  );
                  onChanged();
                },
        ),
        if (meal.relationship != MealRelationship.withMeal) ...[
          const SizedBox(height: 8),
          TextFormField(
            readOnly: readOnly,
            initialValue: '${meal.offsetMinutes}',
            decoration: const InputDecoration(
              labelText: 'Minutes before/after meal',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: readOnly
                ? null
                : (value) {
                    final minutes = int.tryParse(value);
                    if (minutes == null || minutes < 0) return;
                    row.reminderSchedule = row.reminderSchedule.copyWith(
                      meal: meal.copyWith(offsetMinutes: minutes),
                    );
                    onChanged();
                  },
          ),
        ],
        const SizedBox(height: 8),
        _missingMealBanner(context),
      ],
    );
  }

  Widget _missingMealBanner(BuildContext context) {
    final meal = row.reminderSchedule.meal;
    if (mealProfile.isMealConfigured(meal.meal)) {
      return const SizedBox.shrink();
    }
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${meal.meal.label} time is not set in your profile.',
              style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
            ),
            const SizedBox(height: 8),
            if (!readOnly)
              TextButton(
                onPressed: () =>
                    context.push(AppRoutes.userSettings(userId)),
                child: const Text('Open profile meal settings'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _intervalFields(BuildContext context) {
    final interval = row.reminderSchedule.interval;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownMenu<int>(
          initialSelection: interval.intervalHours,
          label: const Text('Repeat every (hours)'),
          dropdownMenuEntries: _intervalPresets
              .map(
                (h) => DropdownMenuEntry(
                  value: h,
                  label: '$h hours',
                ),
              )
              .toList(),
          onSelected: readOnly
              ? null
              : (value) {
                  if (value == null) return;
                  row.reminderSchedule = row.reminderSchedule.copyWith(
                    interval: interval.copyWith(intervalHours: value),
                  );
                  onChanged();
                },
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('First dose / reminder time'),
          subtitle: Text(_formatTime(interval.firstDoseTime)),
          trailing: readOnly
              ? null
              : TextButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: interval.firstDoseTime,
                    );
                    if (picked == null) return;
                    row.reminderSchedule = row.reminderSchedule.copyWith(
                      interval: interval.copyWith(firstDoseTime: picked),
                    );
                    onChanged();
                  },
                  child: const Text('Set time'),
                ),
        ),
      ],
    );
  }

  Widget _courseFields(BuildContext context) {
    final course = row.reminderSchedule.course;
    final end = CourseDateMath.inclusiveEndDate(
      course.startDate,
      course.durationDays,
    );

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Start date'),
          subtitle: Text(CourseDateMath.toDateString(course.startDate)),
          trailing: readOnly
              ? null
              : TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: course.startDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked == null) return;
                    row.reminderSchedule = row.reminderSchedule.copyWith(
                      course: course.copyWith(startDate: picked),
                    );
                    onChanged();
                  },
                  child: const Text('Change'),
                ),
        ),
        TextFormField(
          readOnly: readOnly,
          initialValue: '${course.durationDays}',
          decoration: const InputDecoration(
            labelText: 'Duration (calendar days)',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: readOnly
              ? null
              : (value) {
                  final days = int.tryParse(value);
                  if (days == null || days < 1) return;
                  row.reminderSchedule = row.reminderSchedule.copyWith(
                    course: course.copyWith(durationDays: days),
                  );
                  onChanged();
                },
        ),
        const SizedBox(height: 8),
        Text(
          'End date (inclusive): ${CourseDateMath.toDateString(end)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _schedulePreview(BuildContext context) {
    final schedule = row.reminderSchedule;
    String preview;
    try {
      if (schedule.mode == ReminderScheduleMode.mealBased) {
        preview = MealScheduleResolver.resolve(
          schedule: schedule.meal,
          profile: mealProfile,
          onLocalDate: schedule.course.startDate,
        ).previewLabel;
      } else {
        preview = IntervalOccurrenceGenerator.previewLabel(
          schedule: schedule.interval,
          course: schedule.course,
        );
      }
    } on MissingMealTimeException catch (error) {
      preview = error.toString();
    }

    return Text(
      'Schedule preview: $preview',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  static String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }
}
