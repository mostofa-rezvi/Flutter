import 'package:flutter/material.dart';
import 'package:flutter_project/model/PrescriptionModel.dart';
import 'package:flutter_project/service/PrescriptionService.dart';

class PrescriptionListPage extends StatefulWidget {
  @override
  _PrescriptionListPageState createState() => _PrescriptionListPageState();
}

class _PrescriptionListPageState extends State<PrescriptionListPage> {
  List<PrescriptionModel> _prescriptions = [];
  bool _isLoading = true;

  final PrescriptionService _prescriptionService = PrescriptionService();

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
      final prescriptions = await _prescriptionService.getAllPrescriptions();
      setState(() {
        _prescriptions = prescriptions;
      });
    } catch (error) {
      _showError("Failed to load prescriptions: $error");
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
                Text('Prescription ID: ${prescription.id ?? 'N/A'}'),
                Text(
                    'Date: ${prescription.prescriptionDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
                Text('Issued By: Dr. ${prescription.issuedBy?.name ?? 'N/A'}'),
                Text('Patient: ${prescription.patient?.name ?? 'N/A'}'),
                Text('Notes: ${prescription.notes ?? 'N/A'}'),
                Text('Medicines:'),
                if (prescription.medicines != null &&
                    prescription.medicines!.isNotEmpty)
                  ...prescription.medicines!
                      .map((medicine) => Text(
                          '- ${medicine.medicineName} (${medicine.medicineStrength})'))
                      .toList()
                else
                  Text('No medicines assigned.'),
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
                        title:
                            Text('Prescription #${prescription.id ?? 'N/A'}'),
                        subtitle: Text(
                            'Issued by: Dr. ${prescription.issuedBy?.name ?? 'N/A'}\n'
                            'Patient: ${prescription.patient?.name ?? 'N/A'}'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () => _viewPrescriptionDetails(prescription),
                      ),
                    );
                  },
                ),
    );
  }
}
