import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ovoride/api/api_response.dart';
import 'package:ovoride/api/api_urls.dart';
import '../models/product.dart';

class ProductService {
  // Generic headers
  Future<Map<String, String>> _headers(String? token) async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ✅ Get All Products
  Future<ApiResponse<List<Product>>> getProducts(String? token) async {
    if (token == null) return ApiResponse(error: 'No token found');

    try {
      final response = await http.get(
        Uri.parse(APIUrls.product),
        headers: await _headers(token),
      );

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = jsonResponse['data'];
        final List<dynamic> productList = (data is Map && data['data'] != null)
            ? data['data']
            : (data is List)
            ? data
            : [];
        final products = productList.map((e) => Product.fromJson(e)).toList();
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

  // ✅ Create Product
  Future<ApiResponse<Product>> createProduct(
    String token,
    String name,
    String price,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(APIUrls.productCreate),
        headers: await _headers(token),
        body: jsonEncode({'name': name, 'price': price}),
      );

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(data: Product.fromJson(jsonResponse['data']));
      } else {
        return ApiResponse(
          error: jsonResponse['message'] ?? 'Failed to create product',
        );
      }
    } catch (e) {
      return ApiResponse(error: 'Error creating product: $e');
    }
  }

  // ✅ Update Product
  Future<ApiResponse<Product>> updateProduct(
    String token,
    int id,
    String name,
    String price,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(APIUrls.productUpdateOrDelete.replaceAll('id', '$id')),
        headers: await _headers(token),
        body: jsonEncode({'name': name, 'price': price}),
      );

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiResponse(data: Product.fromJson(jsonResponse['data']));
      } else {
        return ApiResponse(error: jsonResponse['message'] ?? 'Update failed');
      }
    } catch (e) {
      return ApiResponse(error: 'Error updating product: $e');
    }
  }

  // ✅ Delete Product
  Future<ApiResponse<void>> deleteProduct(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse(APIUrls.productUpdateOrDelete.replaceAll('id', '$id')),
        headers: await _headers(token),
      );

      if (response.statusCode == 200) {
        return ApiResponse(data: null);
      } else {
        final jsonResponse = jsonDecode(response.body);
        return ApiResponse(error: jsonResponse['message'] ?? 'Delete failed');
      }
    } catch (e) {
      return ApiResponse(error: 'Error deleting product: $e');
    }
  }
}
