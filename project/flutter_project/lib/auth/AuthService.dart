import 'dart:convert';

import 'package:flutter_project/model/UserModel.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/ApiResponse.dart';

class AuthService {
  static const String _jwtKey = 'jwt';
  static const String _userKey = 'sessionUser';

  static Future<ApiResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(APIUrls.login),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'email': email,
        'password': password,
      },
    );
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  static Future<void> initSession(ApiResponse apiResponse) async {
    final jwt = apiResponse.data['jwt'];
    final user = apiResponse.data['user'];

    final sp = await SharedPreferences.getInstance();
    await sp.setString(_jwtKey, jwt);
    await sp.setString(_userKey, jsonEncode(user));
  }

  static Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_jwtKey);
    await sp.remove(_userKey);
  }

  static Future<String?> getAuthToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_jwtKey);
  }

  static Future<UserModel?> getStoredUser() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final userJson = sp.getString(_userKey);
      if (userJson != null) {
        UserModel userModel = UserModel.fromJson(jsonDecode(userJson));
        return userModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_jwtKey) != null;
  }

  static Future<Role?> getRole() async {
    final user = await getStoredUser();
    return user?.role;
  }

}