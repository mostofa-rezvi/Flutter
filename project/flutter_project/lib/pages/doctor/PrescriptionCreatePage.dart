// import 'package:flutter/material.dart';
// import 'package:flutter_project/model/MedicineModel.dart';
// import 'package:flutter_project/model/PrescriptionModel.dart';
// import 'package:flutter_project/model/TestModel.dart';
// import 'package:flutter_project/model/UserModel.dart';
// import 'package:flutter_project/service/MedicineService.dart';
// import 'package:flutter_project/service/PrescriptionService.dart';
// import 'package:flutter_project/service/TestService.dart';
//
// class PrescriptionCreatePage extends StatefulWidget {
//   @override
//   _PrescriptionCreatePageState createState() => _PrescriptionCreatePageState();
// }
//
// class _PrescriptionCreatePageState extends State<PrescriptionCreatePage> {
//   final PrescriptionService _prescriptionService = PrescriptionService();
//   final MedicineService _medicineService = MedicineService();
//   final TestService _testService = TestService();
//
//   PrescriptionModel _prescription = PrescriptionModel(
//     id: '',
//     prescriptionDate: DateTime.now(),
//     notes: '',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     test: null,
//     medicine: [],
//     user: [],
//   );
//
//   List<UserModel> _patients = [];
//   List<MedicineModel> _medicines = [];
//   List<TestModel> _tests = [];
//   UserModel? _selectedPatient;
//   MedicineModel? _selectedMedicine;
//   TestModel? _selectedTest;
//   List<MedicineModel> _selectedMedicines = [];
//   List<TestModel> _selectedTests = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMedicines();
//     _loadTests();
//   }
//
//   void _loadMedicines() async {
//     var medicines = await _medicineService.getAllMedicines();
//     setState(() {
//       _medicines = medicines as List<MedicineModel>;
//     });
//   }
//
//   void _loadTests() async {
//     var tests = await _testService.getAllTests();
//     setState(() {
//       _tests = tests as List<TestModel>;
//     });
//   }
//
//   void _addMedicine(MedicineModel medicine) {
//     setState(() {
//       if (!_selectedMedicines.contains(medicine)) {
//         _selectedMedicines.add(medicine);
//       }
//     });
//   }
//
//   void _addTest(TestModel test) {
//     setState(() {
//       if (!_selectedTests.contains(test)) {
//         _selectedTests.add(test);
//       }
//     });
//   }
//
//   void _removeMedicine(int index) {
//     setState(() {
//       _selectedMedicines.removeAt(index);
//     });
//   }
//
//   void _removeTest(int index) {
//     setState(() {
//       _selectedTests.removeAt(index);
//     });
//   }
//
//   void _createPrescription() async {
//     if (_selectedPatient == null) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a patient')));
//       return;
//     }
//
//     _prescription.user = [_selectedPatient!];
//     _prescription.medicine = _selectedMedicines;
//     _prescription.test = _selectedTest;
//
//     try {
//       await _prescriptionService.createPrescription(_prescription);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Prescription created successfully')));
//       _resetForm();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create prescription')));
//     }
//   }
//
//   void _resetForm() {
//     setState(() {
//       _prescription = PrescriptionModel(
//         id: '',
//         prescriptionDate: DateTime.now(),
//         notes: '',
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         test: null,
//         medicine: [],
//         user: [],
//       );
//       _selectedMedicines = [];
//       _selectedTests = [];
//       _selectedPatient = null;
//       _selectedMedicine = null;
//       _selectedTest = null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Create Prescription")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Patient Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     DropdownButtonFormField<UserModel>(
//                       decoration: InputDecoration(labelText: 'Select Patient'),
//                       items: _patients.map((UserModel patient) {
//                         return DropdownMenuItem<UserModel>(
//                           value: patient,
//                           child: Text("name"),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedPatient = value;
//                         });
//                       },
//                       value: _selectedPatient,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Medicines", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     DropdownButtonFormField<MedicineModel>(
//                       decoration: InputDecoration(labelText: 'Select Medicine'),
//                       items: _medicines.map((MedicineModel medicine) {
//                         return DropdownMenuItem<MedicineModel>(
//                           value: medicine,
//                           child: Text(medicine.medicineName),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         _addMedicine(value!);
//                       },
//                     ),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: _selectedMedicines.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(_selectedMedicines[index].medicineName),
//                           trailing: IconButton(
//                             icon: Icon(Icons.remove_circle, color: Colors.red),
//                             onPressed: () => _removeMedicine(index),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Tests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     DropdownButtonFormField<TestModel>(
//                       decoration: InputDecoration(labelText: 'Select Test'),
//                       items: _tests.map((TestModel test) {
//                         return DropdownMenuItem<TestModel>(
//                           value: test,
//                           child: Text(test.testName),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         _addTest(value!);
//                       },
//                     ),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: _selectedTests.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(_selectedTests[index].testName),
//                           trailing: IconButton(
//                             icon: Icon(Icons.remove_circle, color: Colors.red),
//                             onPressed: () => _removeTest(index),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Additional Notes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Notes',
//                         border: OutlineInputBorder(),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           _prescription.notes = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _createPrescription,
//               child: Text("Create Prescription"),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PrescriptionCreatePage(),
  ));
}

class PrescriptionCreatePage extends StatefulWidget {
  @override
  _PrescriptionCreatePageState createState() => _PrescriptionCreatePageState();
}

class _PrescriptionCreatePageState extends State<PrescriptionCreatePage> {
  // Demo data for patients, medicines, and tests
  List<Map<String, String>> _patients = [
    {'id': '1', 'name': 'Alice'},
    {'id': '2', 'name': 'Bob'},
    {'id': '3', 'name': 'Charlie'},
    {'id': '4', 'name': 'Diana'},
    {'id': '5', 'name': 'Edward'},
  ];

  List<Map<String, String>> _medicines = [
    {'id': '1', 'name': 'Paracetamol', 'strength': '500mg'},
    {'id': '2', 'name': 'Ibuprofen', 'strength': '200mg'},
    {'id': '3', 'name': 'Amoxicillin', 'strength': '250mg'},
    {'id': '4', 'name': 'Aspirin', 'strength': '100mg'},
  ];

  List<Map<String, String>> _tests = [
    {'id': '1', 'name': 'Blood Test', 'description': 'Full blood work'},
    {'id': '2', 'name': 'X-Ray', 'description': 'Chest X-Ray'},
    {'id': '3', 'name': 'MRI', 'description': 'Brain MRI'},
    {'id': '4', 'name': 'Urine Test', 'description': 'Urinalysis'},
  ];

  Map<String, String>? _selectedPatient;
  Map<String, String>? _selectedMedicine;
  Map<String, String>? _selectedTest;
  List<Map<String, String>> _selectedMedicines = [];
  List<Map<String, String>> _selectedTests = [];
  String _notes = '';

  void _addMedicine(Map<String, String> medicine) {
    setState(() {
      if (!_selectedMedicines.contains(medicine)) {
        _selectedMedicines.add(medicine);
      }
    });
  }

  void _addTest(Map<String, String> test) {
    setState(() {
      if (!_selectedTests.contains(test)) {
        _selectedTests.add(test);
      }
    });
  }

  void _removeMedicine(int index) {
    setState(() {
      _selectedMedicines.removeAt(index);
    });
  }

  void _removeTest(int index) {
    setState(() {
      _selectedTests.removeAt(index);
    });
  }

  void _createPrescription() {
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a patient')));
      return;
    }

    // Navigate to PrescriptionView and pass the prescription data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrescriptionView(
          patient: _selectedPatient!,
          medicines: _selectedMedicines,
          tests: _selectedTests,
          notes: _notes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Prescription"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Select Patient
            DropdownButtonFormField<Map<String, String>>(
              decoration: InputDecoration(
                labelText: 'Select Patient',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              items: _patients.map((patient) {
                return DropdownMenuItem<Map<String, String>>(
                  value: patient,
                  child: Text(patient['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPatient = value;
                });
              },
              value: _selectedPatient,
            ),
            SizedBox(height: 16),

            // Select Medicines
            DropdownButtonFormField<Map<String, String>>(
              decoration: InputDecoration(
                labelText: 'Select Medicine',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              items: _medicines.map((medicine) {
                return DropdownMenuItem<Map<String, String>>(
                  value: medicine,
                  child: Text(medicine['name']!),
                );
              }).toList(),
              onChanged: (value) {
                _addMedicine(value!);
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _selectedMedicines.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_selectedMedicines[index]['name']!),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeMedicine(index),
                  ),
                );
              },
            ),

            // Select Tests
            DropdownButtonFormField<Map<String, String>>(
              decoration: InputDecoration(
                labelText: 'Select Test',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              items: _tests.map((test) {
                return DropdownMenuItem<Map<String, String>>(
                  value: test,
                  child: Text(test['name']!),
                );
              }).toList(),
              onChanged: (value) {
                _addTest(value!);
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _selectedTests.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_selectedTests[index]['name']!),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeTest(index),
                  ),
                );
              },
            ),

            // Notes
            TextField(
              decoration: InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  _notes = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Create Prescription Button
            ElevatedButton(
              onPressed: _createPrescription,
              child: Text("Create Prescription",
                style: TextStyle(
                  color: Colors.black,
                ),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrescriptionView extends StatelessWidget {
  final Map<String, String> patient;
  final List<Map<String, String>> medicines;
  final List<Map<String, String>> tests;
  final String notes;

  PrescriptionView({
    required this.patient,
    required this.medicines,
    required this.tests,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prescription View",
        style: TextStyle(
          color: Colors.black,
        ),),
        backgroundColor: Colors.white70,
        automaticallyImplyLeading: false, // Disable the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient: ${patient['name']}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Medicines:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            for (var medicine in medicines)
              Text('${medicine['name']} (${medicine['strength']})', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Tests:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            for (var test in tests)
              Text('${test['name']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Notes:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(notes, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            // Go to Home Button
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);  // Navigate back to home page or the previous page
              },
              child: Text("Go to Home",
                style: TextStyle(
                  color: Colors.black,
                ),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
