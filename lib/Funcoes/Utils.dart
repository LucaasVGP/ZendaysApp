import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<void> saveInfo(String info,String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(info,value);
  }

  static Future<String?> returnInfo(String info) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(info);
    return token;
  }
}