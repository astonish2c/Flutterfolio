import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;
  ThemeMode _themeMode = ThemeMode.light;

  get themeMode => _themeMode;

  void toggleThemeMode() {
    isDark = !isDark;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
