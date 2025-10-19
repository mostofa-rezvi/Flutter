import 'package:flutter/material.dart';
import 'package:ovouser/models/shops_products.dart';
import 'package:ovouser/service/user_service.dart';

class ShopDetailScreen extends StatefulWidget {
  final ShopProductModel shop;

  const ShopDetailScreen({super.key, required this.shop});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  void _addToCart(int productId, String productName, int shopId) async {
    final success = await UserService.addToCart(productId, 1, shopId);
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$productName added to cart!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add $productName to cart.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shop.shopName),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.shop.shopName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Owner: ${widget.shop.ownerName}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                'Email: ${widget.shop.email}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              if (widget.shop.mobile != null && widget.shop.mobile!.isNotEmpty)
                Text(
                  'Mobile: ${widget.shop.mobile}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              const Divider(height: 30),
              const Text(
                'Categories & Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              if (widget.shop.categories.isEmpty ||
                  widget.shop.categories.every((c) => c.products.isEmpty))
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('This shop has no products currently.'),
                  ),
                )
              else
                ...widget.shop.categories.map((category) {
                  if (category.products.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: category.products.length,
                        itemBuilder: (context, productIndex) {
                          final product = category.products[productIndex];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 2,
                            child: ListTile(
                              leading: SizedBox(
                                width: 60,
                                height: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              title: Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text('Price: \$${product.price}'),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () => _addToCart(
                                  product.id,
                                  product.name,
                                  widget.shop.id,
                                ),
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'View details for ${product.name}',
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
