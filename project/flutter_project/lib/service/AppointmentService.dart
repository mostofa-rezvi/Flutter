import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/model/AppointmentModel.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  final String baseUrl = APIUrls.appointments;
  final http.Client httpClient;

  AppointmentService({required this.httpClient});

  Future<ApiResponse> getAllAppointments() async {
    final response = await httpClient.get(
        Uri.parse('$baseUrl/all')
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> createAppointment(AppointmentModel appointment) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(appointment.toJson()),
    );
    // return _handleResponse(response);
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create appointment: ${response.statusCode}');
    }
  }

  Future<ApiResponse> updateAppointment(AppointmentModel appointment, int id) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(appointment.toJson()),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> deleteAppointment(int id) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/delete/$id'),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> getAppointmentById(int id) async {
    final response = await httpClient.get(
        Uri.parse('$baseUrl/$id')
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> getAppointmentsByUserId(int userId) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/getAppointmentsByUserId?userId=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> getAppointmentsByDoctorId(int doctorId) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/getAppointmentsByDoctorId?doctorId=$doctorId'),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }


  ApiResponse _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
