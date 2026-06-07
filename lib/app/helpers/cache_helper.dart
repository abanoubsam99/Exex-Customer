import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  final SharedPreferences _prefs;

  CacheHelper(this._prefs);

  dynamic getData(String key) => _prefs.get(key);

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is String) return _prefs.setString(key, value);
    if (value is int) return _prefs.setInt(key, value);
    if (value is bool) return _prefs.setBool(key, value);
    return _prefs.setDouble(key, value as double);
  }

  Future<bool> removeData({required String key}) => _prefs.remove(key);

  Future<bool> clearAllData() => _prefs.clear();
}
