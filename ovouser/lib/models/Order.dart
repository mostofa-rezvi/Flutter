import 'package:ovouser/models/cartItem.dart';

class Order {
  final int id;
  final String orderCode;
  final String userId;
  final String shopId;
  final double totalAmount;
  final String status;
  final String createdAt;
  final String? address;
  final String? mobile;
  final List<CartItem>
  items;

  Order({
    required this.id,
    required this.orderCode,
    required this.userId,
    required this.shopId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.address,
    this.mobile,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final totalAmount =
        double.tryParse(json['total_amount']?.toString() ?? '0.0') ?? 0.0;

    var itemsJson = json['items'] as List?;
    List<CartItem> orderItemsList =
        itemsJson
            ?.map((i) => CartItem.fromJson(i as Map<String, dynamic>))
            .toList() ??
        [];

    return Order(
      id: int.parse(json['id'].toString()),
      orderCode: json['order_code']?.toString() ?? 'N/A',
      userId: json['user_id']?.toString() ?? 'N/A',
      shopId: json['shop_id']?.toString() ?? 'N/A',
      totalAmount: totalAmount,
      status: json['status']?.toString() ?? 'Unknown',
      createdAt: json['created_at']?.toString() ?? 'N/A',
      address: json['address']?.toString(),
      mobile: json['mobile']?.toString(),
      items: orderItemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_code': orderCode,
      'user_id': userId,
      'shop_id': shopId,
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt,
      'address': address,
      'mobile': mobile,
      'items': items.map((x) => x.toJson()).toList(),
    };
  }
}
