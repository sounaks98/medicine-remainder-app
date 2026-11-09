import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';
import 'package:medicine_remainder_app/features/users/application/active_user_controller.dart';
import 'package:medicine_remainder_app/features/users/data/drift_user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/app/di/database_providers.dart';
import 'package:medicine_remainder_app/app/di/user_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase.forTesting();
  });

  tearDown(() async {
    await db.close();
  });

  test('restores last active user when row exists', () async {
    final userRepo = DriftUserRepository(db);
    final profile = await userRepo.createUser('Stored');
    await prefs.setString(kLastActiveUserIdPrefsKey, profile.id);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
      ],
    );
    addTearDown(container.dispose);

    container.read(activeUserSessionProvider);
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final session = container.read(activeUserSessionProvider);
    expect(session.isReady, isTrue);
    expect(session.activeUserId, profile.id);
  });

  test('clears stale last active user id', () async {
    await prefs.setString(kLastActiveUserIdPrefsKey, 'missing-id');

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
      ],
    );
    addTearDown(container.dispose);

    container.read(activeUserSessionProvider);
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final session = container.read(activeUserSessionProvider);
    expect(session.activeUserId, isNull);
    expect(prefs.getString(kLastActiveUserIdPrefsKey), isNull);
  });
}
