import 'dart:convert';
import 'package:flutter_project/model/PrescriptionModel.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;// Assuming PrescriptionModel is in prescription_model.dart

class PrescriptionService {
  // Use the APIUrls for the base URL and endpoints
  final String baseUrl = APIUrls.baseURL;

  // Fetch all prescriptions
  Future<List<PrescriptionModel>> getAllPrescriptions() async {
    final response = await http.get(APIUrls.prescriptions);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => PrescriptionModel.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load prescriptions');
    }
  }

  // Fetch a prescription by ID
  Future<PrescriptionModel> getPrescriptionById(int id) async {
    final response = await http.get(Uri.parse('${APIUrls.prescriptions}/$id'));

    if (response.statusCode == 200) {
      return PrescriptionModel.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load prescription');
    }
  }

  // Create a new prescription
  Future<PrescriptionModel> createPrescription(PrescriptionModel prescription) async {
    final response = await http.post(
      APIUrls.prescriptions,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(prescription.toMap()),
    );

    if (response.statusCode == 201) {
      return PrescriptionModel.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to create prescription');
    }
  }

  // Update an existing prescription
  Future<PrescriptionModel> updatePrescription(int id, PrescriptionModel prescription) async {
    final response = await http.put(
      Uri.parse('${APIUrls.prescriptions}/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(prescription.toMap()),
    );

    if (response.statusCode == 200) {
      return PrescriptionModel.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to update prescription');
    }
  }

  // Delete a prescription
  Future<void> deletePrescription(int id) async {
    final response = await http.delete(Uri.parse('${APIUrls.prescriptions}/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete prescription');
    }
  }

  // Get prescriptions by doctor ID
  Future<List<PrescriptionModel>> getPrescriptionsByDoctor(int doctorId) async {
    final response = await http.get(Uri.parse('${APIUrls.prescriptions}/doctor/$doctorId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => PrescriptionModel.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load prescriptions for doctor');
    }
  }

  // Get prescriptions by patient ID
  Future<List<PrescriptionModel>> getPrescriptionsByPatient(int patientId) async {
    final response = await http.get(Uri.parse('${APIUrls.prescriptions}/patient/$patientId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => PrescriptionModel.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load prescriptions for patient');
    }
  }

  // Get prescriptions by date
  Future<List<PrescriptionModel>> getPrescriptionsByDate(DateTime date) async {
    final response = await http.get(Uri.parse('${APIUrls.prescriptions}/date?date=${date.toIso8601String()}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => PrescriptionModel.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load prescriptions for date');
    }
  }
}
