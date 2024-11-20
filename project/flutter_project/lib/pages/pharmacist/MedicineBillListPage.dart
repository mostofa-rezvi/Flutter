import 'package:flutter/material.dart';
import 'package:flutter_project/model/BillModel.dart';
import 'package:flutter_project/service/BillService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class MedicineBillListPage extends StatefulWidget {
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
      ApiResponse apiResponse = await _billService.getAllBills();
      if (apiResponse.successful) {
        final List<BillModel> loadedBills = (apiResponse.data['bills'] as List)
            .map((e) => BillModel.fromJson(e))
            .toList();
        setState(() {
          bills = loadedBills;
        });
      } else {
        _showError('No bills found.');
      }
    } catch (e) {
      _showError('Error loading bills: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _onBillTap(BillModel bill) {
    Navigator.pushNamed(
      context,
      '/medicine-bill-details',
      arguments: bill,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medicine Bills')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bills.isEmpty
          ? Center(child: Text('No bills available.'))
          : ListView.builder(
        itemCount: bills.length,
        itemBuilder: (context, index) {
          final bill = bills[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(bill.name ?? 'Unnamed Patient'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone: ${bill.phone ?? 'N/A'}'),
                  Text('Total: \$${bill.totalAmount?.toStringAsFixed(2) ?? '0.00'}'),
                  Text('Paid: \$${bill.amountPaid?.toStringAsFixed(2) ?? '0.00'}'),
                  Text('Due: \$${(bill.totalAmount! - (bill.amountPaid ?? 0.0)).toStringAsFixed(2)}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => _onBillTap(bill),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-medicine-bill');
        },
        child: Icon(Icons.add),
        tooltip: 'Create New Bill',
      ),
    );
  }
}
