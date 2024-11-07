import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user_model.dart'; // Assuming you have a user model defined
// import '../models/api_response.dart'; // Assuming you have an ApiResponse model

class AuthService {
  final String baseUrl = 'http://localhost:8080/api/auth';

  // Login method
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['data']['jwt'];
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String role = payload['role'];

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('authToken', token);
      await preferences.setString('userRole', role);
      await preferences.setString('sessionUser', jsonEncode(data['data']['user']));

      return true;
    } else {
      print('Failed to log in: ${response.body}');
      return false;
    }
  }

  // Register method
  Future<bool> register(Map<String, dynamic> user) async {
    final url = Uri.parse('$baseUrl/register');
    final header = {'Content-Type': 'application/json'};
    final body = jsonEncode(user);

    final response = await http.post(url, headers: header, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['data']['jwt'];

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('authToken', token);

      return true;
    } else {
      print('Failed to register: ${response.body}');
      return false;
    }
  }

  // Get stored JWT token
  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('authToken');
  }

  // Get stored user role
  Future<String?> getUserRole() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('userRole');
  }

  // Check if token has expired
  Future<bool> isTokenExpired() async {
    String? token = await getToken();

    if (token != null) {
      DateTime expiryDate = Jwt.getExpiryDate(token)!;
      return DateTime.now().isAfter(expiryDate);
    }

    return true;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    String? token = await getToken();

    if (token != null && !(await isTokenExpired())) {
      return true;
    } else {
      await logout();
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('authToken');
    await preferences.remove('userRole');
    await preferences.remove('sessionUser');
  }

  // Check if the user has one of the given roles
  Future<bool> hasRole(List<String> roles) async {
    String? role = await getUserRole();
    return role != null && roles.contains(role);
  }

  // Check if user is an admin
  Future<bool> isAdmin() async {
    return await hasRole(['ADMIN']);
  }

  // Check if user is a doctor
  Future<bool> isDoctor() async {
    return await hasRole(['DOCTOR']);
  }

  // Get the current logged-in user
  // Future<UserModel?> getCurrentUser() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? userJson = preferences.getString('sessionUser');
  //   if (userJson != null) {
  //     return UserModel.fromJson(jsonDecode(userJson));
  //   }
  //   return null;
  // }
}
