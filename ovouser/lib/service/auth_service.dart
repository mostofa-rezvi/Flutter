import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_response.dart';
import '../api/api_urls.dart';
import '../models/user.dart';
import '../utils/shared_prefs_helper.dart';

class AuthService {
  static Future<String?> getUserToken() async {
    return await SharedPrefsHelper.getToken();
  }

  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(APIUrls.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': email,
          'password': password,
        }),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
        final userData = jsonResponse['data'];
        final user = User.fromJson(userData);
        await SharedPrefsHelper.saveToken(user.token!);
        await SharedPrefsHelper.saveUserInfo(user.firstname, user.email);
        return ApiResponse(data: user);
      } else {
        return ApiResponse(
          error: (jsonResponse['message'] is List)
              ? jsonResponse['message'][0]
              : jsonResponse['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      return ApiResponse(error: 'An unexpected error occurred: $e');
    }
  }

  Future<ApiResponse<User>> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse(APIUrls.register),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final userData = jsonResponse['data'];
        final registeredUser = User.fromJson(userData);
        await SharedPrefsHelper.saveToken(registeredUser.token!);
        await SharedPrefsHelper.saveUserInfo(
          registeredUser.firstname,
          registeredUser.email,
        );
        return ApiResponse(data: registeredUser);
      } else {
        Map<String, dynamic>? errors = jsonResponse['errors'];
        String errorMessage = jsonResponse['message'] ?? 'Registration failed';
        if (errors != null) {
          errors.forEach((key, value) {
            errorMessage +=
                '\n${value[0]}';
          });
        }
        return ApiResponse(error: errorMessage);
      }
    } catch (e) {
      return ApiResponse(error: 'An unexpected error occurred: $e');
    }
  }
}
