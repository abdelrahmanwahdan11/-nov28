import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/services/shared_prefs_service.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs);

  final SharedPrefsService _prefs;

  static const _primaryKey = 'primary_color_hex';
  static const _darkKey = 'is_dark_mode';

  Color _primaryColor = const Color(0xFF71E5A1);
  bool _isDark = false;

  Color get primaryColor => _primaryColor;
  bool get isDark => _isDark;

  Future<void> load() async {
    final storedColor = _prefs.getString(_primaryKey, defaultValue: '#71E5A1');
    _primaryColor = _colorFromHex(storedColor);
    _isDark = _prefs.getBool(_darkKey, defaultValue: false);
    notifyListeners();
  }

  Future<void> updatePrimary(Color color) async {
    _primaryColor = color;
    await _prefs.setString(_primaryKey, _colorToHex(color));
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDark = value;
    await _prefs.setBool(_darkKey, value);
    notifyListeners();
  }

  static Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String _colorToHex(Color color) => '#'
      '${color.alpha.toRadixString(16).padLeft(2, '0')}'
      '${color.red.toRadixString(16).padLeft(2, '0')}'
      '${color.green.toRadixString(16).padLeft(2, '0')}'
      '${color.blue.toRadixString(16).padLeft(2, '0')}';
}
