import 'package:flutter/material.dart';
import 'package:ovoride/api/api_response.dart';
import 'package:ovoride/service/product_service.dart';
import '../models/product.dart';
import '../utils/shared_prefs_helper.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService _service = ProductService();
  List<Product> _products = [];
  bool _loading = true;
  String? _token;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    _token = await SharedPrefsHelper.getToken();
    if (_token == null || _token!.isEmpty) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in or token expired')));
      }
      return;
    }

    final res = await _service.getProducts(_token!);
    setState(() {
      _loading = false;
      _products = res.data ?? [];
    });

    if (res.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.error!)));
      }
    }
  }

  Future<void> _openForm({Product? product}) async {
    _editingId = product?.id;
    _nameController.text = product?.name ?? '';
    _priceController.text = product?.price ?? '';

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product == null ? 'Add Product' : 'Edit Product',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _saveProduct();
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveProduct() async {
    final name = _nameController.text.trim();
    final price = _priceController.text.trim();
    if (name.isEmpty || price.isEmpty) return;
    setState(() => _loading = true);

    _token = await SharedPrefsHelper.getToken();
    if (_token == null || _token!.isEmpty) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in or token expired')));
      }
      return;
    }

    ApiResponse<Product> res;
    if (_editingId == null) {
      res = await _service.createProduct(_token!, name, price);
    } else {
      res = await _service.updateProduct(_token!, _editingId!, name, price);
    }

    setState(() => _loading = false);

    if (res.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.error!)));
      }
    } else {
      _nameController.clear();
      _priceController.clear();
      _editingId = null;
      await _loadProducts();
    }
  }

  Future<void> _confirmDelete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(false as BuildContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(true as BuildContext),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _loading = true);
    _token = await SharedPrefsHelper.getToken();
    if (_token == null || _token!.isEmpty) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in or token expired')));
      }
      return;
    }

    final res = await _service.deleteProduct(_token!, id);
    setState(() => _loading = false);

    if (res.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.error!)));
      }
    } else {
      await _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(onPressed: _loadProducts, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadProducts,
        child: _products.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 60),
            Center(
              child: Text('No products yet. Tap + to create.'),
            ),
          ],
        )
            : ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: _products.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final p = _products[i];
            return ListTile(
              leading: p.image != null && p.image!.isNotEmpty
                  ? CircleAvatar(
                backgroundImage: NetworkImage(p.image!),
              )
                  : const Icon(Icons.inventory_2_outlined),
              title: Text(p.name),
              subtitle: Text('Price: ${p.price}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _openForm(product: p),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => _confirmDelete(p.id),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}