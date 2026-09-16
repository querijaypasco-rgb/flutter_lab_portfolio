import 'package:flutter/material.dart';

/// AppStateProvider holds all GLOBAL state for the app.
///
/// Anything placed here (theme mode, user name, etc.) is shared across
/// every screen. Widgets that call `context.watch<AppStateProvider>()`
/// (or are wrapped in a `Consumer`) automatically rebuild the moment
/// any of these values change — that's what makes the Settings screen
/// able to update the Home Dashboard instantly.
class AppStateProvider extends ChangeNotifier {
  String _userName = 'Querijay';
  ThemeMode _themeMode = ThemeMode.light;

  String get userName => _userName;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void updateUserName(String newName) {
    if (newName.trim().isEmpty) return;
    _userName = newName.trim();
    notifyListeners(); // tells every listening widget to rebuild
  }

  void toggleTheme(bool useDark) {
    _themeMode = useDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}