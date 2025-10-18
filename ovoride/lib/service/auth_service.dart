import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_response.dart';
import '../api/api_urls.dart';
import '../models/user.dart';

class AuthService {
  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(APIUrls.login),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'username': email, 'password': password}),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
        final userData = jsonResponse['data'];
        return ApiResponse(data: User.fromJson(userData));
      } else {
        return ApiResponse(
            error: (jsonResponse['message'] is List)
                ? jsonResponse['message'][0]
                : jsonResponse['message'] ?? 'Login failed');
      }
    } catch (e) {
      return ApiResponse(error: 'An unexpected error occurred: $e');
    }
  }

  Future<ApiResponse<User>> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse(APIUrls.register),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final userData = jsonResponse['data'];
        return ApiResponse(data: User.fromJson(userData));
      } else {
        return ApiResponse(
            error: (jsonResponse['message'] is List)
                ? jsonResponse['message'][0]
                : jsonResponse['message'] ?? 'Registration failed');
      }
    } catch (e) {
      return ApiResponse(error: 'An unexpected error occurred: $e');
    }
  }
}

