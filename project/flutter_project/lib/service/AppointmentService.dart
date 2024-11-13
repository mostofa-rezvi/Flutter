import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/model/AppointmentModel.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  final http.Client httpClient;

  AppointmentService({required this.httpClient});

  Future<ApiResponse> createAppointment(AppointmentModel appointment) async {
    final response = await httpClient.post(
      APIUrls.appointments.replace(path: '${APIUrls.appointments.path}/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(appointment.toJson()),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> getAllAppointments() async {
    final response = await httpClient.get(APIUrls.appointments);
    return _handleResponse(response);
  }

  Future<ApiResponse> getAppointmentById(int id) async {
    final response = await httpClient.get(
      APIUrls.appointments.replace(path: '${APIUrls.appointments.path}/$id'),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> updateAppointment(AppointmentModel appointment) async {
    final response = await httpClient.put(
      APIUrls.appointments.replace(path: '${APIUrls.appointments.path}/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(appointment.toJson()),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> deleteAppointment(int id) async {
    final response = await httpClient.delete(
      APIUrls.appointments.replace(path: '${APIUrls.appointments.path}/$id'),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> getAppointmentsByUserId(int userId) async {
    final response = await httpClient.get(
      APIUrls.appointments.replace(
        path: '${APIUrls.appointments.path}/getAppointmentsByUserId',
        queryParameters: {'userId': userId.toString()},
      ),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> getAppointmentsByDoctorId(int doctorId) async {
    final response = await httpClient.get(
      APIUrls.appointments.replace(
        path: '${APIUrls.appointments.path}/getAppointmentsByDoctorId',
        queryParameters: {'doctorId': doctorId.toString()},
      ),
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
