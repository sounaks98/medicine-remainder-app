import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/app/di/user_providers.dart';
import 'package:medicine_remainder_app/features/users/application/active_user_session.dart';
import 'package:medicine_remainder_app/features/users/domain/user_profile.dart';

const String kLastActiveUserIdPrefsKey = 'last_active_user_id';

final activeUserSessionRefreshListenableProvider =
    Provider<ValueNotifier<int>>((ref) {
  final notifier = ValueNotifier(0);
  ref.onDispose(notifier.dispose);
  return notifier;
});

final activeUserSessionProvider =
    NotifierProvider<ActiveUserController, ActiveUserSession>(
  ActiveUserController.new,
);

/// Sync read of the active profile id (null when none selected).
final activeUserIdProvider = Provider<String?>((ref) {
  return ref.watch(activeUserSessionProvider).activeUserId;
});

/// Stream of the active profile row (display name, etc.).
final activeUserProvider = StreamProvider<UserProfile?>((ref) {
  final id = ref.watch(activeUserIdProvider);
  if (id == null) {
    return Stream.value(null);
  }
  return ref.watch(userRepositoryProvider).watchUser(id);
});

class ActiveUserController extends Notifier<ActiveUserSession> {
  StreamSubscription<List<UserProfile>>? _usersSub;
  bool _restoredFromPrefs = false;

  @override
  ActiveUserSession build() {
    _bootstrap();
    ref.onDispose(() => _usersSub?.cancel());
    return const ActiveUserSession(isReady: false);
  }

  void _bootstrap() {
    final prefs = ref.read(sharedPreferencesProvider);
    final repo = ref.read(userRepositoryProvider);
    final refresh = ref.read(activeUserSessionRefreshListenableProvider);

    _usersSub = repo.watchAllUsers().listen((users) async {
      String? activeId = state.activeUserId;
      if (!_restoredFromPrefs) {
        _restoredFromPrefs = true;
        activeId = prefs.getString(kLastActiveUserIdPrefsKey);
      }
      if (activeId != null && !users.any((u) => u.id == activeId)) {
        activeId = null;
        await prefs.remove(kLastActiveUserIdPrefsKey);
      }
      state = ActiveUserSession(
        isReady: true,
        activeUserId: activeId,
        users: users,
      );
      refresh.value++;
    });
  }

  Future<void> setActiveUser(String userId) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final user = await ref.read(userRepositoryProvider).getUser(userId);
    if (user == null) {
      return;
    }
    await prefs.setString(kLastActiveUserIdPrefsKey, userId);
    state = state.copyWith(activeUserId: userId);
    ref.read(activeUserSessionRefreshListenableProvider).value++;
  }

  Future<void> clearActiveUser() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(kLastActiveUserIdPrefsKey);
    state = state.copyWith(clearActiveUserId: true);
    ref.read(activeUserSessionRefreshListenableProvider).value++;
  }

  /// Deletes a profile, local prefs, and clears session if it was active.
  Future<void> deleteUser(String userId) async {
    await ref.read(userRepositoryProvider).deleteUser(userId);
    await ref.read(userAvatarColorStoreProvider).removeColor(userId);
    await ref.read(userMealProfileStoreProvider).remove(userId);
    if (state.activeUserId == userId) {
      await clearActiveUser();
    }
  }
}
