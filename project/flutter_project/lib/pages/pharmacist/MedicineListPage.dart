import 'package:flutter/material.dart';
import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/service/MedicineService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class MedicineListPage extends StatefulWidget {
  const MedicineListPage({Key? key}) : super(key: key);

  @override
  _MedicineListPageState createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  bool isLoading = true;
  List<MedicineModel> medicines = [];
  List<MedicineModel> filteredMedicines = [];
  final MedicineService _medicineService = MedicineService(httpClient: http.Client());
  final TextEditingController searchController = TextEditingController();

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
        final medicinesList = (apiResponse.data['medicines'] as List)
            .map((e) => MedicineModel.fromJson(e))
            .toList();

        setState(() {
          medicines = medicinesList;
          filteredMedicines = medicinesList; // Initialize filtered list
        });
      } else {
        _showSnackbar("No medicines available.", Colors.red);
      }
    } catch (e) {
      _showSnackbar('Error fetching medicines: $e', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onSearch() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredMedicines = medicines
          .where((medicine) => (medicine.medicineName ?? '')
          .toLowerCase()
          .contains(query))
          .toList();
    });
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void showMedicineInfo(MedicineModel medicine) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(medicine.medicineName ?? 'Unknown'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dosage Form: ${medicine.dosageForm ?? 'N/A'}'),
              Text('Strength: ${medicine.medicineStrength ?? 'N/A'}'),
              Text('Price: \$${medicine.price?.toStringAsFixed(2) ?? 'N/A'}'),
              Text('Stock: ${medicine.stock ?? 'N/A'}'),
              Text('Instructions: ${medicine.instructions ?? 'N/A'}'),
              if (medicine.manufacturer != null)
                Text('Manufacturer: ${medicine.manufacturer!.name ?? 'N/A'}'),
            ],
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
        title: const Text('Medicine List'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Medicines',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredMedicines.isNotEmpty
                ? ListView.builder(
              itemCount: filteredMedicines.length,
              itemBuilder: (context, index) {
                final medicine = filteredMedicines[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(medicine.medicineName ?? 'Unknown'),
                    subtitle: Text(
                        'Stock: ${medicine.stock ?? 'N/A'}'),
                    trailing: Text(
                        '\$${medicine.price?.toStringAsFixed(2) ?? 'N/A'}'),
                    onTap: () => showMedicineInfo(medicine),
                  ),
                );
              },
            )
                : const Center(child: Text('No medicines found.')),
          ),
        ],
      ),
    );
  }
}
