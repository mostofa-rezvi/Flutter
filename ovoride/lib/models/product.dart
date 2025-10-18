class Product {
  final int id;
  final String name;
  final String? image;
  final String price;

  Product({
    required this.id,
    required this.name,
    this.image,
    required this.price
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? 'Unnamed Product',
      image: json['image'],
      price: json['price']?.toString() ?? 'N/A',
    );
  }
}