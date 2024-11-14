import 'dart:convert';
import 'package:flutter_project/model/TestModel.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;

class TestService {
  final String baseUrl = APIUrls.tests.toString();

  Future<ApiResponse> getAllTests() async {
    final response = await http.get(Uri.parse(baseUrl));
    return _processResponse(response);
  }

  Future<ApiResponse> getTestById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    return _processResponse(response);
  }

  Future<ApiResponse> createTest(TestModel test) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(test.toJson()),
    );
    return _processResponse(response);
  }

  Future<ApiResponse> updateTest(int id, TestModel test) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(test.toJson()),
    );
    return _processResponse(response);
  }

  Future<ApiResponse> deleteTest(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return _processResponse(response);
  }

  ApiResponse _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      // Handle other status codes or error response
      return ApiResponse(successful: false, message: 'Error: ${response.statusCode}');
    }
  }
}
