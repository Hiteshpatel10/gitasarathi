import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/services/pref_service.dart';
import 'package:app/core/constants/pref_keys.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    final prefs = ref.watch(prefServiceProvider);
    final savedTheme = prefs.getString(PrefKeys.userTheme);
    if (savedTheme == 'Light') return ThemeMode.light;
    if (savedTheme == 'Dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  Future<void> setTheme(String themeName) async {
    final prefs = ref.read(prefServiceProvider);
    await prefs.setString(PrefKeys.userTheme, themeName);
    if (themeName == 'Light') {
      state = ThemeMode.light;
    } else if (themeName == 'Dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }
}
