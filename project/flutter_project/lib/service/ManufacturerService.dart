import 'dart:convert';
import 'package:flutter_project/model/ManufacturerModel.dart';
import 'package:http/http.dart' as http;
import '../util/ApiResponse.dart';
import '../util/ApiUrls.dart';

class ManufacturerService {
  final String baseUrl = APIUrls.manufacturers;

  Future<ApiResponse> getAllManufacturers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data']['manufacturers'];
        List<ManufacturerModel> manufacturers =
            data.map((item) => ManufacturerModel.fromMap(item)).toList();
        return ApiResponse(
            successful: true,
            message: 'Manufacturers fetched successfully.',
            data: manufacturers);
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to fetch manufacturers.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> createManufacturer(ManufacturerModel manufacturer) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(manufacturer.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['manufacturer'];
        ManufacturerModel createdManufacturer = ManufacturerModel.fromMap(data);
        return ApiResponse(
            successful: true,
            message: 'Manufacturer created successfully.',
            data: createdManufacturer);
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to create manufacturer.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> updateManufacturer(int id, ManufacturerModel manufacturer) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(manufacturer.toJson()),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['manufacturer'];
        ManufacturerModel updatedManufacturer = ManufacturerModel.fromMap(data);
        return ApiResponse(
            successful: true,
            message: 'Manufacturer updated successfully.',
            data: updatedManufacturer);
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to update manufacturer.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }

  Future<ApiResponse> deleteManufacturer(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
      if (response.statusCode == 200) {
        return ApiResponse(
            successful: true, message: 'Manufacturer deleted successfully.');
      } else {
        return ApiResponse(
            successful: false, message: 'Failed to delete manufacturer.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }


  Future<ApiResponse> getManufacturerById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data']['manufacturer'];
        ManufacturerModel manufacturer = ManufacturerModel.fromMap(data);
        return ApiResponse(
            successful: true,
            message: 'Manufacturer fetched successfully.',
            data: manufacturer);
      } else {
        return ApiResponse(
            successful: false, message: 'Manufacturer not found.');
      }
    } catch (e) {
      return ApiResponse(successful: false, message: 'Error: $e');
    }
  }
}
