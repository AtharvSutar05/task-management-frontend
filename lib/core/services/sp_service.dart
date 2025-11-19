import 'package:frontend/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpService {

  Future<void> setToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(AppConstants.tokenKey, token);
  }

  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(AppConstants.tokenKey);
  }

}
