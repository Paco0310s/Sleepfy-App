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

  // Cached AI Routine
  static Future<void> setRoutine(String routine) async {
    await _preferences.setString('cached_routine', routine);
    await _preferences.setString('cached_routine_date', DateTime.now().toIso8601String());
  }

  static String? get routine => _preferences.getString('cached_routine');
  static String? get routineDate => _preferences.getString('cached_routine_date');

  static Future<void> removeRoutine() async {
    await _preferences.remove('cached_routine');
    await _preferences.remove('cached_routine_date');
  }

  // Cerrar sesión completa y limpiar almacenamiento local
  static Future<void> logout() async {
    await _preferences.remove('token');
    await _preferences.remove('id');
    await _preferences.remove('name');
    await _preferences.remove('lastname');
    await _preferences.remove('email');
    await _preferences.remove('cached_routine');
    await _preferences.remove('cached_routine_date');
  }

  // Desafíos de sueño completados
  static List<String> get completedChallenges => _preferences.getStringList('completed_challenges') ?? [];

  static Future<void> toggleChallenge(String title) async {
    final list = List<String>.from(completedChallenges);
    if (list.contains(title)) {
      list.remove(title);
    } else {
      list.add(title);
    }
    await _preferences.setStringList('completed_challenges', list);
  }

  // Check-in matutino de energía
  static String? get morningMood => _preferences.getString('morning_mood');
  static String? get morningMoodDate => _preferences.getString('morning_mood_date');

  static Future<void> setMorningMood(String mood) async {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    await _preferences.setString('morning_mood', mood);
    await _preferences.setString('morning_mood_date', todayStr);
  }

  static bool get hasCheckedInToday {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    return morningMoodDate == todayStr && morningMood != null;
  }
}
