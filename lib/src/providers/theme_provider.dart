import 'package:flutter/material.dart';
import 'package:sleepfy/src/utils/shared_prefences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  ThemeProvider() {
    _isDarkMode = UserPreferences.isDarkMode;
  }

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await UserPreferences.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  void setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    await UserPreferences.setIsDarkMode(value);
    notifyListeners();
  }
}
