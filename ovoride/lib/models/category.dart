class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    final int categoryId = json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '') ?? 0);
    return Category(
      id: categoryId,
      name: json['name'] ?? 'Unnamed Category',
    );
  }
}




