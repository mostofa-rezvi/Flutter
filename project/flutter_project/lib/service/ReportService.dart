import 'dart:convert';
import 'package:flutter_project/model/ReportModel.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;
import '../util/ApiResponse.dart';

class ReportService {
  final String baseUrl = APIUrls.reports;
  final http.Client httpClient;

  ReportService({required this.httpClient});

  Future<ApiResponse> getAllReports() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null && decoded['data']['reports'] != null) {
          List<dynamic> data = decoded['data']['reports'];
          List<ReportModel> reports = data.map((item) => ReportModel.fromJson(item)).toList();
          return ApiResponse(successful: true, message: 'Reports fetched successfully.', data: reports);
        } else {
          return ApiResponse(successful: false, message: 'Invalid response structure.');
        }
      } else {
        return ApiResponse(successful: false, message: 'Failed to fetch reports. HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }


  Future<ApiResponse> createReport(ReportModel report) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(report.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['report'];
        ReportModel createdReport = ReportModel.fromJson(data);
        return ApiResponse(successful: true, message: 'Report created successfully.', data: createdReport);
      } else {
        return ApiResponse(successful: false, message: 'Failed to create report.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> updateReport(int id, ReportModel report) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(report.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['report'];
        ReportModel updatedReport = ReportModel.fromJson(data);
        return ApiResponse(successful: true, message: 'Report updated successfully.', data: updatedReport);
      } else {
        return ApiResponse(successful: false, message: 'Failed to update report.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> deleteReport(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
      if (response.statusCode == 200) {
        return ApiResponse(successful: true, message: 'Report deleted successfully.');
      } else {
        return ApiResponse(successful: false, message: 'Failed to delete report.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }


  Future<ApiResponse> getReportById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['reports'];
        ReportModel report = ReportModel.fromJson(data);
        return ApiResponse(successful: true, message: 'Report fetched successfully.', data: report);
      } else {
        return ApiResponse(successful: false, message: 'Report not found.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> getReportsByTestId(int testId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/test/$testId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<ReportModel> reports = data.map((item) => ReportModel.fromJson(item)).toList();
        return ApiResponse(successful: true, message: 'Reports fetched successfully.', data: reports);
      } else {
        return ApiResponse(successful: false, message: 'Failed to fetch reports by test ID.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> getReportsByPatientId(int patientId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/patient/$patientId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<ReportModel> reports = data.map((item) => ReportModel.fromJson(item)).toList();
        return ApiResponse(successful: true, message: 'Reports fetched successfully.', data: reports);
      } else {
        return ApiResponse(successful: false, message: 'Failed to fetch reports by patient ID.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }
}
