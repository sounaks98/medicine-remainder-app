import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_remainder_app/app/di/reminder_providers.dart';
import 'package:medicine_remainder_app/app/di/user_providers.dart';
import 'package:medicine_remainder_app/app/router.dart';
import 'package:medicine_remainder_app/features/medicines/domain/medication_record.dart';
import 'package:medicine_remainder_app/features/reminders/domain/medication_reminder_schedule.dart';
import 'package:medicine_remainder_app/features/users/domain/user_profile.dart';

class MedicineListScreen extends ConsumerWidget {
  const MedicineListScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(_profileProvider(userId));
    final medicinesAsync = ref.watch(_medicinesProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: profileAsync.when(
          data: (profile) => Text(profile?.displayName ?? 'Medicines'),
          loading: () => const Text('Medicines'),
          error: (_, _) => const Text('Medicines'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_outlined),
            tooltip: 'Profile meal times',
            onPressed: () => context.push(AppRoutes.userSettings(userId)),
          ),
          IconButton(
            icon: const Icon(Icons.event_note_outlined),
            tooltip: 'Adherence',
            onPressed: () => context.push(AppRoutes.adherence),
          ),
          IconButton(
            icon: const Icon(Icons.switch_account_outlined),
            tooltip: 'Switch profile',
            onPressed: () => context.go(AppRoutes.users),
          ),
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.science_outlined),
              tooltip: 'Gemma 3n LiteRT spike',
              onPressed: () => context.push(AppRoutes.modelSpike),
            ),
        ],
      ),
      body: medicinesAsync.when(
        data: (medicines) {
          if (medicines.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medication_outlined,
                      size: 56,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No medicines yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan a prescription and submit confirmed rows to see '
                      'medicines and reminders here.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: medicines.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final medicine = medicines[index];
              return _MedicineReminderTile(
                userId: userId,
                medicine: medicine,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load medicines: $error'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.capture),
        tooltip: 'Add prescription',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class _MedicineReminderTile extends ConsumerStatefulWidget {
  const _MedicineReminderTile({
    required this.userId,
    required this.medicine,
  });

  final String userId;
  final MedicationRecord medicine;

  @override
  ConsumerState<_MedicineReminderTile> createState() =>
      _MedicineReminderTileState();
}

class _MedicineReminderTileState extends ConsumerState<_MedicineReminderTile> {
  bool _deleting = false;

  Future<void> _confirmDelete() async {
    final name = widget.medicine.name.isEmpty
        ? 'this medicine'
        : widget.medicine.name;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove medicine?'),
        content: Text(
          'Delete $name and cancel all scheduled reminders for it? '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    setState(() => _deleting = true);
    try {
      await ref.read(medicineReminderDeleterProvider).delete(
            userId: widget.userId,
            medicineId: widget.medicine.id,
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name removed.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _deleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicine = widget.medicine;
    final strength = _strengthLabel(medicine);
    final schedule = _scheduleLabel(medicine);
    final course = _courseLabel(medicine);

    return ListTile(
      leading: CircleAvatar(
        child: Text(
          medicine.name.isNotEmpty ? medicine.name[0].toUpperCase() : '?',
        ),
      ),
      title: Text(medicine.name.isEmpty ? 'Medicine' : medicine.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (strength != null) Text(strength),
          if (medicine.doseInstructions.isNotEmpty)
            Text(medicine.doseInstructions),
          Text(schedule),
          if (course != null)
            Text(
              course,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
        ],
      ),
      isThreeLine: true,
      trailing: _deleting
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete medicine and reminders',
              onPressed: _confirmDelete,
            ),
    );
  }
}

String? _strengthLabel(MedicationRecord record) {
  final value = record.strength.trim();
  if (value.isEmpty) {
    return null;
  }
  final unit = record.strengthUnit.trim();
  return unit.isEmpty ? value : '$value $unit';
}

String _scheduleLabel(MedicationRecord record) {
  final schedule = MedicationReminderSchedule.decodeJson(
    record.reminderScheduleJson,
  );
  if (schedule != null) {
    if (schedule.mode == ReminderScheduleMode.mealBased) {
      final meal = schedule.meal;
      final relationship = switch (meal.relationship) {
        MealRelationship.before => 'Before',
        MealRelationship.withMeal => 'With',
        MealRelationship.after => 'After',
      };
      final mealName = switch (meal.meal) {
        MealSlot.breakfast => 'breakfast',
        MealSlot.lunch => 'lunch',
        MealSlot.dinner => 'dinner',
      };
      final offset = meal.offsetMinutes > 0 ? ' (${meal.offsetMinutes} min)' : '';
      return '$relationship $mealName$offset';
    }
    final interval = schedule.interval;
    final time = interval.firstDoseTime;
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    return 'Every ${interval.intervalHours} h · first dose $hh:$mm';
  }

  final parts = <String>[
    if (record.frequency.isNotEmpty) record.frequency,
    if (record.timing.isNotEmpty) record.timing,
  ];
  if (parts.isEmpty) {
    return 'Reminders scheduled';
  }
  return parts.join(' · ');
}

String? _courseLabel(MedicationRecord record) {
  if (record.startAt != null && record.endAt != null) {
    return 'Course ${record.startAt} → ${record.endAt}';
  }
  if (record.duration.isNotEmpty) {
    return record.duration;
  }
  final schedule = MedicationReminderSchedule.decodeJson(
    record.reminderScheduleJson,
  );
  if (schedule != null) {
    return '${schedule.course.durationDays}-day course';
  }
  return null;
}

final _profileProvider = StreamProvider.family<UserProfile?, String>((ref, userId) {
  return ref.watch(userRepositoryProvider).watchUser(userId);
});

final _medicinesProvider =
    StreamProvider.family<List<MedicationRecord>, String>((ref, userId) {
  return ref.watch(medicineRepositoryProvider).watchConfirmed(userId: userId);
});
