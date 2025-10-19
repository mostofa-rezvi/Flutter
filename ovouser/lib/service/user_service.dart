import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ovouser/api/api_urls.dart';
import 'package:ovouser/models/Cart.dart';
import 'package:ovouser/models/Order.dart';
import 'package:ovouser/service/auth_service.dart';
import 'package:ovouser/utils/shared_prefs_helper.dart';

class UserService {
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated. Please log in.');
    }
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<Cart?> viewCart() async {
    try {
      final response = await http.get(
        Uri.parse(APIUrls.viewCart),
        headers: await _getAuthHeaders(),
      );

      print(
        'Raw Cart API Response Status: ${response.statusCode}',
      );
      print(
        'Raw Cart API Response Body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['cart'] != null) {
          return Cart.fromJson(data['cart']);
        }
        return Cart(
          items: [],
          totalAmount: 0.0,
        );
      } else if (response.statusCode == 404) {
        print('Cart not found for user (404): ${response.body}');
        return Cart(items: [], totalAmount: 0.0);
      } else {
        print('Failed to view cart: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error viewing cart: $e');
      return null;
    }
  }

  static Future<bool> addToCart(int productId, int quantity, int shopId) async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.post(
        Uri.parse(APIUrls.addToCart),
        headers: headers,
        body: jsonEncode({
          'product_id': productId,
          'quantity': quantity,
          'shop_id': shopId,
        }),
      );

      print('Add to Cart Response Status: ${response.statusCode}');
      print('Add to Cart Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          return true;
        } else {
          print(
            'API reported failure: ${jsonResponse['message'] ?? 'Unknown error'}',
          );
          return false;
        }
      } else if (response.statusCode == 401) {
        print('Unauthorized: Token might be expired or invalid.');
        await SharedPrefsHelper.removeToken();
        await SharedPrefsHelper.removeUserInfo();
        return false;
      } else {
        print(
          'Failed to add to cart with status ${response.statusCode}: ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  static Future<bool> updateCart(int productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse(APIUrls.updateCart),
        headers: await _getAuthHeaders(),
        body: jsonEncode({'product_id': productId, 'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
          'Failed to update cart: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Error updating cart: $e');
      return false;
    }
  }

  static Future<bool> placeOrder({
    required String paymentMethod,
    required String shippingAddress,
  }) async {
    try {
      final url = Uri.parse('${APIUrls.baseURL}order/place-order');
      final headers = await _getAuthHeaders();

      final body = json.encode({
        'payment_method': paymentMethod,
        'shipping_address': shippingAddress,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Order placed successfully: ${response.body}');
        return true;
      } else {
        print(
          'Failed to place order: ${response.statusCode} - ${response.body}',
        );
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] is List
            ? errorBody['message'].join(', ')
            : errorBody['message'];
        throw Exception('API Error: $errorMessage');
      }
    } catch (e) {
      print('Error placing order: $e');
      return false;
    }
  }

  static Future<bool> placeOrderWithAddress({
    required String address,
    required String mobile,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final body = jsonEncode({
        'address': address,
        'mobile': mobile,
      });

      print('Place Order Request Body: $body');
      final response = await http.post(
        Uri.parse(APIUrls.placeOrder),
        headers: headers,
        body: body,
      );

      print('Place Order Response Status: ${response.statusCode}');
      print('Place Order Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          return true;
        } else {
          print(
            'API reported failure placing order: ${jsonResponse['message'] ?? 'Unknown error'}',
          );
          return false;
        }
      } else if (response.statusCode == 401) {
        print(
          'Unauthorized: Token might be expired or invalid during place order.',
        );
        await SharedPrefsHelper.removeToken();
        await SharedPrefsHelper.removeUserInfo();
        return false;
      } else {
        print(
          'Failed to place order with status ${response.statusCode}: ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Error placing order: $e');
      return false;
    }
  }

  static Future<List<Order>> fetchOrderHistory() async {
    try {
      final response = await http.get(
        Uri.parse(APIUrls.orderHistory),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['orders'] is List) {
          final List<dynamic> jsonList = data['data']['orders'];
          return jsonList.map((json) => Order.fromJson(json)).toList();
        }
        return [];
      } else {
        print(
          'Failed to fetch order history: ${response.statusCode} - ${response.body}',
        );
        return [];
      }
    } catch (e) {
      print('Error fetching order history: $e');
      return [];
    }
  }
}
