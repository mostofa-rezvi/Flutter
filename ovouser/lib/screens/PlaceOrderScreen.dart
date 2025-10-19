import 'package:flutter/material.dart';
import 'package:ovouser/models/Cart.dart';
import 'package:ovouser/screens/OrderHistoryScreen.dart';
import 'package:ovouser/service/user_service.dart';
import 'package:ovouser/utils/shared_prefs_helper.dart';

class PlaceOrderScreen extends StatefulWidget {
  final Cart cart;

  const PlaceOrderScreen({super.key, required this.cart});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController();

  String? _selectedPaymentMethod;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _confirmOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPaymentMethod == null || _selectedPaymentMethod!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUserInfo() async {
    final name = await SharedPrefsHelper.getUserName();
    final email = await SharedPrefsHelper.getUserEmail();
    final mobile =
        await SharedPrefsHelper.getUserMobile();
    final address =
        await SharedPrefsHelper.getUserAddress();

    setState(() {
      _nameController.text = name ?? '';
      _emailController.text = email ?? '';
      _mobileController.text = mobile ?? '';
      _addressController.text = address ?? '';
      _selectedPaymentMethod = 'Cash on Delivery';
    });
  }

  // Future<void> _confirmOrder() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
  //
  //   if (_selectedPaymentMethod == null || _selectedPaymentMethod!.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please select a payment method.')),
  //     );
  //     return;
  //   }
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   // Pass the selected payment method and address to the service
  //   final success = await UserService.placeOrder(
  //     paymentMethod: _selectedPaymentMethod!,
  //     shippingAddress: _addressController.text,
  //   );
  //
  //   if (success) {
  //     // Save current address and mobile for next time
  //     await SharedPrefsHelper.saveUserMobile(_mobileController.text);
  //     await SharedPrefsHelper.saveUserAddress(_addressController.text);
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Order placed successfully!')),
  //     );
  //     // Navigate to order history and remove all previous routes
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
  //       (Route<dynamic> route) => false, // Remove all routes below
  //     );
  //   } else {
  //     // The error message from the API call will be logged, but for the user
  //     // a generic message is fine or you could parse the error for more detail.
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Failed to place order.')));
  //   }
  //
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Order')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shipping Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      readOnly:
                          true,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _mobileController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Shipping Address',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your shipping address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _selectedPaymentMethod,
                      decoration: const InputDecoration(
                        labelText: 'Select Payment Method',
                        border: OutlineInputBorder(),
                      ),
                      items: <String>['Cash on Delivery', 'Card']
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPaymentMethod = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a payment method';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.cart.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.cart.items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.quantity}x ${item.productName}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Text(
                                '\$${(item.quantity * item.price).toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(height: 30, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cart Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${widget.cart.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _confirmOrder,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm Order',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
