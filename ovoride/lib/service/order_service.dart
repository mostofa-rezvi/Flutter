import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ovoride/api/api_response.dart';
import 'package:ovoride/api/api_urls.dart';
import '../models/order_model.dart';

class OrderService {
  Future<Map<String, String>> _headers(String token) async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _safeDecode(String body) {
    try {
      if (body.trim().isEmpty) return {};
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {'message': 'Invalid JSON response from server'};
    }
  }

  Future<ApiResponse<List<Order>>> getOrders(String token) async {
    if (token.isEmpty) {
      return ApiResponse(error: 'No token provided for getOrders');
    }
    try {
      final response = await http.get(
        Uri.parse(APIUrls.orders),
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

        final orders = list
            .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        return ApiResponse(data: orders);
      } else {
        return ApiResponse(
          error: jsonResponse['message'] ?? 'Failed to load orders',
        );
      }
    } catch (e) {
      return ApiResponse(error: 'Error fetching orders: $e');
    }
  }
}
