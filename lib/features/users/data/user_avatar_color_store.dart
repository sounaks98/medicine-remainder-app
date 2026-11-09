import 'package:shared_preferences/shared_preferences.dart';

/// Optional list accent colors per profile (device-local, not in SQLite).
class UserAvatarColorStore {
  UserAvatarColorStore(this._prefs);

  final SharedPreferences _prefs;
  static const _prefix = 'user_avatar_color_';

  int? readColorValue(String userId) {
    return _prefs.getInt('$_prefix$userId');
  }

  Future<void> saveColorValue(String userId, int colorValue) async {
    await _prefs.setInt('$_prefix$userId', colorValue);
  }

  Future<void> removeColor(String userId) async {
    await _prefs.remove('$_prefix$userId');
  }
}
