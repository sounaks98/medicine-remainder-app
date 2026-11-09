import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_remainder_app/app/di/user_providers.dart';
import 'package:medicine_remainder_app/app/router.dart';
import 'package:medicine_remainder_app/features/users/application/active_user_controller.dart';
import 'package:medicine_remainder_app/features/users/data/user_repository.dart';
import 'package:medicine_remainder_app/features/users/domain/user_avatar_color.dart';
import 'package:medicine_remainder_app/features/users/domain/user_profile.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(_allUsersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profiles')),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load profiles: $error')),
        data: (users) {
          if (users.isEmpty) {
            return _EmptyUsersBody(
              onAdd: () => context.push(AppRoutes.usersAdd),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              return _UserListTile(user: user);
            },
          );
        },
      ),
      floatingActionButton: usersAsync.maybeWhen(
        data: (users) => users.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: () => context.push(AppRoutes.usersAdd),
                icon: const Icon(Icons.person_add_outlined),
                label: const Text('Add profile'),
              ),
        orElse: () => null,
      ),
    );
  }
}

class _EmptyUsersBody extends StatelessWidget {
  const _EmptyUsersBody({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Who is this device for?',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a local profile to store medicines and reminders. '
              'You can add more family members later.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('Add profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserListTile extends ConsumerWidget {
  const _UserListTile({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorStore = ref.watch(userAvatarColorStoreProvider);
    final color = avatarColorForUser(
      user.id,
      storedValue: colorStore.readColorValue(user.id),
    );
    final local = user.createdAt.toLocal();
    final dateLabel =
        '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(
          _initials(user.displayName),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      title: Text(user.displayName),
      subtitle: Text('Created $dateLabel'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete profile',
            onPressed: () => _confirmDeleteProfile(context, ref, user),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () async {
        await ref.read(activeUserSessionProvider.notifier).setActiveUser(user.id);
        if (context.mounted) {
          context.go(AppRoutes.userHome(user.id));
        }
      },
    );
  }

  Future<void> _confirmDeleteProfile(
    BuildContext context,
    WidgetRef ref,
    UserProfile user,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete profile?'),
        content: Text(
          'Remove “${user.displayName}” and all of their medicines, '
          'prescriptions, and reminders on this device. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    try {
      await ref.read(activeUserSessionProvider.notifier).deleteUser(user.id);
      if (!context.mounted) {
        return;
      }
      context.go(AppRoutes.users);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.displayName} deleted.')),
      );
    } on UserRepositoryException catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}

final _allUsersProvider = StreamProvider<List<UserProfile>>((ref) {
  return ref.watch(userRepositoryProvider).watchAllUsers();
});
