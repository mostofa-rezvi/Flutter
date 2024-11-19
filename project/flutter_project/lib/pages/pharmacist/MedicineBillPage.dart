import 'package:flutter/material.dart';
import 'package:flutter_project/model/BillModel.dart';
import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/service/BillService.dart';
import 'package:flutter_project/service/MedicineService.dart';

class MedicineBillPage extends StatefulWidget {
  @override
  _MedicineBillPageState createState() => _MedicineBillPageState();
}

class _MedicineBillPageState extends State<MedicineBillPage> {
  BillModel bill = BillModel();  // Use BillModel here
  List<MedicineModel> availableMedicines = [];
  List<MedicineModel> selectedMedicines = [];
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  void _loadMedicines() async {
    try {
      var response = await MedicineService().getAllMedicines();

      if (response != null && response is List) {
        setState(() {
          availableMedicines = response
              .data((medicine) => MedicineModel.fromJson(medicine))
              .toList();
        });
      } else {
        print('Failed to load medicines: Invalid response');
      }
    } catch (e) {
      print('Error fetching medicines: $e');
    }
  }

  void addMedicine() {
    setState(() {
      selectedMedicines.add(MedicineModel());
    });
    _calculateTotal();
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
        return sum + (medicine.price ?? 0.0);
      });
      bill.totalAmount = totalAmount as int?;
    });
  }

  void _onSubmit() async {
    bill.medicineIds = selectedMedicines.cast<int>();
    try {
      var response = await BillService().createBill(bill);
      if (response != null) {
        Navigator.pushNamed(context, '/medicine-bill-list');
      } else {
        print('Failed to create bill');
      }
    } catch (e) {
      print('Error creating bill: $e');
    }
  }

  num _calculateBalance() {
    return bill.totalAmount! - (bill.amountPaid ?? 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Medicine Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Patient Information Form
              TextField(
                decoration: InputDecoration(labelText: 'Patient Name'),
                onChanged: (value) => setState(() {
                  bill.name = value;
                }),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Phone'),
                onChanged: (value) => setState(() {
                  bill.phone = value as int?;
                }),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => setState(() {
                  bill.email = value;
                }),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) => setState(() {
                  bill.address = value;
                }),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Invoice Date'),
                onChanged: (value) => setState(() {
                  bill.invoiceDate = value;
                }),
              ),
              SizedBox(height: 20),

              Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
              TextField(
                decoration: InputDecoration(labelText: 'Amount Paid'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    bill.amountPaid = (double.tryParse(value) ?? 0.0) as int?;
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<MedicineModel>(
                            isExpanded: true,
                            value: selectedMedicines[index],
                            onChanged: (selectedMedicine) {
                              setState(() {
                                selectedMedicines[index] = selectedMedicine!;
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
                                selectedMedicines[index].price = double.tryParse(value);
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

              // Submit Button
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
