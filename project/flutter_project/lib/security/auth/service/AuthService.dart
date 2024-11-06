import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_project/security/auth/model/UserModel.dart';
import 'package:flutter_project/security/util/ApiResponse.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final String baseUrl = "http://localhost:8080/api/auth";

  UserModel? _currentUser;
  bool _isAuthenticated = false;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  AuthService() {
    _loadStoredUser();
  }

  Future<void> _loadStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('sessionUser');
    final jwt = prefs.getString('jwt');

    if (userData != null && jwt != null) {
      _currentUser = UserModel.fromJson(jsonDecode(userData));
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    final uri = Uri.parse('$baseUrl/login');
    final params = {
      'email': email,
      'password': password,
    };

    final response = await http.post(uri, body: params);

    if (response.statusCode == 200) {
      final apiResponse = ApiResponse.fromJson(jsonDecode(response.body));

      if (apiResponse.successful ?? false) {
        final jwt = apiResponse.data['jwt'];
        final user = UserModel.fromJson(apiResponse.data['user']);

        // Save JWT and user data to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', jwt);
        await prefs.setString('sessionUser', jsonEncode(user.toJson()));

        _currentUser = user;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
    }
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
    return false;
  }

  Role? getRole() {
    return _currentUser?.role;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    await prefs.remove('sessionUser');

    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }

  Future<String?>? getAuthToken() {
    return _isAuthenticated ? _getStoredToken() : null;
  }

  Future<String?> _getStoredToken() {
    final prefs = SharedPreferences.getInstance();
    return prefs.then((prefs) => prefs.getString('jwt'));
  }
}
