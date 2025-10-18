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
    if (token.isEmpty) return ApiResponse(error: 'No token provided');
    try {
      final response = await http.get(
        Uri.parse(APIUrls.category),
        headers: await _headers(token),
      );
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200) {
        final data = jsonResponse['data'];
        final List<dynamic> list = (data is Map && data['data'] != null)
            ? data['data']
            : (data is List)
            ? data
            : [];
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
      return ApiResponse(error: 'Error fetching categories: $e');
    }
  }

  Future<ApiResponse<Category>> createCategory(
      String token,
      String name,
      ) async {
    if (token.isEmpty) return ApiResponse(error: 'No token provided');
    try {
      final response = await http.post(
        Uri.parse(APIUrls.categoryCreate),
        headers: await _headers(token),
        body: jsonEncode({'name': name}),
      );
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonResponse['data'] ?? jsonResponse;
        return ApiResponse(
          data: Category.fromJson(Map<String, dynamic>.from(data)),
        );
      } else {
        return ApiResponse(
          error: (jsonResponse['message'] is List)
              ? jsonResponse['message'][0]
              : jsonResponse['message'] ?? 'Category creation failed',
        );
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
      final url = APIUrls.categoryUpdateOrDelete.replaceAll('id', '$id');
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
        return ApiResponse(
            error: (jsonResponse['message'] is List)
                ? jsonResponse['message'][0]
                : jsonResponse['message'] ?? 'Update failed');
      }
    } catch (e) {
      return ApiResponse(error: 'Error updating category: $e');
    }
  }

  Future<ApiResponse<void>> deleteCategory(String token, int id) async {
    if (token.isEmpty) return ApiResponse(error: 'No token provided');
    try {
      final url = APIUrls.categoryUpdateOrDelete.replaceAll('id', '$id');
      final response = await http.delete(
        Uri.parse(url),
        headers: await _headers(token),
      );
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse(data: null);
      } else {
        return ApiResponse(error: jsonResponse['message'] ?? 'Delete failed');
      }
    } catch (e) {
      return ApiResponse(error: 'Error deleting category: $e');
    }
  }

  Map<String, dynamic> _safeDecode(String body) {
    try {
      if (body.trim().isEmpty) return {};
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}