import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_remainder_app/app/di/reminder_providers.dart';
import 'package:medicine_remainder_app/app/di/user_providers.dart';
import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';

class UserMealProfileRegistry extends Notifier<Map<String, UserMealProfile>> {
  @override
  Map<String, UserMealProfile> build() => {};

  UserMealProfile profileFor(String userId) {
    return state[userId] ?? ref.read(userMealProfileStoreProvider).read(userId);
  }

  Future<int> saveAndReschedule(String userId, UserMealProfile profile) async {
    await ref.read(userMealProfileStoreProvider).save(userId, profile);
    state = {...state, userId: profile};
    final user = await ref.read(userRepositoryProvider).getUser(userId);
    if (user == null) {
      return 0;
    }
    await ref
        .read(notificationSchedulerProvider)
        .ensureAndroidAlarmSchedulingReady();
    return ref.read(medicineReminderOrchestratorProvider).rescheduleAllForUser(
          userId: userId,
          displayName: user.displayName,
          mealProfile: profile,
        );
  }
}

final userMealProfileRegistryProvider =
    NotifierProvider<UserMealProfileRegistry, Map<String, UserMealProfile>>(
  UserMealProfileRegistry.new,
);

final userMealProfileProvider = Provider.family<UserMealProfile, String>(
  (ref, userId) {
    ref.watch(userMealProfileRegistryProvider);
    return ref.read(userMealProfileRegistryProvider.notifier).profileFor(userId);
  },
);
