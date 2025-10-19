class CartItem {
  final int id;
  final int productId;
  final String productName;
  final double price;
  int quantity;
  final String imageUrl;
  final int shopId;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.shopId,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>?;

    final defaultProductName = 'Unknown Product';
    final defaultPrice = 0.0;
    final defaultShopId = 0;

    return CartItem(
      id: int.parse(json['id'].toString()),
      productId: int.parse(json['product_id'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      productName: productJson?['name']?.toString() ?? defaultProductName,
      price: double.tryParse(productJson?['price']?.toString() ?? '0.0') ?? defaultPrice,
      imageUrl: productJson?['image_url']?.toString() ?? '',
      shopId: int.tryParse(productJson?['shop_id']?.toString() ?? '0') ?? defaultShopId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'product_name': productName,
      'price': price,
      'image_url': imageUrl,
      'shop_id': shopId,
    };
  }
}
