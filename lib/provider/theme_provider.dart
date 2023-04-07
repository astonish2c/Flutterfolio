import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider with ChangeNotifier {
  // final bool _isDarkTheme = false;
  late bool _isDarkTheme;

  Future<void> toggleThemeMode() async {
    // _isDarkTheme = !_isDarkTheme;

    Box box = await Hive.openBox('themeBox');

    _isDarkTheme = box.get('isDarkTheme') ?? false;

    _isDarkTheme = !_isDarkTheme;

    await box.put('isDarkTheme', _isDarkTheme);

    notifyListeners();
  }
}
