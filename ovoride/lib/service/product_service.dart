import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ovoride/api/api_response.dart';
import 'package:ovoride/api/api_urls.dart';
import '../models/product.dart';
import '../utils/shared_prefs_helper.dart';

String _extractErrorMessage(Map<String, dynamic> jsonResponse) {
  if (jsonResponse['errors'] is Map) {
    final errorsMap = jsonResponse['errors'] as Map;
    if (errorsMap.containsKey('name') &&
        errorsMap['name'] is List &&
        errorsMap['name'].isNotEmpty) {
      return errorsMap['name'].first.toString();
    }
    if (errorsMap.containsKey('price') &&
        errorsMap['price'] is List &&
        errorsMap['price'].isNotEmpty) {
      return errorsMap['price'].first.toString();
    }
    if (errorsMap.isNotEmpty) {
      return errorsMap.values
          .map(
            (e) =>
                e is List && e.isNotEmpty ? e.first.toString() : e.toString(),
          )
          .join(', ');
    }
  }

  if (jsonResponse['message'] is String) {
    return jsonResponse['message'];
  } else if (jsonResponse['message'] is List &&
      jsonResponse['message'].isNotEmpty) {
    return (jsonResponse['message'] as List).first.toString();
  }

  return 'An unknown error occurred.';
}

class ProductService {
  Future<Map<String, String>> _headers(String token) async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse<List<Product>>> getProducts(String token) async {
    if (token.isEmpty) {
      return ApiResponse(error: 'No token provided for getProducts');
    }
    try {
      final response = await http.get(
        Uri.parse(APIUrls.product),
        headers: await _headers(token),
      );
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200) {
        final data = jsonResponse['data'];
        final List<dynamic> list = (data is Map && data['data'] is List)
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
    if (token.isEmpty) {
      return ApiResponse(error: 'No token provided for createProduct');
    }
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
        return ApiResponse(error: _extractErrorMessage(jsonResponse));
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
    if (token.isEmpty) {
      return ApiResponse(error: 'No token provided for updateProduct');
    }
    try {
      final url = APIUrls.productUpdateOrDelete.replaceAll('{id}', '$id');
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
        return ApiResponse(error: _extractErrorMessage(jsonResponse));
      }
    } catch (e) {
      return ApiResponse(error: 'Error updating product: $e');
    }
  }

  Future<ApiResponse<void>> deleteProduct(String token, int id) async {
    if (token.isEmpty) {
      return ApiResponse(error: 'No token provided for deleteProduct');
    }
    try {
      final url = APIUrls.productUpdateOrDelete.replaceAll('{id}', '$id');
      final response = await http.delete(
        Uri.parse(url),
        headers: await _headers(token),
      );
      final jsonResponse = _safeDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse(data: null);
      } else {
        return ApiResponse(error: _extractErrorMessage(jsonResponse));
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
      return {'message': 'Invalid JSON response from server'};
    }
  }
}
