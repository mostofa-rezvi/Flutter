import 'dart:convert';
import 'package:flutter_project/model/ReportModel.dart';
import 'package:http/http.dart' as http;
import '../util/ApiResponse.dart';
import '../util/ApiUrls.dart';

class ReportService {
  final String baseUrl = APIUrls.reports.toString();

  // Fetch all reports
  Future<ApiResponse> getAllReports() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data']['reports'];
        List<ReportModel> reports = data.map((item) => ReportModel.fromMap(item)).toList();
        return ApiResponse(successful: true, message: 'Reports fetched successfully.', data: reports);
      } else {
        return ApiResponse(successful: false, message: 'Failed to fetch reports.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  // Fetch a report by ID
  Future<ApiResponse> getReportById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['report'];
        ReportModel report = ReportModel.fromMap(data);
        return ApiResponse(successful: true, message: 'Report fetched successfully.', data: report);
      } else {
        return ApiResponse(successful: false, message: 'Report not found.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  // Create a new report
  Future<ApiResponse> createReport(ReportModel report) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(report.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['report'];
        ReportModel createdReport = ReportModel.fromMap(data);
        return ApiResponse(successful: true, message: 'Report created successfully.', data: createdReport);
      } else {
        return ApiResponse(successful: false, message: 'Failed to create report.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  // Update an existing report
  Future<ApiResponse> updateReport(int id, ReportModel report) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(report.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['report'];
        ReportModel updatedReport = ReportModel.fromMap(data);
        return ApiResponse(successful: true, message: 'Report updated successfully.', data: updatedReport);
      } else {
        return ApiResponse(successful: false, message: 'Failed to update report.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  // Delete a report
  Future<ApiResponse> deleteReport(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return ApiResponse(successful: true, message: 'Report deleted successfully.');
      } else {
        return ApiResponse(successful: false, message: 'Failed to delete report.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  // Fetch reports by Test ID
  Future<ApiResponse> getReportsByTestId(int testId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/test/$testId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<ReportModel> reports = data.map((item) => ReportModel.fromMap(item)).toList();
        return ApiResponse(successful: true, message: 'Reports fetched successfully.', data: reports);
      } else {
        return ApiResponse(successful: false, message: 'Failed to fetch reports by test ID.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  // Fetch reports by Patient ID
  Future<ApiResponse> getReportsByPatientId(int patientId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/patient/$patientId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<ReportModel> reports = data.map((item) => ReportModel.fromMap(item)).toList();
        return ApiResponse(successful: true, message: 'Reports fetched successfully.', data: reports);
      } else {
        return ApiResponse(successful: false, message: 'Failed to fetch reports by patient ID.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }
}
