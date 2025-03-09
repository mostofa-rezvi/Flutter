import 'dart:convert';
import 'package:flutter_project/model/PrescriptionModel.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;

class PrescriptionService {
  final String baseUrl = APIUrls.prescriptions;

  final http.Client httpClient;

  PrescriptionService({required this.httpClient});

  Future<ApiResponse> getAllPrescriptions() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));
    return _handleResponse(response);
  }

  Future<ApiResponse> createPrescription(PrescriptionModel prescription) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(prescription.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['prescription'];
        PrescriptionModel createdPrescription = PrescriptionModel.fromJson(data);
        return ApiResponse(successful: true, message: 'Report created successfully.', data: createdPrescription);
      } else {
        return ApiResponse(successful: false, message: 'Failed to create report.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<PrescriptionModel> updatePrescription(int id, PrescriptionModel prescription) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(prescription.toJson()),
    );

    if (response.statusCode == 200) {
      return PrescriptionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update prescription');
    }
  }

  Future<void> deletePrescription(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete prescription');
    }
  }


  Future<PrescriptionModel> getPrescriptionById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return PrescriptionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load prescription');
    }
  }

  Future<List<PrescriptionModel>> getPrescriptionsByDoctor(int doctorId) async {
    final response = await http.get(Uri.parse('$baseUrl/doctor/$doctorId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => PrescriptionModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load prescriptions for doctor');
    }
  }

  Future<List<PrescriptionModel>> getPrescriptionsByPatient(int patientId) async {
    final response = await http.get(Uri.parse('$baseUrl/patient/$patientId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => PrescriptionModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load prescriptions for patient');
    }
  }

  Future<List<PrescriptionModel>> getPrescriptionsByDate(DateTime date) async {
    final response = await http.get(Uri.parse('$baseUrl/date?date=${date.toIso8601String()}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => PrescriptionModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load prescriptions for date');
    }
  }

  ApiResponse _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
