import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ovoride/api/api_response.dart';
import 'package:ovoride/api/api_urls.dart';
import '../models/category.dart';
import '../utils/shared_prefs_helper.dart';

class CategoryService {
  Future<Map<String, String>> _headers(String token) async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse<List<Category>>> getCategories(String token) async {
    if (token.isEmpty) {
      return ApiResponse(error: 'No token provided for getCategories');
    }
    try {
      final response = await http.get(
        Uri.parse(APIUrls.category),
        headers: await _headers(token),
      );
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200) {
        // Ensure 'data' exists and is a Map or List
        final dynamic responseData = jsonResponse['data'];

        if (responseData == null) {
          return ApiResponse(error: 'No data found in categories response');
        }

        List<dynamic> list;
        if (responseData is Map && responseData['data'] is List) {
          // Case: { "data": { "data": [...] } } - common in Laravel pagination
          list = responseData['data'] as List<dynamic>;
        } else if (responseData is List) {
          // Case: { "data": [...] }
          list = responseData;
        } else {
          // Unexpected data structure
          return ApiResponse(error: 'Unexpected data format for categories');
        }

        final categories = list
            .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        return ApiResponse(data: categories);
      } else {
        return ApiResponse(
          error: jsonResponse['message'] ?? 'Failed to load categories',
        );
      }
    } catch (e) {
      // It's good practice to log the full error for debugging
      print('Error fetching categories: $e');
      return ApiResponse(error: 'Error fetching categories: $e');
    }
  }

  Future<ApiResponse<Category>> createCategory(
    String token,
    String name,
  ) async {
    if (token.isEmpty) {
      return ApiResponse(error: 'No token provided for createCategory');
    }
    try {
      final response = await http.post(
        Uri.parse(APIUrls.categoryCreate),
        headers: await _headers(token),
        body: jsonEncode({'name': name}),
      );
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data =
            jsonResponse['data'] ??
            jsonResponse;
        return ApiResponse(
          data: Category.fromJson(Map<String, dynamic>.from(data)),
        );
      } else {
        // Provide more specific error message from backend if available
        final errorMessage = (jsonResponse['errors'] is Map)
            ? (jsonResponse['errors']['name']?.first ?? jsonResponse['message'])
            : jsonResponse['message'];
        return ApiResponse(error: errorMessage ?? 'Category creation failed');
      }
    } catch (e) {
      return ApiResponse(error: 'Error creating category: $e');
    }
  }

  Future<ApiResponse<Category>> updateCategory(
    String token,
    int id,
    String name,
  ) async {
    if (token.isEmpty) return ApiResponse(error: 'No token provided');

    try {
      final url = APIUrls.categoryUpdateOrDelete.replaceAll('{id}', '$id');
      final response = await http.put(
        Uri.parse(url),
        headers: await _headers(token),
        body: jsonEncode({'name': name}),
      );

      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200) {
        final data = jsonResponse['data'] ?? jsonResponse;
        return ApiResponse(
          data: Category.fromJson(Map<String, dynamic>.from(data)),
        );
      } else {
        final errorMessage = (jsonResponse['errors'] is Map)
            ? (jsonResponse['errors']['name']?.first ?? jsonResponse['message'])
            : jsonResponse['message'];
        return ApiResponse(error: errorMessage ?? 'Update failed');
      }
    } catch (e) {
      return ApiResponse(error: 'Error updating category: $e');
    }
  }

  Future<ApiResponse<void>> deleteCategory(String token, int id) async {
    if (token.isEmpty) return ApiResponse(error: 'No token provided');

    try {
      final url = APIUrls.categoryUpdateOrDelete.replaceAll('{id}', '$id');
      final response = await http.delete(
        Uri.parse(url),
        headers: await _headers(token),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse(data: null);
      } else {
        final jsonResponse = _safeDecode(response.body);
        String? errorMessage;

        // Check if 'message' is a List (e.g., ["message 1", "message 2"])
        if (jsonResponse['message'] is List) {
          errorMessage = (jsonResponse['message'] as List).join(
            ', ',
          ); // Join list elements into a single string
        } else {
          errorMessage =
              jsonResponse['message']; // Assume it's already a String or null
        }

        return ApiResponse(error: errorMessage ?? 'Delete failed');
      }
    } catch (e) {
      print('Error deleting category: $e'); // Log the error
      return ApiResponse(error: 'Error deleting category: $e');
    }
  }

  Map<String, dynamic> _safeDecode(String body) {
    try {
      if (body.trim().isEmpty) return {};
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {'message': 'Invalid JSON response from server'};
    }
  }
}
