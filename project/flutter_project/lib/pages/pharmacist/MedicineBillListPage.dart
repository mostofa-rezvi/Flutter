import 'package:flutter/material.dart';
import 'package:flutter_project/model/BillModel.dart';
import 'package:flutter_project/service/BillService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class MedicineBillListPage extends StatefulWidget {
  const MedicineBillListPage({Key? key}) : super(key: key);

  @override
  _MedicineBillListPageState createState() => _MedicineBillListPageState();
}

class _MedicineBillListPageState extends State<MedicineBillListPage> {
  final BillService _billService = BillService(httpClient: http.Client());
  List<BillModel> bills = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  Future<void> _loadBills() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch bills from the service
      ApiResponse apiResponse = await _billService.getAllBills();

      // Log response for debugging
      debugPrint('API Response: ${apiResponse.data}');

      if (apiResponse.successful) {
        // Check if data contains bills and parse correctly
        final List<dynamic> rawData = apiResponse.data;
        if (rawData.isNotEmpty) {
          final loadedBills = rawData.map((e) => BillModel.fromJson(e)).toList();
          setState(() {
            bills = loadedBills;
          });
        } else {
          _showSnackbar('No bills found.', Colors.orange);
        }
      } else {
        _showSnackbar('Failed to load bills: ${apiResponse.message}', Colors.red);
      }
    } catch (e) {
      // Catch and log errors
      debugPrint('Error loading bills: $e');
      _showSnackbar('Error loading bills: $e', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _showBillDetails(BuildContext context, BillModel bill) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(bill.name ?? 'Unnamed Bill'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phone: ${bill.phone ?? 'N/A'}'),
                Text('Email: ${bill.email ?? 'N/A'}'),
                Text('Address: ${bill.address ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Invoice Date: ${bill.invoiceDate ?? 'N/A'}'),
                Text('Total Amount: \$${bill.totalAmount?.toStringAsFixed(2) ?? '0.00'}'),
                Text('Amount Paid: \$${bill.amountPaid?.toStringAsFixed(2) ?? '0.00'}'),
                Text('Balance: \$${bill.balance?.toStringAsFixed(2) ?? '0.00'}'),
                Text('Status: ${bill.status ?? 'N/A'}'),
                const SizedBox(height: 8),
                if (bill.medicineIds != null)
                  Text('Medicines: ${bill.medicineIds}'),
                Text('Created At: ${bill.createdAt ?? 'N/A'}'),
                if (bill.updatedAt != null)
                  Text('Updated At: ${bill.updatedAt}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCreateBill() {
    Navigator.pushNamed(context, '/create-medicine-bill');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Bills'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bills.isEmpty
          ? const Center(child: Text('No bills available.'))
          : ListView.builder(
        itemCount: bills.length,
        itemBuilder: (context, index) {
          final bill = bills[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text(bill.name ?? 'Unnamed Bill'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone: ${bill.phone ?? 'N/A'}'),
                  Text(
                      'Total: \$${bill.totalAmount?.toStringAsFixed(2) ?? '0.00'}'),
                  Text(
                      'Paid: \$${bill.amountPaid?.toStringAsFixed(2) ?? '0.00'}'),
                  Text(
                      'Due: \$${(bill.totalAmount ?? 0 - (bill.amountPaid ?? 0)).toStringAsFixed(2)}'),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => _showBillDetails(context, bill),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateBill,
        child: const Icon(Icons.add),
        tooltip: 'Create New Bill',
      ),
    );
  }
}
