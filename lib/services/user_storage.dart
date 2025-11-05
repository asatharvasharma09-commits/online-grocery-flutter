import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const String _keyName = 'user_name';
  static const String _keyEmail = 'user_email';
  static const String _keyPhone = 'user_phone';

  // Save user data
  static Future<void> saveUser({
    required String name,
    required String email,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPhone, phone);
  }

  // Get user data
  static Future<Map<String, String?>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyName),
      'email': prefs.getString(_keyEmail),
      'phone': prefs.getString(_keyPhone),
    };
  }

  // Clear user data (for logout)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPhone);
  }
}