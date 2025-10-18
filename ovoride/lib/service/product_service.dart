import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ovoride/api/api_response.dart';
import 'package:ovoride/api/api_urls.dart';
import '../models/product.dart';
import '../utils/shared_prefs_helper.dart';

class ProductService {
  Future<Map<String, String>> _headers(String token) async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse<List<Product>>> getProducts(String token) async {
    if (token.isEmpty) return ApiResponse(error: 'No token provided');
    try {
      final response = await http.get(
        Uri.parse(APIUrls.product),
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
        final products = list
            .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        return ApiResponse(data: products);
      } else {
        return ApiResponse(
          error: jsonResponse['message'] ?? 'Failed to load products',
        );
      }
    } catch (e) {
      return ApiResponse(error: 'Error fetching products: $e');
    }
  }

  Future<ApiResponse<Product>> createProduct(
      String token,
      String name,
      String price,
      ) async {
    if (token.isEmpty) return ApiResponse(error: 'No token provided');
    try {
      final response = await http.post(
        Uri.parse(APIUrls.productCreate),
        headers: await _headers(token),
        body: jsonEncode({'name': name, 'price': price}),
      );
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonResponse['data'] ?? jsonResponse;
        return ApiResponse(
          data: Product.fromJson(Map<String, dynamic>.from(data)),
        );
      } else {
        return ApiResponse(
          error: (jsonResponse['message'] is List)
              ? jsonResponse['message'][0]
              : jsonResponse['message'] ?? 'Failed to create product',
        );
      }
    } catch (e) {
      return ApiResponse(error: 'Error creating product: $e');
    }
  }

  Future<ApiResponse<Product>> updateProduct(
      String token,
      int id,
      String name,
      String price,
      ) async {
    if (token.isEmpty) return ApiResponse(error: 'No token provided');
    try {
      final url = APIUrls.productUpdateOrDelete.replaceAll('id', '$id');
      final response = await http.put(
        Uri.parse(url),
        headers: await _headers(token),
        body: jsonEncode({'name': name, 'price': price}),
      );
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200) {
        final data = jsonResponse['data'] ?? jsonResponse;
        return ApiResponse(
          data: Product.fromJson(Map<String, dynamic>.from(data)),
        );
      } else {
        return ApiResponse(
            error: (jsonResponse['message'] is List)
                ? jsonResponse['message'][0]
                : jsonResponse['message'] ?? 'Update failed');
      }
    } catch (e) {
      return ApiResponse(error: 'Error updating product: $e');
    }
  }

  Future<ApiResponse<void>> deleteProduct(String token, int id) async {
    if (token.isEmpty) return ApiResponse(error: 'No token provided');
    try {
      final url = APIUrls.productUpdateOrDelete.replaceAll('id', '$id');
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
      return ApiResponse(error: 'Error deleting product: $e');
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