import 'package:flutter/material.dart';
import 'package:ovouser/login/login_screen.dart';
import 'package:ovouser/models/shops_products.dart';
import 'package:ovouser/screens/CartScreen.dart';
import 'package:ovouser/screens/OrderHistoryScreen.dart';
import 'package:ovouser/screens/profile_screen.dart';
import 'package:ovouser/screens/settings_screen.dart';
import 'package:ovouser/screens/shop_detail_screen.dart';
import 'package:ovouser/service/shops_product_service.dart';
import 'package:ovouser/service/user_service.dart';
import 'package:ovouser/utils/shared_prefs_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ShopProductModel>> _shopsFuture;
  List<ShopProductModel> _allShops = [];
  List<ShopProductModel> _filteredShops = [];
  final TextEditingController _searchController = TextEditingController();

  String _userName = 'Guest User';
  String _userEmail = 'guest@example.com';

  @override
  void initState() {
    super.initState();
    _fetchShops();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final name = await SharedPrefsHelper.getUserName();
    final email = await SharedPrefsHelper.getUserEmail();
    setState(() {
      _userName = name ?? 'Guest User';
      _userEmail = email ?? 'guest@example.com';
    });
  }

  Future<void> _fetchShops() async {
    _shopsFuture = ApiService().fetchShopsWithProducts();
    try {
      final shops = await _shopsFuture;
      setState(() {
        _allShops = shops;
        _filteredShops = shops;
      });
    } catch (error, stackTrace) {
      debugPrint('Error fetching shops: $error');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load shops: $error')));
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredShops = _allShops;
      } else {
        _filteredShops = _allShops.where((shop) {
          final shopNameMatch = shop.shopName.toLowerCase().contains(
            query.toLowerCase(),
          );
          final ownerNameMatch = shop.ownerName.toLowerCase().contains(
            query.toLowerCase(),
          );
          final productMatch = shop.categories.any(
            (category) => category.products.any(
              (product) =>
                  product.name.toLowerCase().contains(query.toLowerCase()),
            ),
          );
          return shopNameMatch || ownerNameMatch || productMatch;
        }).toList();
      }
    });
  }

  void _logout() async {
    await SharedPrefsHelper.removeToken();
    await SharedPrefsHelper.removeUserInfo();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

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
      drawer: _buildDrawer(),
      appBar: AppBar(
        elevation: 0.8,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'OvoRide Shops',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _searchController.clear();
          _onSearchChanged('');
          await _fetchShops();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search shop, owner, or product...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ShopProductModel>>(
                future: _shopsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (_filteredShops.isEmpty &&
                      _searchController.text.isNotEmpty) {
                    return const Center(
                      child: Text('No matching shops or products found.'),
                    );
                  } else if (_allShops.isEmpty && _filteredShops.isEmpty) {
                    return const Center(child: Text('No shops available.'));
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredShops.length,
                    itemBuilder: (context, index) {
                      final shop = _filteredShops[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ShopDetailScreen(shop: shop),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.blueAccent
                                          .withOpacity(0.1),
                                      child: Text(
                                        shop.shopName.isNotEmpty
                                            ? shop.shopName[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            shop.shopName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            "Owner: ${shop.ownerName}",
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (shop.categories.any(
                                  (c) => c.products.isNotEmpty,
                                ))
                                  const Text(
                                    'Popular Products',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                ...shop.categories.take(1).expand((category) {
                                  if (category.products.isEmpty) return [];
                                  return category.products.take(2).map((
                                    product,
                                  ) {
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 4,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                      ),
                                      elevation: 1,
                                      child: ListTile(
                                        leading: SizedBox(
                                          width: 55,
                                          height: 55,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            child: Image.network(
                                              product.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Container(
                                                    color: Colors.grey[200],
                                                    child: const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Price: \$${product.price}',
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.add_shopping_cart,
                                            size: 20,
                                            color: Colors.blueAccent,
                                          ),
                                          onPressed: () => _addToCart(
                                            product.id,
                                            product.name,
                                            shop.id,
                                          ),
                                        ),
                                        onTap: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Tapped on ${product.name}',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  });
                                }),
                                if (shop.categories.isEmpty ||
                                    shop.categories.every(
                                      (c) => c.products.isEmpty,
                                    ))
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'This shop has no products currently.',
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E86DE), Color(0xFF74B9FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(_userName),
            accountEmail: Text(_userEmail),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 45, color: Colors.blueAccent),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.person_rounded),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: const Text('Order History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart List'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
