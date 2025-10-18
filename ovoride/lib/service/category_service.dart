import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ovoride/api/api_response.dart';
import 'package:ovoride/api/api_urls.dart';
import '../models/category.dart';

class CategoryService {
  // Generic headers
  Future<Map<String, String>> _headers(String? token) async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }


  // ✅ Get All Categories
  Future<ApiResponse<List<Category>>> getCategories(String? token) async {
    if (token == null) return ApiResponse(error: 'No token found');

    try {
      final response = await http.get(
        Uri.parse(APIUrls.category),
        headers: await _headers(token),
      );

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = jsonResponse['data'];
        final List<dynamic> categoryList =
        (data is Map && data['data'] != null) ? data['data'] : (data is List) ? data : [];
        final categories = categoryList.map((e) => Category.fromJson(e)).toList();
        return ApiResponse(data: categories);
      } else {
        return ApiResponse(error: jsonResponse['message'] ?? 'Failed to load categories');
      }
    } catch (e) {
      return ApiResponse(error: 'Error fetching categories: $e');
    }
  }


  // ✅ Create Category
  Future<ApiResponse<Category>> createCategory(
    String token,
    String name,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(APIUrls.categoryCreate),
        headers: await _headers(token),
        body: jsonEncode({'name': name}),
      );

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(data: Category.fromJson(jsonResponse['data']));
      } else {
        return ApiResponse(
          error: jsonResponse['message'] ?? 'Category creation failed',
        );
      }
    } catch (e) {
      return ApiResponse(error: 'Error creating category: $e');
    }
  }

  // ✅ Update Category
  Future<ApiResponse<Category>> updateCategory(
    String token,
    int id,
    String name,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(APIUrls.categoryUpdateOrDelete.replaceAll('id', '$id')),
        headers: await _headers(token),
        body: jsonEncode({'name': name}),
      );

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiResponse(data: Category.fromJson(jsonResponse['data']));
      } else {
        return ApiResponse(error: jsonResponse['message'] ?? 'Update failed');
      }
    } catch (e) {
      return ApiResponse(error: 'Error updating category: $e');
    }
  }

  // ✅ Delete Category
  Future<ApiResponse<void>> deleteCategory(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse(APIUrls.categoryUpdateOrDelete.replaceAll('id', '$id')),
        headers: await _headers(token),
      );

      if (response.statusCode == 200) {
        return ApiResponse(data: null);
      } else {
        final jsonResponse = jsonDecode(response.body);
        return ApiResponse(error: jsonResponse['message'] ?? 'Delete failed');
      }
    } catch (e) {
      return ApiResponse(error: 'Error deleting category: $e');
    }
  }
}
