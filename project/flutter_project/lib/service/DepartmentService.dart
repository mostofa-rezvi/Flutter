import 'dart:convert';
import 'package:flutter_project/model/DepartmentModel.dart';
import 'package:http/http.dart' as http;
import '../util/ApiResponse.dart';
import '../util/ApiUrls.dart';

class DepartmentService {
  final String baseUrl = APIUrls.departments;

  Future<ApiResponse> getAllDepartments() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data']['departments'];
        List<DepartmentModel> departments =
        data.map((item) => DepartmentModel.fromMap(item)).toList();
        return ApiResponse(successful: true, message: 'Departments fetched successfully.', data: departments);
      } else {
        return ApiResponse(successful: false, message: 'Failed to fetch departments.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> createDepartment(DepartmentModel department) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(department.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['department'];
        DepartmentModel createdDepartment = DepartmentModel.fromMap(data);
        return ApiResponse(successful: true, message: 'Department created successfully.', data: createdDepartment);
      } else {
        return ApiResponse(successful: false, message: 'Failed to create department.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> updateDepartment(int id, DepartmentModel department) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(department.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['department'];
        DepartmentModel updatedDepartment = DepartmentModel.fromMap(data);
        return ApiResponse(successful: true, message: 'Department updated successfully.', data: updatedDepartment);
      } else {
        return ApiResponse(successful: false, message: 'Failed to update department.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> deleteDepartment(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
      if (response.statusCode == 200) {
        return ApiResponse(successful: true, message: 'Department deleted successfully.');
      } else {
        return ApiResponse(successful: false, message: 'Failed to delete department.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }


  Future<ApiResponse> getDepartmentById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['department'];
        DepartmentModel department = DepartmentModel.fromMap(data);
        return ApiResponse(successful: true, message: 'Department fetched successfully.', data: department);
      } else {
        return ApiResponse(successful: false, message: 'Department not found.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> getDepartmentByName(String departmentName) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/searchByName?name=$departmentName'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['department'];
        DepartmentModel department = DepartmentModel.fromMap(data);
        return ApiResponse(successful: true, message: 'Department fetched successfully.', data: department);
      } else {
        return ApiResponse(successful: false, message: 'Department not found.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }
}
