import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static SharedPreferences? _sharedPref;
  static const String _initialLogin = "initialLogin";
  static const String _accessToken = "accessToken";
  static const String _refreshToken = "refreshToken";
  static const String _userName = "userName";

  /// Initialize SharedPreferences (Ensure this is called in `main.dart`)
  static Future<void> init() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  /// Clears all stored preferences
  static Future<void> clearPreferences() async {
    await _sharedPref?.clear();
  }

  /// Saves initial login status
  static Future<void> saveInitialLogin() async {
    await _sharedPref?.setBool(_initialLogin, true);
  }

  /// Retrieves initial login status (defaults to `false`)
  static bool getInitialLogin() {
    return _sharedPref?.getBool(_initialLogin) ?? false;
  }

  /// Saves Access Token
  static Future<void> saveAccessToken(String value) async {
    await _sharedPref?.setString(_accessToken, value);
  }

  /// Retrieves Access Token
  static String? getAccessToken() {
    return _sharedPref?.getString(_accessToken);
  }

  /// Saves Refresh Token
  static Future<void> saveRefreshToken(String value) async {
    await _sharedPref?.setString(_refreshToken, value);
  }

  /// Retrieves Refresh Token
  static String? getRefreshToken() {
    return _sharedPref?.getString(_refreshToken);
  }
  /// Saves Refresh Token
  static Future<void> saveUserName(String value) async {
    await _sharedPref?.setString(_userName, value);
  }

  /// Retrieves Refresh Token
  static String? getUserName() {
    return _sharedPref?.getString(_userName);
  }
}
