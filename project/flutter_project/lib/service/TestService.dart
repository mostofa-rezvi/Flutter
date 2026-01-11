import 'dart:convert';
import 'package:flutter_project/model/TestModel.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;

class TestService {
  final String baseUrl = APIUrls.tests;
  final http.Client httpClient;

  TestService({required this.httpClient});

  Future<ApiResponse> getAllTests() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data']['tests'];
        List<TestModel> tests = data.map((item) => TestModel.fromJson(item)).toList();
        return ApiResponse(successful: true, message: 'Tests fetched successfully.', data: tests);
      } else {
        return ApiResponse(successful: false, message: 'Failed to fetch tests.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> createTest(TestModel test) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(test.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['tests'];
        TestModel createdTest = TestModel.fromJson(data);
        return ApiResponse(successful: true, message: 'Test created successfully.', data: createdTest);
      } else {
        return ApiResponse(successful: false, message: 'Failed to create test.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> updateTest(int id, TestModel test) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(test.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['tests'];
        TestModel updatedTest = TestModel.fromJson(data);
        return ApiResponse(successful: true, message: 'Test updated successfully.', data: updatedTest);
      } else {
        return ApiResponse(successful: false, message: 'Failed to update test.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> deleteTest(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
      if (response.statusCode == 200) {
        return ApiResponse(successful: true, message: 'Test deleted successfully.');
      } else {
        return ApiResponse(successful: false, message: 'Failed to delete test.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }


  Future<ApiResponse> getTestById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['tests'];
        TestModel test = TestModel.fromJson(data);
        return ApiResponse(successful: true, message: 'Test fetched successfully.', data: test);
      } else {
        return ApiResponse(successful: false, message: 'Test not found.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }
}
