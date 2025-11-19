import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  SharedPrefsService(this._prefs);

  final SharedPreferences _prefs;

  static Future<SharedPrefsService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsService(prefs);
  }

  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs.getBool(key) ?? defaultValue;

  Future<void> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  String getString(String key, {String defaultValue = ''}) =>
      _prefs.getString(key) ?? defaultValue;

  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
}
