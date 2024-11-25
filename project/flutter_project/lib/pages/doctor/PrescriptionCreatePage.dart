import 'package:flutter/material.dart';
import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/model/PrescriptionModel.dart';
import 'package:flutter_project/model/TestModel.dart';
import 'package:flutter_project/model/UserModel.dart';
import 'package:flutter_project/service/MedicineService.dart';
import 'package:flutter_project/service/PrescriptionService.dart';
import 'package:flutter_project/service/TestService.dart';
import 'package:flutter_project/service/UserService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class PrescriptionCreatePage extends StatefulWidget {
  @override
  _PrescriptionCreatePageState createState() => _PrescriptionCreatePageState();
}

class _PrescriptionCreatePageState extends State<PrescriptionCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _issuedController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  List<TestModel> _testList = [];
  List<MedicineModel> _medicineList = [];
  List<UserModel> _userList = [];

  PrescriptionModel? _selectedUser;
  PrescriptionModel? _selectedMedicine;
  PrescriptionModel? _selectedTest;

  UserModel? _selectUser;
  MedicineModel? _selectMedicine;

  List<MedicineModel> _selectedMedicines = [];
  List<TestModel> _selectedTests = [];
  List<UserModel> _selectedDoctors = [];
  List<UserModel> _selectedPatients = [];

  late TestService _testService;
  late MedicineService _medicineService;
  late UserService _userService;
  late PrescriptionService _prescriptionService;

  @override
  void initState() {
    super.initState();
    _prescriptionService = PrescriptionService(httpClient: http.Client());
    _userService = UserService();
    _medicineService = MedicineService(httpClient: http.Client());
    _testService = TestService(httpClient: http.Client());
    _fetchTests();
    _fetchUsers();
    _fetchMedicines();
  }

  void _onUserSelected(UserModel? user) {
    setState(() {
      _selectedUser = user as PrescriptionModel?;
    });
  }

  void _onMedicineSelected(MedicineModel? medicine) {
    setState(() {
      _selectedMedicine = medicine as PrescriptionModel?;
    });
  }

  Future<void> _fetchTests() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _testService.getAllTests();

    setState(() {
      _isLoading = false;
      if (response.successful) {
        _testList = response.data ?? [];
      } else {
        _errorMessage = response.message ?? 'Failed to load tests.';
      }
    });
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _userService.getAllUsers();

    setState(() {
      _isLoading = false;
      if (response.isNotEmpty) {
        _userList = response;
      } else {
        _errorMessage = 'Failed to load users.';
      }
    });
  }

  Future<void> _fetchMedicines() async {
    setState(() {
      _isLoading = true;
    });

    final apiResponse = await _medicineService.getAllMedicines();
    final List<MedicineModel> loadMedicines = (apiResponse.data['medicines'] as List)
        .map((e) => MedicineModel.fromJson(e))
        .toList();

    setState(() {
      _isLoading = false;
      if (apiResponse.successful) {
        _medicineList = loadMedicines;
      } else {
        _errorMessage = apiResponse.message ?? 'Failed to load medicines.';
      }
    });
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

  void _removePatient(int index) {
    setState(() {
      _selectedPatients.removeAt(index);
    });
  }

  Future<void> _createPrescription() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      PrescriptionModel prescription = PrescriptionModel(
        issuedBy: _selectedDoctors,
        patient: _selectedUser?.patient,
        medicineName: _selectedMedicine?.medicineName,
        test: _selectedTest?.test,
        notes: _notesController.text,
      );

      ApiResponse response =
          await _prescriptionService.createPrescription(prescription);

      setState(() {
        _isLoading = false;
        if (response.successful) {
          Navigator.of(context).pop();
        } else {
          _errorMessage = response.message ?? 'Failed to create prescription.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Prescription'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Doctor Dropdown
                    TextFormField(
                      controller: _issuedController,
                      decoration: const InputDecoration(
                        labelText: 'Issued By',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Patient Dropdown
                    DropdownButtonFormField<UserModel>(
                      value: _selectUser,
                      onChanged: _onUserSelected,
                      decoration: const InputDecoration(
                        labelText: 'Patient Name',
                        border: OutlineInputBorder(),
                      ),
                      items: _userList.map((UserModel user) {
                        return DropdownMenuItem<UserModel>(
                          value: user,
                          child: Text(user.name ?? 'Unknown'),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a test';
                        }
                        return null;
                      },
                    ),
                    Wrap(
                      children: _selectedPatients
                          .asMap()
                          .entries
                          .map((entry) => Chip(
                                label: Text(entry.value.name ?? ''),
                                onDeleted: () => _removePatient(entry.key),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Medicine Dropdown
                    DropdownButtonFormField<MedicineModel>(
                      value: _selectMedicine,
                      onChanged: _onMedicineSelected,
                      decoration: const InputDecoration(
                        labelText: 'Select Medicine',
                        border: OutlineInputBorder(),
                      ),
                      items: _medicineList.map((MedicineModel medicine) {
                        return DropdownMenuItem<MedicineModel>(
                          value: medicine,
                          child: Text(medicine.medicineName ?? 'Unknown'),
                        );
                      }).toList(),
                    ),
                    Wrap(
                      children: _selectedPatients
                          .asMap()
                          .entries
                          .map((entry) => Chip(
                        label: Text(entry.value.name ?? ''),
                        onDeleted: () => _removePatient(entry.key),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Test Dropdown
                    DropdownButtonFormField<TestModel>(
                      decoration: const InputDecoration(
                        labelText: 'Select Test',
                        border: OutlineInputBorder(),
                      ),
                      items: _testList.map((test) {
                        return DropdownMenuItem(
                          value: test,
                          child: Text(test.testName ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) => _addTest(value!),
                    ),
                    Wrap(
                      children: _selectedTests
                          .asMap()
                          .entries
                          .map((entry) => Chip(
                                label: Text(entry.value.testName ?? ''),
                                onDeleted: () => _removeTest(entry.key),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: _createPrescription,
                      child: const Text('Create Prescription'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
