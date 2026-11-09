import 'package:medicine_remainder_app/features/users/domain/user_profile.dart';

class UserRepositoryException implements Exception {
  UserRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract class UserRepository {
  Stream<List<UserProfile>> watchAllUsers();

  Stream<UserProfile?> watchUser(String id);

  Future<UserProfile?> getUser(String id);

  Future<UserProfile> createUser(String displayName);

  Future<void> updateDisplayName(String id, String displayName);

  Future<void> deleteUser(String id);
}
