import 'package:ovoride/models/driver.dart';
import 'package:ovoride/models/product.dart';
import 'package:ovoride/models/user.dart';

class OrderListResponse {
  final String message;
  final OrderListData data;

  OrderListResponse({
    required this.message,
    required this.data,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      message: json['message'] ?? '',
      data: OrderListData.fromJson(json['data'] ?? {}),
    );
  }
}

class OrderListData {
  final int currentPage;
  final List<Order> data;

  OrderListData({
    required this.currentPage,
    required this.data,
  });

  factory OrderListData.fromJson(Map<String, dynamic> json) {
    return OrderListData(
      currentPage: json['current_page'] is int
          ? json['current_page']
          : int.tryParse(json['current_page'].toString()) ?? 1,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Order.fromJson(e))
          .toList(),
    );
  }
}

class Order {
  final int id;
  final int? userId;
  final int? driverId;
  final int? shopId;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final Driver? driver;
  final List<Product> products;

  Order({
    required this.id,
    this.userId,
    this.driverId,
    this.shopId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.driver,
    required this.products,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      driverId: _toInt(json['driver_id']),
      shopId: _toInt(json['shop_id']),
      totalAmount: _toDouble(json['total_amount']),
      paymentMethod: json['payment_method']?.toString() ?? 'N/A',
      paymentStatus: json['payment_status']?.toString() ?? 'N/A',
      status: json['status']?.toString() ?? '0',
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      products: (json['products'] as List<dynamic>? ?? [])
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

DateTime _toDate(dynamic value) {
  if (value == null) return DateTime.now();
  try {
    return DateTime.parse(value.toString());
  } catch (_) {
    return DateTime.now();
  }
}