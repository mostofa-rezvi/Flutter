class ShopProductModel {
  final int id;
  final String shopName;
  final String ownerName;
  final String email;
  final String? mobile;
  final List<Category> categories;

  ShopProductModel({
    required this.id,
    required this.shopName,
    required this.ownerName,
    required this.email,
    this.mobile,
    required this.categories,
  });

  factory ShopProductModel.fromJson(Map<String, dynamic> json) {
    var categoriesList = json['categories'] as List? ?? [];
    List<Category> categories = categoriesList
        .map((i) => Category.fromJson(i))
        .toList();

    return ShopProductModel(
      id: json['id'] ?? 0,
      shopName: json['shop_name'] ?? 'N/A Shop',
      ownerName: json['owner_name'] ?? 'N/A Owner',
      email: json['email'] ?? 'N/A Email',
      mobile: json['mobile'],
      categories: categories,
    );
  }
}

class Category {
  final int id;
  final String name;
  final String imageUrl;
  final List<Product> products;


  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List? ?? [];
    List<Product> products = productsList
        .map((i) => Product.fromJson(i))
        .toList();

    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'N/A Category',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/200',
      products: products,
    );
  }
}

class Product {
  final int id;
  final String name;
  final String price;
  final String imageUrl;


  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'N/A Product',
      price: json['price'] ?? '0.00',
      imageUrl: json['image_url'] ?? 'https://admin.jewellery.ctpbd.info/placeholder-image/',
    );
  }
}
