class Product {
  final int id;
  final String name;
  final String? image;
  final String price;

  Product({
    required this.id,
    required this.name,
    this.image,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? 'Unnamed Product',
      image: json['image']?.toString(),
      price: json['price']?.toString() ?? 'N/A',
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}
