import 'package:flutter/material.dart';
import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/model/PrescriptionModel.dart';
import 'package:flutter_project/model/TestModel.dart';
import 'package:flutter_project/model/UserModel.dart';
import 'package:flutter_project/service/MedicineService.dart';
import 'package:flutter_project/service/PrescriptionService.dart';
import 'package:flutter_project/service/TestService.dart';
import 'package:flutter_project/service/UserService.dart';
import 'package:http/http.dart' as http;

class PrescriptionCreatePage extends StatefulWidget {
  @override
  _PrescriptionCreatePageState createState() => _PrescriptionCreatePageState();
}

class _PrescriptionCreatePageState extends State<PrescriptionCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final PrescriptionService _prescriptionService = PrescriptionService(httpClient: http.Client());
  final MedicineService _medicineService = MedicineService();
  final TestService _testService = TestService();
  final UserService _userService = UserService();

  final PrescriptionModel _prescription = PrescriptionModel();

  List<MedicineModel> _medicines = [];
  List<TestModel> _tests = [];
  List<UserModel> _doctors = [];
  List<UserModel> _patients = [];

  MedicineModel? _selectedMedicine;
  TestModel? _selectedTest;
  UserModel? _selectedDoctor;
  UserModel? _selectedPatient;

  List<MedicineModel> _selectedMedicines = [];
  List<TestModel> _selectedTests = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    try {
      final medicines = await _medicineService.getAllMedicines();
      final tests = await _testService.getAllTests();
      final users = await _userService.getAllUsers();

      setState(() {
        _medicines = medicines as List<MedicineModel>;
        _tests = tests as List<TestModel>;
        _doctors = users.where((user) => user.role == 'DOCTOR').toList();
        _patients = users.where((user) => user.role == 'PATIENT').toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addMedicine(MedicineModel medicine) {
    setState(() {
      if (!_selectedMedicines.contains(medicine)) {
        _selectedMedicines.add(medicine);
      }
    });
  }

  void _addTest(TestModel test) {
    setState(() {
      if (!_selectedTests.contains(test)) {
        _selectedTests.add(test);
      }
    });
  }

  void _createPrescription() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _prescription.medicines = _selectedMedicines.isNotEmpty ? _selectedMedicines.first : null;
    _prescription.test = _selectedTests.isNotEmpty ? _selectedTests.first : null;
    _prescription.issuedBy = _selectedDoctor?.name as UserModel?;
    _prescription.patient = _selectedPatient?.name as UserModel?;

    try {
      await _prescriptionService.createPrescription(_prescription);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prescription created successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create prescription: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Create Prescription')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Create Prescription')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Doctor Dropdown
              DropdownButtonFormField<UserModel>(
                decoration: InputDecoration(labelText: 'Issued By (Doctor)'),
                items: _doctors.map((doctor) {
                  return DropdownMenuItem(
                    value: doctor,
                    child: Text(_doctors as String),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedDoctor = value),
                validator: (value) => value == null ? 'Please select a doctor' : null,
              ),

              // Patient Dropdown
              DropdownButtonFormField<UserModel>(
                decoration: InputDecoration(labelText: 'Patient Name'),
                items: _patients.map((patient) {
                  return DropdownMenuItem(
                    value: patient,
                    child: Text(_patients as String),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedPatient = value),
                validator: (value) => value == null ? 'Please select a patient' : null,
              ),

              // Medicine Dropdown
              DropdownButtonFormField<MedicineModel>(
                decoration: InputDecoration(labelText: 'Select Medicine'),
                items: _medicines.map((medicine) {
                  return DropdownMenuItem(
                    value: medicine,
                    child: Text(medicine.medicineName),
                  );
                }).toList(),
                onChanged: (value) => _addMedicine(value!),
              ),

              // Selected Medicines List
              ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedMedicines.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_selectedMedicines[index].medicineName),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => setState(() => _selectedMedicines.removeAt(index)),
                    ),
                  );
                },
              ),

              // Test Dropdown
              DropdownButtonFormField<TestModel>(
                decoration: InputDecoration(labelText: 'Select Test'),
                items: _tests.map((test) {
                  return DropdownMenuItem(
                    value: test,
                    child: Text(test.testName),
                  );
                }).toList(),
                onChanged: (value) => _addTest(value!),
              ),

              // Selected Tests List
              ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedTests.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_selectedTests[index].testName),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => setState(() => _selectedTests.removeAt(index)),
                    ),
                  );
                },
              ),

              // Notes Field
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                maxLines: 3,
                onSaved: (value) => _prescription.notes = value,
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createPrescription,
                child: Text('Create Prescription'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
