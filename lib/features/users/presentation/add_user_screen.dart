import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_remainder_app/app/di/user_providers.dart';
import 'package:medicine_remainder_app/app/router.dart';
import 'package:medicine_remainder_app/features/users/application/active_user_controller.dart';
import 'package:medicine_remainder_app/features/users/data/user_repository.dart';
import 'package:medicine_remainder_app/features/users/domain/user_avatar_color.dart';

class AddUserScreen extends ConsumerStatefulWidget {
  const AddUserScreen({super.key});

  @override
  ConsumerState<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends ConsumerState<AddUserScreen> {
  final _nameController = TextEditingController();
  int _selectedColorIndex = 0;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final repo = ref.read(userRepositoryProvider);
      final profile = await repo.createUser(_nameController.text);
      final color = kUserAvatarPresetColors[_selectedColorIndex];
      await ref
          .read(userAvatarColorStoreProvider)
          .saveColorValue(profile.id, color.toARGB32());
      await ref.read(activeUserSessionProvider.notifier).setActiveUser(profile.id);
      if (!mounted) {
        return;
      }
      context.go(AppRoutes.userHome(profile.id));
    } on UserRepositoryException catch (error) {
      setState(() => _error = error.message);
    } catch (error) {
      setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _nameController.text.trim();
    final canSave = name.isNotEmpty && !_saving;

    return Scaffold(
      appBar: AppBar(title: const Text('Add profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter a display name for this person. It appears on reminders '
              'and in the app bar.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Display name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              maxLength: 64,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            Text(
              'Avatar color (optional)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(kUserAvatarPresetColors.length, (index) {
                final color = kUserAvatarPresetColors[index];
                final selected = index == _selectedColorIndex;
                return InkWell(
                  onTap: () => setState(() => _selectedColorIndex = index),
                  customBorder: const CircleBorder(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 3,
                            )
                          : null,
                    ),
                  ),
                );
              }),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 32),
            FilledButton(
              onPressed: canSave ? _save : null,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create profile'),
            ),
          ],
        ),
      ),
    );
  }
}
