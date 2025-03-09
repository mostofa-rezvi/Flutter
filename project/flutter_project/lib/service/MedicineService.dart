import 'dart:convert';
import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;

class MedicineService {
  final String baseUrl = APIUrls.medicines;
  final http.Client httpClient;

  MedicineService({required this.httpClient});

  Future<ApiResponse> getAllMedicines() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> addMedicine(MedicineModel medicine) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(medicine.toJson()),
    );
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> updateMedicine(int id, MedicineModel medicine) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(medicine.toJson()),
    );
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> deleteMedicine(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> getMedicineById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> getMedicinesByManufacturer(int manufacturerId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/manufacturer/$manufacturerId'));
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> addStock(int id, int quantity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id/add-stock?quantity=$quantity'),
    );
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> subtractStock(int id, int quantity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id/subtract-stock?quantity=$quantity'),
    );
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> searchMedicinesByName(String name) async {
    final response =
        await http.get(Uri.parse('$baseUrl/searchByName?name=$name'));
    return ApiResponse.fromJson(jsonDecode(response.body));
  }
}
