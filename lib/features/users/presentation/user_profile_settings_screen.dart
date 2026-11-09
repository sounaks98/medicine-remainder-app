import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/app/di/user_providers.dart';
import 'package:medicine_remainder_app/features/users/application/user_meal_profile_actions.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';
import 'package:medicine_remainder_app/features/users/presentation/user_meal_profile_editor.dart';

/// Profile settings — sole place to configure usual meal times.
class UserProfileSettingsScreen extends ConsumerStatefulWidget {
  const UserProfileSettingsScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<UserProfileSettingsScreen> createState() =>
      _UserProfileSettingsScreenState();
}

class _UserProfileSettingsScreenState
    extends ConsumerState<UserProfileSettingsScreen> {
  UserMealProfile? _draft;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= ref.read(userMealProfileProvider(widget.userId));
  }

  Future<void> _save() async {
    if (_draft == null || _saving) {
      return;
    }
    setState(() => _saving = true);
    try {
      final count = await ref
          .read(userMealProfileRegistryProvider.notifier)
          .saveAndReschedule(widget.userId, _draft!);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            count > 0
                ? 'Meal times saved. $count reminder(s) updated.'
                : 'Meal times saved.',
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(_profileNameProvider(widget.userId));
    final draft = _draft ?? const UserMealProfile();

    return Scaffold(
      appBar: AppBar(
        title: profileAsync.when(
          data: (name) => Text(name ?? 'Profile settings'),
          loading: () => const Text('Profile settings'),
          error: (_, _) => const Text('Profile settings'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Meal times',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Meal-based medicine reminders use these times for this profile only. '
            'Interval-based medicines use the times you set on each medicine row.',
          ),
          const SizedBox(height: 16),
          UserMealProfileEditor(
            profile: draft,
            onChanged: (value) => setState(() => _draft = value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save meal times'),
          ),
        ],
      ),
    );
  }
}

final _profileNameProvider = StreamProvider.family<String?, String>((ref, userId) {
  return ref.watch(userRepositoryProvider).watchUser(userId).map((u) => u?.displayName);
});
