import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void changeTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners(); // Powiadomienie wszystkich słuchaczy o zmianie
  }
}
