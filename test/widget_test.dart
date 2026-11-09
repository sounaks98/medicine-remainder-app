import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/app/di/database_providers.dart';
import 'package:medicine_remainder_app/app/di/user_providers.dart';
import 'package:medicine_remainder_app/data/database/app_database.dart';
import 'package:medicine_remainder_app/features/users/presentation/add_user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add profile screen shows first-run form', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase.forTesting();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(home: AddUserScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Display name'), findsOneWidget);
    expect(find.text('Create profile'), findsOneWidget);

    await db.close();
  });
}
