import 'dart:convert';
import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:flutter_project/util/ApiUrls.dart';
import 'package:http/http.dart' as http;

class MedicineService {
  final http.Client httpClient;

  MedicineService({required this.httpClient});

  Future<ApiResponse> getAllMedicines() async {
    final response = await httpClient.get(
        APIUrls.medicines.replace(path: '${APIUrls.medicines.path}/')
    );
    return _processResponse(response);
  }

  Future<ApiResponse> getMedicineById(int id) async {
    final response = await http.get(Uri.parse('$APIUrls/$id'));
    return _processResponse(response);
  }

  Future<ApiResponse> addMedicine(MedicineModel medicine) async {
    final response = await http.post(
      Uri.parse('$APIUrls/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(medicine.toJson()),
    );
    return _processResponse(response);
  }

  Future<ApiResponse> updateMedicine(int id, MedicineModel medicine) async {
    final response = await http.put(
      Uri.parse('$APIUrls/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(medicine.toJson()),
    );
    return _processResponse(response);
  }

  Future<ApiResponse> deleteMedicine(int id) async {
    final response = await http.delete(Uri.parse('$APIUrls/$id'));
    return _processResponse(response);
  }

  Future<ApiResponse> addStock(int id, int quantity) async {
    final response = await http.put(
      Uri.parse('$APIUrls/$id/add-stock?quantity=$quantity'),
    );
    return _processResponse(response);
  }

  Future<ApiResponse> subtractStock(int id, int quantity) async {
    final response = await http.put(
      Uri.parse('$APIUrls/$id/subtract-stock?quantity=$quantity'),
    );
    return _processResponse(response);
  }

  Future<ApiResponse> searchMedicinesByName(String name) async {
    final response = await http.get(Uri.parse('$APIUrls/search?name=$name'));
    return _processResponse(response);
  }

  Future<ApiResponse> getMedicinesByManufacturer(int manufacturerId) async {
    final response = await http.get(Uri.parse('$APIUrls/manufacturer/$manufacturerId'));
    return _processResponse(response);
  }

  ApiResponse _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else {
      return ApiResponse(successful: false, message: 'Error: ${response.statusCode}');
    }
  }
}
