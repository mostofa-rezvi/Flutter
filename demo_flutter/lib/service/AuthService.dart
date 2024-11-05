import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8080';

  Future<bool> login(String email, String password) async {

    final url = Uri.parse('$baseUrl/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String role = payload['role'];

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('authToken', token);
      await preferences.setString('userRole', role);

      return true;
    }
    else {
      print('Failed to log in: ${response.body}');
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> user) async {
    final url = Uri.parse('$baseUrl/register');
    final header = {'Content-Type': 'application/json'};
    final body = jsonEncode(user);

    final response = await http.post(url, headers: header, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('authToken', token);

      return true;
    }
    else {
      print('Failed to register: ${response.body}');
      return false;
    }
  }

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('authToken');
  }

  Future<String?> getUserRole() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString('userRole'));
    return preferences.getString('userRole');
  }

  Future<bool> isTokenExpired() async {
    String? token = await getToken();

    if (token != null) {
      DateTime expiryDate = Jwt.getExpiryDate(token)!;
      return DateTime.now().isAfter(expiryDate);
    }

    return true;
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken();

    if (token != null && !(await isTokenExpired())) {
      return true;
    }
    else {
      await logout();
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('authToken');
    await preferences.remove('userRole');
  }

  Future<bool> hasRole(List<String> roles) async {
    String? role = await getUserRole();
    return role!= null && roles.contains(role);
  }

  Future<bool> isAdmin() async {
    return await hasRole(['ADMIN']);
  }

  Future<bool> isHotel() async {
    return await hasRole(['HOTEL']);
  }

  Future<bool> isUser() async {
    return await hasRole(['USER']);
  }
}