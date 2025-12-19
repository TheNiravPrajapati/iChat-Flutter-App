import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _themeKey = 'isDarkMode';

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme(bool value) async {
    _isDarkMode = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, value);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }
}
