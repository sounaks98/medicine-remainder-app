import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/app/di/database_providers.dart';
import 'package:medicine_remainder_app/features/medicines/data/drift_medicine_repository.dart';
import 'package:medicine_remainder_app/features/medicines/data/medicine_repository.dart';
import 'package:medicine_remainder_app/features/users/data/drift_user_repository.dart';
import 'package:medicine_remainder_app/features/users/data/user_avatar_color_store.dart';
import 'package:medicine_remainder_app/features/users/data/user_meal_profile_store.dart';
import 'package:medicine_remainder_app/features/users/data/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return DriftUserRepository(ref.watch(appDatabaseProvider));
});

final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  return DriftMedicineRepository(ref.watch(appDatabaseProvider));
});

final userAvatarColorStoreProvider = Provider<UserAvatarColorStore>((ref) {
  return UserAvatarColorStore(ref.watch(sharedPreferencesProvider));
});

final userMealProfileStoreProvider = Provider<UserMealProfileStore>((ref) {
  return UserMealProfileStore(ref.watch(sharedPreferencesProvider));
});
