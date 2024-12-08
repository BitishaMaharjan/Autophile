import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:autophile/themes/dark_mode.dart';
import 'package:autophile/themes/light_mode.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveThemeToStorage(themeData == darkMode ? 'dark' : 'light');
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  Future<void> loadTheme() async {
    String? storedTheme = await _secureStorage.read(key: 'theme');
    print("Loaded theme: $storedTheme");

    if (storedTheme == 'dark') {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
    notifyListeners();
  }

  Future<void> _saveThemeToStorage(String theme) async {
    await _secureStorage.write(key: 'theme', value: theme);
  }
}
