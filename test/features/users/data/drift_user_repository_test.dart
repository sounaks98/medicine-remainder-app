import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';
import 'package:medicine_remainder_app/features/users/data/drift_user_repository.dart';
import 'package:medicine_remainder_app/features/users/data/user_repository.dart';

void main() {
  late AppDatabase db;
  late DriftUserRepository repository;

  setUp(() {
    db = AppDatabase.forTesting();
    repository = DriftUserRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('createUser and watchAllUsers', () async {
    final profile = await repository.createUser('Priya');
    expect(profile.displayName, 'Priya');

    final listed = await repository.watchAllUsers().first;
    expect(listed.single.id, profile.id);
  });

  test('updateDisplayName', () async {
    final profile = await repository.createUser('Alex');
    await repository.updateDisplayName(profile.id, 'Alexander');
    final updated = await repository.getUser(profile.id);
    expect(updated?.displayName, 'Alexander');
  });

  test('deleteUser rejects last profile', () async {
    final profile = await repository.createUser('Only one');
    expect(
      () => repository.deleteUser(profile.id),
      throwsA(isA<UserRepositoryException>()),
    );
  });

  test('deleteUser succeeds when another profile exists', () async {
    final a = await repository.createUser('A');
    final b = await repository.createUser('B');
    await repository.deleteUser(a.id);
    final listed = await repository.watchAllUsers().first;
    expect(listed.map((u) => u.id).toList(), [b.id]);
  });
}
