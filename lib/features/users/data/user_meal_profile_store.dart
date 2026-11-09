import 'dart:convert';

import 'package:medicine_remainder_app/features/users/domain/user_meal_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMealProfileStore {
  UserMealProfileStore(this._prefs);

  final SharedPreferences _prefs;
  static const _prefix = 'user_meal_profile_';

  UserMealProfile read(String userId) {
    final raw = _prefs.getString('$_prefix$userId');
    if (raw == null || raw.isEmpty) {
      return const UserMealProfile();
    }
    return UserMealProfile.fromJson(
      Map<String, Object?>.from(jsonDecode(raw) as Map),
    );
  }

  Future<void> save(String userId, UserMealProfile profile) async {
    await _prefs.setString(
      '$_prefix$userId',
      jsonEncode(profile.toJson()),
    );
  }

  Future<void> remove(String userId) async {
    await _prefs.remove('$_prefix$userId');
  }
}
