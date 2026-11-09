/// Local device profile (not a cloud account).
class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile copyWith({
    String? displayName,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
