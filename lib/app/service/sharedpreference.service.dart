import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? prefs;

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future setLocalStorage(String key, String value) async{
    await prefs?.setString(key, value);
  }

  static Future<String> getLocalStorage(String key) async{
    String? data = prefs?.getString(key);
    return data ?? '';
  }

}