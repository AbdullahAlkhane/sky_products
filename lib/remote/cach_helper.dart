import 'package:shared_preferences/shared_preferences.dart';

class CachHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
  /// كود ال set data  فى ال sharedPreferences
  static Future<bool> saveDataa({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    return await sharedPreferences!.setDouble(key, value);
  }
  /// كود ال get data  فى ال sharedPreferences
  static dynamic getData(String key) {
    return sharedPreferences!.get(key);
  }
  /// كود ال remove data  فى ال sharedPreferences
  static Future<bool> removeData(String key) async {
    return await sharedPreferences!.remove(key);
  }
}