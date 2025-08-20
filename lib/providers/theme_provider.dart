import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  static const String _themeKey = 'isDarkMode';

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  // Toggle theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Set specific theme
  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Load theme from SharedPreferences
  void _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  // Save theme to SharedPreferences
  void _saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, _isDarkMode);
  }
}