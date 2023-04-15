import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider with ChangeNotifier {
  late bool _isDarkTheme;

  Future<void> toggleThemeMode() async {
    Box box = await Hive.openBox('configs');

    _isDarkTheme = box.get('isDarkTheme') ?? false;

    _isDarkTheme = !_isDarkTheme;

    await box.put('isDarkTheme', _isDarkTheme);

    notifyListeners();
  }
}
