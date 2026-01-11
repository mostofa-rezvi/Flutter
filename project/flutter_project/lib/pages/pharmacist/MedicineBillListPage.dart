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
  late BillService _billService;
  late Future<List<BillModel>> _billsFuture;

  @override
  void initState() {
    super.initState();
    _billService = BillService(httpClient: http.Client());
    _billsFuture = _loadBills();
  }

  Future<List<BillModel>> _loadBills() async {
    ApiResponse apiResponse = await _billService.getAllBills();
    if (apiResponse.successful) {
      return apiResponse.data as List<BillModel>;
    } else {
      throw Exception(apiResponse.message);
    }
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
                Text(
                    'Total Amount: \$${bill.totalAmount?.toStringAsFixed(2) ?? '0.00'}'),
                Text(
                    'Amount Paid: \$${bill.amountPaid?.toStringAsFixed(2) ?? '0.00'}'),
                Text(
                    'Balance: \$${bill.balance?.toStringAsFixed(2) ?? '0.00'}'),
                Text('Status: ${bill.status ?? 'N/A'}'),
                const SizedBox(height: 8),
                if (bill.medicineIds != null)
                  Text('Medicines: ${bill.medicineIds?.join(', ') ?? 'N/A'}'),
                Text('Created At: ${bill.createdAt ?? 'N/A'}'),
                if (bill.updatedAt != null)
                  Text('Updated At: ${bill.updatedAt ?? 'N/A'}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Bills'),
      ),
      body: FutureBuilder<List<BillModel>>(
        future: _billsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final bill = snapshot.data![index];
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
            );
          } else {
            return const Center(child: Text('No bills available.'));
          }
        },
      ),
    );
  }
}
