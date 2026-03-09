import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  static const String themePreferenceKey = 'is_light_theme';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<void> loadSavedTheme() async {
    try {
      final isLightTheme = await _preferences.getBool(themePreferenceKey);
      if (isLightTheme == null) {
        return;
      }

      emit(isLightTheme ? ThemeMode.light : ThemeMode.dark);
    } on PlatformException {
      // Если хранилище недоступно, оставляем светлую тему по умолчанию.
    }
  }

  Future<void> toggleTheme() async {
    final nextThemeMode = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(nextThemeMode);
    await _saveTheme(nextThemeMode);
  }

  Future<void> setLightTheme() async {
    emit(ThemeMode.light);
    await _saveTheme(ThemeMode.light);
  }

  Future<void> setDarkTheme() async {
    emit(ThemeMode.dark);
    await _saveTheme(ThemeMode.dark);
  }

  bool get isLightTheme => state == ThemeMode.light;

  Future<void> _saveTheme(ThemeMode mode) async {
    try {
      await _preferences.setBool(themePreferenceKey, mode == ThemeMode.light);
    } on PlatformException {
      // Если запись не удалась, интерфейс обновляется, но без сохранения.
    }
  }
}
