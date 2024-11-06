import 'dart:async';
import 'dart:convert';
import 'package:flutter_project/security/auth/service/AuthService.dart';
import 'package:http/http.dart' as http;

class AuthInterceptor {
  final AuthService _authService;

  AuthInterceptor(this._authService);

  Future<http.Response> get(Uri url) async {
    final token = await _authService.getAuthToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    return http.get(url, headers: headers);
  }

  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) async {
    final token = await _authService.getAuthToken();
    final finalHeaders = {
      'Authorization': 'Bearer $token',
      ...?headers,
    };
    return http.post(url, headers: finalHeaders, body: body);
  }

// Add similar methods for put, delete, etc., if needed
}
