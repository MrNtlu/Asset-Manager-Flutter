import 'package:asset_flutter/static/shared_pref.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void initTheme(bool isDarkTheme) {
    themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool isDarkTheme) {
    themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    SharedPref().setTheme(isDarkTheme);
  }
}
