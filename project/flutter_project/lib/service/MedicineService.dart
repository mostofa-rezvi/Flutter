import 'dart:convert';
import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;

class MedicineService {
  final String apiUrl = APIUrls.medicines.toString();

  Future<ApiResponse> getAllMedicines() async {
    final response = await http.get(Uri.parse('$apiUrl/'));
    return _processResponse(response);
  }

  Future<ApiResponse> getMedicineById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    return _processResponse(response);
  }

  Future<ApiResponse> addMedicine(MedicineModel medicine) async {
    final response = await http.post(
      Uri.parse('$apiUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(medicine.toJson()),
    );
    return _processResponse(response);
  }

  Future<ApiResponse> updateMedicine(int id, MedicineModel medicine) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(medicine.toJson()),
    );
    return _processResponse(response);
  }

  Future<ApiResponse> deleteMedicine(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    return _processResponse(response);
  }

  Future<ApiResponse> addStock(int id, int quantity) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id/add-stock?quantity=$quantity'),
    );
    return _processResponse(response);
  }

  Future<ApiResponse> subtractStock(int id, int quantity) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id/subtract-stock?quantity=$quantity'),
    );
    return _processResponse(response);
  }

  Future<ApiResponse> searchMedicinesByName(String name) async {
    final response = await http.get(Uri.parse('$apiUrl/search?name=$name'));
    return _processResponse(response);
  }

  Future<ApiResponse> getMedicinesByManufacturer(int manufacturerId) async {
    final response = await http.get(Uri.parse('$apiUrl/manufacturer/$manufacturerId'));
    return _processResponse(response);
  }

  ApiResponse _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      // Handle other status codes or error response
      return ApiResponse(successful: false, message: 'Error: ${response.statusCode}');
    }
  }
}
