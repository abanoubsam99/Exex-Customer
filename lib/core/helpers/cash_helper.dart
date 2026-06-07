import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static CashHelper get to => Get.find();

  final SharedPreferences _sharedPreferences;

  CashHelper(this._sharedPreferences);

  dynamic getData(String key) {
    return _sharedPreferences.get(key);
  }

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is String) return await _sharedPreferences.setString(key, value);
    if (value is int) return await _sharedPreferences.setInt(key, value);
    if (value is bool) return await _sharedPreferences.setBool(key, value);

    return await _sharedPreferences.setDouble(key, value);
  }

  Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }

  Future<bool> clearAllData() async {
    return await _sharedPreferences.clear();
  }
}
