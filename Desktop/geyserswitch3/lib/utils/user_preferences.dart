import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences _preferences =
      SharedPreferences.getInstance() as SharedPreferences;

  static const _keyUsername = 'username';
  static const _keyEmail = 'email';
  static const _keyUnits = 'units';
  static const _keyImage = 'image';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);

  static String? getUsername() => _preferences.getString(_keyUsername);

  static Future setEmail(String email) async =>
      await _preferences.setString(_keyEmail, email);

  static String? getEmail() => _preferences.getString(_keyEmail);

  static Future setUnits(List<String> units) async =>
      await _preferences.setStringList(_keyUnits, units);

  static List<String>? getUnits() => _preferences.getStringList(_keyUnits);
}
