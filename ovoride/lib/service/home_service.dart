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

  Future<ApiResponse<DashboardData>> getDashboardData(String token) async {
    try {
      final response = await _makeAuthenticatedGetRequest(APIUrls.dashboard, token);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse(data: DashboardData.fromJson(jsonResponse['data']));
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
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final productsJson = jsonResponse['data']['data'] as List;
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
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final categoriesJson = jsonResponse['data']['data'] as List;
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
