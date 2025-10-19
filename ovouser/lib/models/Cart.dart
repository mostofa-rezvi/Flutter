import 'package:ovouser/models/CartItem.dart';

class Cart {
  final int? id;
  final String? userId;
  final String? shopId;
  final double totalAmount;
  final String? status;
  final List<CartItem> items;

  Cart({
    this.id,
    this.userId,
    this.shopId,
    required this.totalAmount,
    this.status,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    final totalAmount =
        double.tryParse(json['total_amount']?.toString() ?? '0.0') ?? 0.0;

    var itemsJson = json['items'] as List?;
    List<CartItem> cartItemsList =
        itemsJson
            ?.map((i) => CartItem.fromJson(i as Map<String, dynamic>))
            .toList() ??
        [];

    return Cart(
      id: json['id'] as int?,
      userId: json['user_id']?.toString(),
      shopId: json['shop_id']?.toString(),
      totalAmount: totalAmount,
      status: json['status']?.toString(),
      items: cartItemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'shop_id': shopId,
      'total_amount': totalAmount,
      'status': status,
      'items': items.map((x) => x.toJson()).toList(),
    };
  }
}
