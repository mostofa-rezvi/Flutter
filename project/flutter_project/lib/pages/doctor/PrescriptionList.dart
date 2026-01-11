import 'package:flutter/material.dart';
import 'package:flutter_project/model/PrescriptionModel.dart';
import 'package:flutter_project/service/PrescriptionService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class PrescriptionListPage extends StatefulWidget {
  @override
  _PrescriptionListPageState createState() => _PrescriptionListPageState();
}

class _PrescriptionListPageState extends State<PrescriptionListPage> {
  List<PrescriptionModel> _prescriptions = [];
  bool _isLoading = true;
  final PrescriptionService _prescriptionService =
  PrescriptionService(httpClient: http.Client());

  @override
  void initState() {
    super.initState();
    _fetchPrescriptions();
  }

  Future<void> _fetchPrescriptions() async {
    setState(() {
      _isLoading = true;
    });
    try {
      ApiResponse apiResponse = await _prescriptionService.getAllPrescriptions();
      if (apiResponse.successful && apiResponse.data != null) {
        final prescriptionsData = apiResponse.data['prescriptions'] as List;
        setState(() {
          _prescriptions = prescriptionsData
              .map((e) => PrescriptionModel.fromJson(e))
              .toList();
        });
      } else {
        _showError(apiResponse.message ?? "Failed to load prescriptions.");
      }
    } catch (error) {
      _showError("An error occurred: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _viewPrescriptionDetails(PrescriptionModel prescription) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Prescription Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Prescription ID: ${prescription.id ?? ''}'),
                Text('Date: ${prescription.prescriptionDate?.toLocal().toString().split(' ')[0] ?? ''}'),
                Text('Issued By: ${prescription.issuedBy ?? ''}'),
                Text('Patient: ${prescription.patient ?? ''}'),
                Text('Notes: ${prescription.notes ?? ''}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
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
        title: Text('Prescription List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _prescriptions.isEmpty
          ? Center(child: Text('No prescriptions found.'))
          : ListView.builder(
        itemCount: _prescriptions.length,
        itemBuilder: (context, index) {
          final prescription = _prescriptions[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('Prescription #${prescription.id ?? 'Unknown'}'),
              subtitle: Text(
                'Issued by: ${prescription.issuedBy ?? 'N/A'}\nPatient: ${prescription.patient ?? 'N/A'}',
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => _viewPrescriptionDetails(prescription),
            ),
          );
        },
      ),
    );
  }
}
