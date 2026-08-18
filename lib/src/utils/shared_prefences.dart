import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Token
  static Future<void> setToken(String token) async {
    await _preferences.setString('token', token);
  }

  static String? get token => _preferences.getString('token');

  static Future<void> removeToken() async {
    await _preferences.remove('token');
  }

  // Id
  static Future<void> setId(int id) async {
    await _preferences.setInt('id', id);
  }

  static int? get id => _preferences.getInt('id');

  static Future<void> removeId() async {
    await _preferences.remove('id');
  }

  // Name
  static Future<void> setName(String name) async {
    await _preferences.setString('name', name);
  }

  static String? get name => _preferences.getString('name');

  static Future<void> removeName() async {
    await _preferences.remove('name');
  }

  // LastName
  static Future<void> setLastName(String lastName) async {
    await _preferences.setString('lastname', lastName);
  }

  static String? get lastName => _preferences.getString('lastname');

  static Future<void> removeLastName() async {
    await _preferences.remove('lastname');
  }

  // Email
  static Future<void> setEmail(String email) async {
    await _preferences.setString('email', email);
  }

  static String? get email => _preferences.getString('email');

  static Future<void> removeEmail() async {
    await _preferences.remove('email');
  }
}
