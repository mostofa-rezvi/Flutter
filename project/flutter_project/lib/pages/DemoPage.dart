// import 'package:flutter/material.dart';
// import 'package:flutter_project/model/MedicineModel.dart';
// import 'package:flutter_project/model/PrescriptionModel.dart';
// import 'package:flutter_project/model/TestModel.dart';
// import 'package:flutter_project/model/UserModel.dart';
// import 'package:flutter_project/service/MedicineService.dart';
// import 'package:flutter_project/service/PrescriptionService.dart';
// import 'package:flutter_project/service/TestService.dart';
// import 'package:flutter_project/service/UserService.dart';
// import 'package:http/http.dart' as http;
//
// class PrescriptionCreatePage extends StatefulWidget {
//   @override
//   _PrescriptionCreatePageState createState() => _PrescriptionCreatePageState();
// }
//
// class _PrescriptionCreatePageState extends State<PrescriptionCreatePage> {
//   final _formKey = GlobalKey<FormState>();
//
//   final _descriptionController = TextEditingController();
//   final _testDateController = TextEditingController();
//   final _resultController = TextEditingController();
//   final _notesController = TextEditingController();
//
//   DateTime? _selectedTestDate;
//
//   bool _isLoading = false;
//   String _errorMessage = '';
//   List<TestModel> _testList = [];
//   List<MedicineModel> _medicineList = [];
//   List<UserModel> _userList = [];
//   List<MedicineModel> _selectedMedicines = [];
//   List<TestModel> _selectedTests = [];
//   List<PrescriptionModel> _selected = [];
//   UserModel? _selectedDoctor;
//   UserModel? _selectedPatient;
//
//   late TestService _testService;
//   late MedicineService _medicineService;
//   late UserService _userService;
//   late PrescriptionService _prescriptionService;
//
//   @override
//   void initState() {
//     super.initState();
//     _prescriptionService = PrescriptionService(httpClient: http.Client());
//     _userService = UserService();
//     _medicineService = MedicineService(httpClient: http.Client());
//     _testService = TestService(httpClient: http.Client());
//     _fetchTests();
//     _fetchUsers();
//     _fetchMedicines(); // Fetch medicines as well
//   }
//
//   Future<void> _fetchTests() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     final response = await _testService.getAllTests();
//
//     setState(() {
//       _isLoading = false;
//       if (response.successful) {
//         _testList = response.data ?? [];
//       } else {
//         _errorMessage = response.message ?? 'Failed to load tests.';
//       }
//     });
//   }
//
//   Future<void> _fetchUsers() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     _userList = await _userService.getAllUsers();
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   Future<void> _fetchMedicines() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     final response = await _medicineService.getAllMedicines();
//
//     setState(() {
//       _isLoading = false;
//       if (response.successful) {
//         _medicineList = response.data ?? [];
//       } else {
//         _errorMessage = response.message ?? 'Failed to load medicines.';
//       }
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
//   void _createPrescription() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     _formKey.currentState!.save();
//
//     PrescriptionModel prescription = PrescriptionModel(
//       description: _descriptionController.text,
//       medicines: _selected.medicineName,
//       test: _selected.testName,
//       issuedBy: _selectedDoctor,
//       patient: _selectedPatient,
//       notes: _notesController.text,
//     );
//
//     try {
//       await _prescriptionService.createPrescription(prescription);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Prescription created successfully')),
//       );
//       Navigator.of(context).pop();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to create prescription: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         appBar: AppBar(title: Text('Create Prescription')),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Create Prescription')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Doctor Dropdown
//               DropdownButtonFormField<UserModel>(
//                 decoration: InputDecoration(labelText: 'Issued By (Doctor)'),
//                 items: _userList
//                     .where((user) => user.role == 'DOCTOR')
//                     .map((doctor) {
//                   return DropdownMenuItem(
//                     value: doctor,
//                     child: Text(doctor.name ?? ''),
//                   );
//                 }).toList(),
//                 onChanged: (value) => setState(() => _selectedDoctor = value),
//                 validator: (value) => value == null ? 'Please select a doctor' : null,
//               ),
//
//               // Patient Dropdown
//               DropdownButtonFormField<UserModel>(
//                 decoration: InputDecoration(labelText: 'Patient Name'),
//                 items: _userList
//                     .where((user) => user.role == 'PATIENT')
//                     .map((patient) {
//                   return DropdownMenuItem(
//                     value: patient,
//                     child: Text(patient.name ?? ''),
//                   );
//                 }).toList(),
//                 onChanged: (value) => setState(() => _selectedPatient = value),
//                 validator: (value) => value == null ? 'Please select a patient' : null,
//               ),
//
//               // Medicine Dropdown
//               DropdownButtonFormField<MedicineModel>(
//                 decoration: InputDecoration(labelText: 'Select Medicine'),
//                 items: _medicineList.map((medicine) {
//                   return DropdownMenuItem(
//                     value: medicine,
//                     child: Text(medicine.medicineName ?? ''),
//                   );
//                 }).toList(),
//                 onChanged: (value) => _addMedicine(value!),
//               ),
//
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: _selectedMedicines.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text('${_selectedMedicines[index].medicineName}'),
//                     trailing: IconButton(
//                       icon: Icon(Icons.remove_circle, color: Colors.red),
//                       onPressed: () => setState(() {
//                         _selectedMedicines.removeAt(index);
//                       }),
//                     ),
//                   );
//                 },
//               ),
//
//               // Test Dropdown
//               DropdownButtonFormField<TestModel>(
//                 decoration: InputDecoration(labelText: 'Select Test'),
//                 items: _testList.map((test) {
//                   return DropdownMenuItem(
//                     value: test,
//                     child: Text(test.testName ?? ''),
//                   );
//                 }).toList(),
//                 onChanged: (value) => _addTest(value!),
//               ),
//
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: _selectedTests.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_selectedTests[index].testName ?? ''),
//                     trailing: IconButton(
//                       icon: Icon(Icons.remove_circle, color: Colors.red),
//                       onPressed: () => setState(() {
//                         _selectedTests.removeAt(index);
//                       }),
//                     ),
//                   );
//                 },
//               ),
//
//               // Notes
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Notes'),
//                 controller: _notesController,
//                 maxLines: 3,
//                 onSaved: (value) => _notesController.text = value!,
//               ),
//
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _createPrescription,
//                 child: Text('Create Prescription'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// extension on List<PrescriptionModel> {
//   get testName => null;
//
//   get medicineName => null;
// }
