import 'package:flutter/material.dart';
import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/service/MedicineService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class MedicineListPage extends StatefulWidget {
  @override
  _MedicineListPageState createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  bool isLoading = true;
  List<MedicineModel> availableMedicines = [];
  final MedicineService _medicineService = MedicineService(httpClient: http.Client());

  List<MedicineModel> medicines = [];
  List<MedicineModel> filteredMedicines = [];
  final TextEditingController searchController = TextEditingController();
  ApiResponse? apiResponse;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
    searchController.addListener(onSearch);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMedicines() async {
    setState(() {
      isLoading = true;
    });
    try {
      ApiResponse apiResponse = await _medicineService.getAllMedicines();
      if (apiResponse.successful) {
        final List<MedicineModel> loadMedicines = (
            apiResponse.data['medicines'] as List
        )
            .map((e) => MedicineModel.fromJson(e))
            .toList();
        setState(() {
          availableMedicines = loadMedicines;
        });
      } else {
        _showError("No medicines available.");
      }
    } catch (e) {
      _showError('Error fetching medicines: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  void onSearch() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      filteredMedicines = medicines.where((medicine) {
        return medicine.medicineName!.toLowerCase().contains(searchTerm);
      }).toList();
    });
  }

  void showMedicineInfo(MedicineModel medicine) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${medicine.medicineName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Dosage Form: ${medicine.dosageForm}'),
              Text('Strength: ${medicine.medicineStrength}'),
              Text('Price: \$${medicine.price?.toStringAsFixed(2)}'),
              Text('Stock: ${medicine.stock}'),
              Text('Instructions: ${medicine.instructions}'),
              Text('Manufacturer: ${medicine.manufacturer!.name}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Show error message
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Medicines',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredMedicines.length,
                    itemBuilder: (context, index) {
                      final medicine = filteredMedicines[index];
                      return ListTile(
                        title: Text('${medicine.medicineName}'),
                        subtitle: Text('Stock: ${medicine.stock}'),
                        trailing:
                            Text('\$${medicine.price!.toStringAsFixed(2)}'),
                        onTap: () => showMedicineInfo(medicine),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
