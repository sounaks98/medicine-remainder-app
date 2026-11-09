import 'package:medicine_remainder_app/features/users/domain/user_profile.dart';

/// Bootstrap + active profile selection state for routing and tenancy.
class ActiveUserSession {
  const ActiveUserSession({
    required this.isReady,
    this.activeUserId,
    this.users = const [],
  });

  final bool isReady;
  final String? activeUserId;
  final List<UserProfile> users;

  bool get hasUsers => users.isNotEmpty;

  UserProfile? get activeUser {
    if (activeUserId == null) {
      return null;
    }
    for (final user in users) {
      if (user.id == activeUserId) {
        return user;
      }
    }
    return null;
  }

  ActiveUserSession copyWith({
    bool? isReady,
    String? activeUserId,
    bool clearActiveUserId = false,
    List<UserProfile>? users,
  }) {
    return ActiveUserSession(
      isReady: isReady ?? this.isReady,
      activeUserId: clearActiveUserId ? null : (activeUserId ?? this.activeUserId),
      users: users ?? this.users,
    );
  }
}
