import 'dart:convert';
import 'package:flutter_project/model/DiagnosticsModel.dart';
import 'package:http/http.dart' as http;
import '../util/ApiResponse.dart';
import '../util/ApiUrls.dart';

class DiagnosticsService {
  final String baseUrl = APIUrls.diagnostics;

  Future<ApiResponse> getAllDiagnostics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data']['diagnostics'];
        List<DiagnosticsModel> diagnostics =
            data.map((item) => DiagnosticsModel.fromMap(item)).toList();
        return ApiResponse(
            successful: true,
            message: 'Diagnostics fetched successfully.',
            data: diagnostics);
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to fetch diagnostics.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> createDiagnostics(DiagnosticsModel diagnostics) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(diagnostics.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['diagnostics'];
        DiagnosticsModel createdDiagnostics = DiagnosticsModel.fromMap(data);
        return ApiResponse(
            successful: true,
            message: 'Diagnostics created successfully.',
            data: createdDiagnostics);
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to create diagnostics.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> updateDiagnostics(int id, DiagnosticsModel diagnostics) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(diagnostics.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['diagnostics'];
        DiagnosticsModel updatedDiagnostics = DiagnosticsModel.fromMap(data);
        return ApiResponse(
            successful: true,
            message: 'Diagnostics updated successfully.',
            data: updatedDiagnostics);
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to update diagnostics.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> deleteDiagnostics(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
      if (response.statusCode == 200) {
        return ApiResponse(
            successful: true, message: 'Diagnostics deleted successfully.');
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to delete diagnostics.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }


  Future<ApiResponse> getDiagnosticsById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['diagnostics'];
        DiagnosticsModel diagnostics = DiagnosticsModel.fromMap(data);
        return ApiResponse(
            successful: true,
            message: 'Diagnostics fetched successfully.',
            data: diagnostics);
      } else {
        return ApiResponse(
            successful: false, message: 'Diagnostics not found.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> getDiagnosticsByPatientId(int patientId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/patient/$patientId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<DiagnosticsModel> diagnostics =
            data.map((item) => DiagnosticsModel.fromMap(item)).toList();
        return ApiResponse(
            successful: true,
            message: 'Diagnostics fetched successfully.',
            data: diagnostics);
      } else {
        return ApiResponse(
            successful: false,
            message: 'Failed to fetch diagnostics by patient ID.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> getDiagnosticsByDoctorId(int doctorId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/doctor/$doctorId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<DiagnosticsModel> diagnostics =
            data.map((item) => DiagnosticsModel.fromMap(item)).toList();
        return ApiResponse(
            successful: true,
            message: 'Diagnostics fetched successfully.',
            data: diagnostics);
      } else {
        return ApiResponse(
            successful: false,
            message: 'Failed to fetch diagnostics by doctor ID.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }
}
