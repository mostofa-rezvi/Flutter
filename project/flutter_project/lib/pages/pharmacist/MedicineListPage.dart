import 'package:flutter/material.dart';
import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/service/MedicineService.dart';
import 'package:flutter_project/util/ApiResponse.dart';

class MedicineListPage extends StatefulWidget {
  @override
  _MedicineListPageState createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  List<MedicineModel> medicines = [];
  List<MedicineModel> filteredMedicines = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  ApiResponse? apiResponse;

  @override
  void initState() {
    super.initState();
    fetchMedicines();
    searchController.addListener(onSearch);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void fetchMedicines() async {
    try {
      ApiResponse response = await MedicineService().getAllMedicines();

      print('Raw response data: ${response.data}');

      if (response.successful) {
        if (response.data is List) {
          List dataList = response.data as List;
          print('Parsed data list: $dataList');

          setState(() {
            medicines =
                dataList.map((item) => MedicineModel.fromJson(item)).toList();
            filteredMedicines = medicines;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showError('Unexpected data format received.');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        showError('An error occurred.');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showError('An error occurred: $error');
    }
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
