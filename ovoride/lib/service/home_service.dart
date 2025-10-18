import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/dashboard.dart';
import '../models/product.dart';
import '../api/api_response.dart';
import '../api/api_urls.dart';

class HomeService {
  Future<http.Response> _makeAuthenticatedGetRequest(String url, String token) async {
    return await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Map<String, dynamic> _safeDecode(String body) {
    try {
      if (body.trim().isEmpty) return {};
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<ApiResponse<DashboardData>> getDashboardData(String token) async {
    try {
      final response = await _makeAuthenticatedGetRequest(APIUrls.dashboard, token);
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200) {
        final data = jsonResponse['data'];
        if (data != null) {
          return ApiResponse(data: DashboardData.fromJson(data));
        } else {
          return ApiResponse(error: 'Dashboard data is null');
        }
      } else {
        return ApiResponse(error: jsonResponse['message'] ?? 'Failed to load dashboard data');
      }
    } catch (e) {
      return ApiResponse(error: 'An unexpected error occurred: $e');
    }
  }

  Future<ApiResponse<List<Product>>> getProducts(String token) async {
    try {
      final response = await _makeAuthenticatedGetRequest(APIUrls.product, token);
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200) {
        final data = jsonResponse['data'];
        final List<dynamic> productsJson = (data is Map && data['data'] is List)
            ? data['data']
            : [];
        final products = productsJson.map((p) => Product.fromJson(p)).toList();
        return ApiResponse(data: products);
      } else {
        return ApiResponse(error: jsonResponse['message'] ?? 'Failed to load products');
      }
    } catch (e) {
      return ApiResponse(error: 'An unexpected error occurred: $e');
    }
  }

  Future<ApiResponse<List<Category>>> getCategories(String token) async {
    try {
      final response = await _makeAuthenticatedGetRequest(APIUrls.category, token);
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200) {
        final data = jsonResponse['data'];
        final List<dynamic> categoriesJson = (data is Map && data['data'] is List)
            ? data['data']
            : [];
        final categories = categoriesJson.map((c) => Category.fromJson(c)).toList();
        return ApiResponse(data: categories);
      } else {
        return ApiResponse(error: jsonResponse['message'] ?? 'Failed to load categories');
      }
    } catch (e) {
      return ApiResponse(error: 'An unexpected error occurred: $e');
    }
  }
}