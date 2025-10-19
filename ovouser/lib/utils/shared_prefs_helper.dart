import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _authTokenKey = 'authToken';
  static const String _userNameKey = 'userName';
  static const String _userEmailKey = 'userEmail';
  static const String _userMobileKey = 'userMobile';
  static const String _userAddressKey = 'userAddress';

  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await _instance;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await _instance;
    await prefs.setString(_authTokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await _instance;
    return prefs.getString(_authTokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await _instance;
    await prefs.remove(_authTokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await _instance;
    return prefs.containsKey(_authTokenKey) &&
        prefs.getString(_authTokenKey) != null;
  }

  static Future<void> saveUserInfo(String? name, String? email) async {
    final prefs = await _instance;
    if (name != null) await prefs.setString(_userNameKey, name);
    if (email != null) await prefs.setString(_userEmailKey, email);
  }

  static Future<String?> getUserName() async {
    final prefs = await _instance;
    return prefs.getString(_userNameKey);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await _instance;
    return prefs.getString(_userEmailKey);
  }

  static Future<void> removeUserInfo() async {
    final prefs = await _instance;
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userMobileKey);
    await prefs.remove(_userAddressKey);
  }

  static Future<void> saveUserMobile(String mobile) async {
    final prefs = await _instance;
    await prefs.setString(_userMobileKey, mobile);
  }

  static Future<String?> getUserMobile() async {
    final prefs = await _instance;
    return prefs.getString(_userMobileKey);
  }

  static Future<void> saveUserAddress(String address) async {
    final prefs = await _instance;
    await prefs.setString(_userAddressKey, address);
  }

  static Future<String?> getUserAddress() async {
    final prefs = await _instance;
    return prefs.getString(_userAddressKey);
  }
}
