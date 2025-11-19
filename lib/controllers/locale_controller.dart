import 'package:flutter/material.dart';

import '../core/services/shared_prefs_service.dart';

class LocaleController extends ChangeNotifier {
  LocaleController(this._prefs);

  final SharedPrefsService _prefs;
  static const _localeKey = 'selected_locale';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> load() async {
    final saved = _prefs.getString(_localeKey, defaultValue: 'en');
    _locale = Locale(saved);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }
}
