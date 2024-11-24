import 'dart:convert';
import 'package:flutter_project/model/BillModel.dart';
import 'package:http/http.dart' as http;
import '../util/ApiResponse.dart';
import '../util/ApiUrls.dart';

class BillService {
  final String baseUrl = APIUrls.bills;
  final http.Client httpClient;

  BillService({required this.httpClient});

  Future<ApiResponse> getAllBills() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data']['bills'];
        List<BillModel> bills = data.map((item) => BillModel.fromJson(item)).toList();
        return ApiResponse(
            successful: true,
            message: 'Bills fetched successfully.',
            data: bills);
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to fetch bills.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> createBill(BillModel bill) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bill.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['bills'];
        BillModel createdBill = BillModel.fromJson(data);
        return ApiResponse(
            successful: true,
            message: 'Bill created successfully.',
            data: createdBill);
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to create bill.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> updateBill(int id, BillModel bill) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bill.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['bills'];
        BillModel updatedBill = BillModel.fromJson(data);
        return ApiResponse(
            successful: true,
            message: 'Bill updated successfully.',
            data: updatedBill);
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to update bill.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> deleteBill(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
      if (response.statusCode == 200) {
        return ApiResponse(
            successful: true, message: 'Bill deleted successfully.');
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to delete bill.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }


  Future<ApiResponse> getBillById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['bills'];
        BillModel bill = BillModel.fromJson(data);
        return ApiResponse(
            successful: true,
            message: 'Bill fetched successfully.',
            data: bill);
      } else {
        return ApiResponse(successful: false, message: 'Bill not found.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> getBillsByPatientId(int patientId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/getBillsByPatientId?patientId=$patientId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BillModel> bills =
            data.map((item) => BillModel.fromJson(item)).toList();
        return ApiResponse(
            successful: true,
            message: 'Bills fetched successfully.',
            data: bills);
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to fetch bills by patient ID.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> getBillsByDoctorId(int doctorId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/getBillsByDoctorId?doctorId=$doctorId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BillModel> bills =
            data.map((item) => BillModel.fromJson(item)).toList();
        return ApiResponse(
            successful: true,
            message: 'Bills fetched successfully.',
            data: bills);
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to fetch bills by doctor ID.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> getBillsByPharmacistId(int pharmacistId) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/getBillsByPharmacistId?pharmacistId=$pharmacistId'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BillModel> bills =
            data.map((item) => BillModel.fromJson(item)).toList();
        return ApiResponse(
            successful: true,
            message: 'Bills fetched successfully.',
            data: bills);
      } else {
        return ApiResponse(
            successful: false,
            message: 'Failed to fetch bills by pharmacist ID.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }
}
