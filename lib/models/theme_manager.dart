import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static final ValueNotifier<ThemeMode> themeMode =
  ValueNotifier(ThemeMode.system);

  static const _key = "theme_mode";

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);

    switch (value) {
      case "light":
        themeMode.value = ThemeMode.light;
        break;
      case "dark":
        themeMode.value = ThemeMode.dark;
        break;
      default:
        themeMode.value = ThemeMode.system;
    }
  }

  static Future<void> setTheme(ThemeMode mode) async {
    themeMode.value = mode;

    final prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.light) {
      prefs.setString(_key, "light");
    } else if (mode == ThemeMode.dark) {
      prefs.setString(_key, "dark");
    } else {
      prefs.setString(_key, "system");
    }
  }
}
