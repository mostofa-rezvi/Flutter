import 'dart:convert';
import 'package:flutter_project/model/UserModel.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;

class UserService {

  final String baseUrl = APIUrls.user.toString();

  Future<List<UserModel>> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/findAllUsers'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data']['users'];
      return data.map((user) => UserModel.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  Future<List<UserModel>> getUsersByRole(String role) async {
    final response = await http.get(Uri.parse('$baseUrl/users/role/$role'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data']['users'];
      return data.map((user) => UserModel.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users by role: ${response.body}');
    }
  }

  Future<UserModel> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body)['data']['user'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to load user: ${response.body}');
    }
  }

  Future<UserModel> createUser(UserModel user, String avatarPath) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/users'));
    request.fields.addAll(user.toJson().map((key, value) => MapEntry(key, value.toString())));

    if (avatarPath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('avatar', avatarPath));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(resBody)['data']['user'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<UserModel> updateUser(UserModel user, String avatarPath) async {
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/users'));
    request.fields.addAll(user.toJson().map((key, value) => MapEntry(key, value.toString())));

    if (avatarPath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('avatar', avatarPath));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(resBody)['data']['user'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<bool> deleteUserById(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete user: ${response.body}');
    }
  }
}
