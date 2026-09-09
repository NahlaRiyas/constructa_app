import 'package:flutter/material.dart';

/// ============================================================================
/// FILE: app_settings.dart
/// MODULE: Core Utils (App Settings & Theme State Handler)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Provides global state management for application theme (Light, Dark, System).
///   Uses ChangeNotifier to trigger real-time UI rebuilds across MaterialApp.
/// ============================================================================

class AppSettings extends ChangeNotifier {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  ThemeMode _themeMode = ThemeMode.system;
  String _themeName = 'System Default';

  ThemeMode get themeMode => _themeMode;
  String get themeName => _themeName;

  /// Returns whether dark mode is currently active based on explicit theme selection
  /// or system platform brightness.
  bool get isDarkMode {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    return dispatcher.platformBrightness == Brightness.dark;
  }

  /// Sets active app theme mode and notifies global UI listeners.
  void setTheme(String name) {
    _themeName = name;
    switch (name) {
      case 'Light Theme':
      case 'Light':
        _themeMode = ThemeMode.light;
        break;
      case 'Dark Theme':
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System Default':
      default:
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }
}
