import 'package:flutter/material.dart';
import 'package:flutter_project/model/BillModel.dart';
import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/service/BillService.dart';
import 'package:flutter_project/service/MedicineService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class MedicineBillPage extends StatefulWidget {
  @override
  _MedicineBillPageState createState() => _MedicineBillPageState();
}

class _MedicineBillPageState extends State<MedicineBillPage> {
  bool isLoading = true;
  List<MedicineModel> availableMedicines = [];
  final MedicineService _medicineService = MedicineService(httpClient: http.Client());

  BillModel bill = BillModel();
  List<MedicineModel?> selectedMedicines = [];
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    setState(() {
      isLoading = true;
    });
    try {
      ApiResponse apiResponse = await _medicineService.getAllMedicines();
      if (apiResponse.successful) {
        final List<MedicineModel> loadMedicines = (apiResponse.data['medicines'] as List)
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

  void addMedicine() {
    setState(() {
      selectedMedicines.add(null);
    });
  }

  void removeMedicine(int index) {
    setState(() {
      selectedMedicines.removeAt(index);
    });
    _calculateTotal();
  }

  void _calculateTotal() {
    setState(() {
      totalAmount = selectedMedicines.fold(0.0, (sum, medicine) {
        return sum + (medicine?.price ?? 0.0);
      });
      bill.totalAmount = totalAmount.toInt();
    });
  }

  void _onSubmit() async {
    if (bill.name == null || bill.name!.isEmpty) {
      _showError("Patient name is required.");
      return;
    }

    if (selectedMedicines.isEmpty) {
      _showError("Please select at least one medicine.");
      return;
    }
// problems
    bill.medicineIds = List<int>.from(selectedMedicines.map((medicine) => medicine!.id));

    try {
      ApiResponse response = await BillService(httpClient: http.Client()).createBill(bill);

      if (response != null && response.successful) {
        _showSuccess("Bill created successfully!");
      } else {
        _showError('Failed to create bill.');
      }
    } catch (e) {
      _showError('Error creating bill: $e');
    }
  }

  num _calculateBalance() {
    return bill.totalAmount??0 - (bill.amountPaid ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Medicine Bill')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Information Form
              TextField(
                decoration: InputDecoration(labelText: 'Patient Name'),
                onChanged: (value) => setState(() => bill.name = value),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onChanged: (value) => setState(() => bill.phone = int.tryParse(value)),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => setState(() => bill.email = value),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) => setState(() => bill.address = value),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Invoice Date'),
                onChanged: (value) => setState(() => bill.invoiceDate = value),
              ),
              SizedBox(height: 20),

              Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
              TextField(
                decoration: InputDecoration(labelText: 'Amount Paid'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    bill.amountPaid = int.tryParse(value) ?? 0;
                  });
                },
              ),
              Text('Due Balance: \$${_calculateBalance().toStringAsFixed(2)}'),
              SizedBox(height: 20),

              Text('Medicine List', style: TextStyle(fontSize: 18)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: selectedMedicines.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          DropdownButton<MedicineModel>(
                            isExpanded: true,
                            value: selectedMedicines[index],
                            onChanged: (selectedMedicine) {
                              setState(() {
                                selectedMedicines[index] = selectedMedicine;
                                _calculateTotal();
                              });
                            },
                            items: availableMedicines.map((medicine) {
                              return DropdownMenuItem<MedicineModel>(
                                value: medicine,
                                child: Text('${medicine.medicineName}'),
                              );
                            }).toList(),
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: 'Price'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                selectedMedicines[index]?.price = double.tryParse(value);
                                _calculateTotal();
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle),
                            onPressed: () => removeMedicine(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: addMedicine,
                child: Text('Add Medicine'),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _onSubmit,
                child: Text('Create Bill'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
