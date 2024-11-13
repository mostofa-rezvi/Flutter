// import 'package:flutter/material.dart';
// import 'package:your_project/models/prescription.dart';
// import 'package:your_project/services/prescription_service.dart';
// import 'package:your_project/services/user_service.dart';
// import 'package:your_project/services/medicine_service.dart';
// import 'package:your_project/services/test_service.dart';
// import 'package:your_project/models/user.dart';
// import 'package:your_project/models/medicine.dart';
// import 'package:your_project/models/test.dart';
//
// class PrescriptionMainPage extends StatefulWidget {
//   @override
//   _PrescriptionMainPageState createState() => _PrescriptionMainPageState();
// }
//
// class _PrescriptionMainPageState extends State<PrescriptionMainPage> {
//   Prescription prescription = Prescription();
//   List<UserModel> patients = [];
//   UserModel? selectedUser;
//   List<Medicine> medicines = [];
//   List<Medicine> selectedMedicines = [];
//   List<Test> tests = [];
//   Test? selectedTest;
//
//   @override
//   void initState() {
//     super.initState();
//     loadPatients();
//     loadMedicines();
//     loadTests();
//   }
//
//   void loadPatients() async {
//     final response = await UserService.getUsersByRole('PATIENT');
//     setState(() {
//       patients = response;  // Assuming the response is a list of patients
//     });
//   }
//
//   void loadMedicines() async {
//     final response = await MedicineService.getAllMedicines();
//     setState(() {
//       medicines = response;  // Assuming the response is a list of medicines
//     });
//   }
//
//   void loadTests() async {
//     final response = await TestService.getAllTests();
//     setState(() {
//       tests = response;  // Assuming the response is a list of tests
//     });
//   }
//
//   void onMedicineSelect(Medicine medicine) {
//     if (!selectedMedicines.contains(medicine)) {
//       setState(() {
//         selectedMedicines.add(medicine);
//       });
//     }
//   }
//
//   void onTestSelect(Test test) {
//     if (!selectedTests.contains(test)) {
//       setState(() {
//         selectedTests.add(test);
//       });
//     }
//   }
//
//   void removeMedicine(int index) {
//     setState(() {
//       selectedMedicines.removeAt(index);
//     });
//   }
//
//   void removeTest(int index) {
//     setState(() {
//       selectedTests.removeAt(index);
//     });
//   }
//
//   void createPrescription() {
//     PrescriptionService.createPrescription(prescription).then((newPrescription) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Prescription created successfully!')));
//       resetForm();
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create prescription')));
//     });
//   }
//
//   void resetForm() {
//     setState(() {
//       prescription = Prescription();
//       selectedMedicines.clear();
//       selectedTests.clear();
//       selectedUser = null;
//     });
//     loadPatients();
//     loadMedicines();
//     loadTests();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Create Prescription')),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Select Patient
//               DropdownButtonFormField<UserModel>(
//                 value: selectedUser,
//                 hint: Text('Select Patient'),
//                 onChanged: (UserModel? newValue) {
//                   setState(() {
//                     selectedUser = newValue;
//                   });
//                 },
//                 items: patients.map((UserModel patient) {
//                   return DropdownMenuItem<UserModel>(
//                     value: patient,
//                     child: Text(patient.name),
//                   );
//                 }).toList(),
//               ),
//               if (selectedUser != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     'Selected Patient: ${selectedUser!.name}\nAge: ${selectedUser!.age}\nGender: ${selectedUser!.gender}',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//
//               // Select Medicines
//               DropdownButtonFormField<Medicine>(
//                 value: null,
//                 hint: Text('Select Medicine'),
//                 onChanged: (Medicine? newMedicine) {
//                   if (newMedicine != null) onMedicineSelect(newMedicine);
//                 },
//                 items: medicines.map((Medicine medicine) {
//                   return DropdownMenuItem<Medicine>(
//                     value: medicine,
//                     child: Text(medicine.medicineName),
//                   );
//                 }).toList(),
//               ),
//
//               // Display Selected Medicines
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: selectedMedicines.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text('${selectedMedicines[index].medicineName}'),
//                     subtitle: Text(
//                         'Strength: ${selectedMedicines[index].medicineStrength}\nInstructions: ${selectedMedicines[index].instructions}'),
//                     trailing: IconButton(
//                       icon: Icon(Icons.remove_circle),
//                       onPressed: () => removeMedicine(index),
//                     ),
//                   );
//                 },
//               ),
//
//               // Select Tests
//               DropdownButtonFormField<Test>(
//                 value: null,
//                 hint: Text('Select Test'),
//                 onChanged: (Test? newTest) {
//                   if (newTest != null) onTestSelect(newTest);
//                 },
//                 items: tests.map((Test test) {
//                   return DropdownMenuItem<Test>(
//                     value: test,
//                     child: Text(test.testName),
//                   );
//                 }).toList(),
//               ),
//
//               // Display Selected Tests
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: selectedTests.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(selectedTests[index].testName),
//                     trailing: IconButton(
//                       icon: Icon(Icons.remove_circle),
//                       onPressed: () => removeTest(index),
//                     ),
//                   );
//                 },
//               ),
//
//               // Notes
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Notes'),
//                 onChanged: (value) {
//                   setState(() {
//                     prescription.notes = value;
//                   });
//                 },
//               ),
//
//               // Create Prescription Button
//               ElevatedButton(
//                 onPressed: createPrescription,
//                 child: Text('Create Prescription'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
