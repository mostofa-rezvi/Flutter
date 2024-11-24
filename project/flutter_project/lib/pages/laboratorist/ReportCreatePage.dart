import 'package:flutter/material.dart';
import 'package:flutter_project/model/ReportModel.dart';
import 'package:flutter_project/model/UserModel.dart';
import 'package:flutter_project/service/ReportService.dart';
import 'package:flutter_project/service/UserService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class ReportCreatePage extends StatefulWidget {
  const ReportCreatePage({super.key});

  @override
  State<ReportCreatePage> createState() => _ReportCreatePageState();
}

class _ReportCreatePageState extends State<ReportCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _testDateController = TextEditingController();
  final _resultController = TextEditingController();
  final _interpretationController = TextEditingController();

  DateTime? _selectedTestDate;

  bool _isLoading = false;
  String _errorMessage = '';

  List<ReportModel> _testList = [];
  late List<UserModel> _userList = [];

  ReportModel? _selectedTest;
  UserModel? _selectedUser;

  late ReportService _reportService;
  late UserService _userService;

  @override
  void initState() {
    super.initState();
    _reportService = ReportService(httpClient: http.Client());
    _userService = UserService();
    _fetchTests();
    _fetchUsers();
  }

  Future<void> _fetchTests() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _reportService.getAllReports();

    setState(() {
      _isLoading = false;
      if (response.successful) {
        _testList = response.data ?? [];
      } else {
        _errorMessage = response.message ?? 'Failed to load tests.';
      }
    });
  }

  Future<void>  _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    _userList = await _userService.getAllUsers();

    setState(() {
      _isLoading = false;
    });
  }

  void _onTestSelected(ReportModel? test) {
    setState(() {
      _selectedTest = test;
      _interpretationController.text = test?.interpretation ?? '';
    });
  }

  void _onUserSelected(UserModel? user) {
    setState(() {
      _selectedUser = user;
    });
  }

  Future<void> _selectTestDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      _selectedTestDate = selectedDate;
      setState(() {
        _testDateController.text = selectedDate
            .toLocal()
            .toString()
            .split(' ')[0];
      });
    }
  }

  Future<void> _createReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      ReportModel report = ReportModel(
        reportName: _selectedUser?.name,
        description: _descriptionController.text,
        reportResult: _resultController.text,
        interpretation: _interpretationController.text,
        testName: _selectedTest?.testName,
        testDate: _selectedTestDate,
      );

      ApiResponse response = await _reportService.createReport(report);

      setState(() {
        _isLoading = false;
        if (response.successful) {
          Navigator.of(context).pop();
        } else {
          _errorMessage = response.message ?? 'Failed to create report.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      SizedBox(
                        height: 12,
                      ),
                      DropdownButtonFormField<UserModel>(
                        value: _selectedUser,
                        onChanged: _onUserSelected,
                        decoration: const InputDecoration(
                          labelText: 'Select User Name',
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
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      // Test Selection (Dropdown)
                      DropdownButtonFormField<ReportModel>(
                        value: _selectedTest,
                        onChanged: _onTestSelected,
                        decoration: const InputDecoration(
                          labelText: 'Select Test Name',
                          border: OutlineInputBorder(),
                        ),
                        items: _testList.map((ReportModel report) {
                          return DropdownMenuItem<ReportModel>(
                            value: report,
                              child: Text(report.reportName ?? 'Unknown')
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a test';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _testDateController,
                        decoration:
                            const InputDecoration(labelText: 'Test Date'),
                        readOnly: true,
                        onTap: () => _selectTestDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select test date';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _resultController,
                        decoration: const InputDecoration(labelText: 'Result'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter result';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _interpretationController,
                        decoration:
                            const InputDecoration(labelText: 'Interpretation'),
                        readOnly: true, // Auto-filled based on test selection
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _createReport,
                        child: const Text('Create Report'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
