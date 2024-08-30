import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const appThemeKey = 'appTheme';
  late ThemeMode currentAppTheme;
  SharedPreferences sharedPreferences;

  ThemeProvider({required this.sharedPreferences}) {
    currentAppTheme = (sharedPreferences.getString(appThemeKey) == null) ||
            (sharedPreferences.getString(appThemeKey)?.toLowerCase() ==
                'system')
        ? ThemeMode.system
        : (sharedPreferences.getString(appThemeKey)?.toLowerCase() == 'light')
            ? ThemeMode.light
            : ThemeMode.dark;
  }

  void changeTheme(String newTheme) {
    currentAppTheme = newTheme.toLowerCase() == 'system'
        ? ThemeMode.system
        : newTheme.toLowerCase() == 'light'
            ? ThemeMode.light
            : ThemeMode.dark;
    notifyListeners();
  }

  bool isDark() {
    return currentAppTheme == ThemeMode.dark;
  }
}
