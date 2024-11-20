import 'package:flutter/material.dart';
import 'package:flutter_project/model/ReportModel.dart';
import 'package:flutter_project/service/ReportService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class ReportCreatePage extends StatefulWidget {
  const ReportCreatePage({super.key});

  @override
  State<ReportCreatePage> createState() => _ReportCreatePageState();
}

class _ReportCreatePageState extends State<ReportCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _reportNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _testDateController = TextEditingController();
  final _resultController = TextEditingController();
  final _interpretationController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _testList = [];
  int? _selectedTestId;

  late ReportService _reportService;

  @override
  void initState() {
    super.initState();
    _reportService = ReportService(httpClient: http.Client());
    _fetchTests(); // Fetch tests when the page loads
  }

  // Fetch available tests from the backend
  Future<void> _fetchTests() async {
    setState(() {
      _isLoading = true;
    });

    ApiResponse response = await _reportService.getAllReports(); // Assume this endpoint returns all tests

    setState(() {
      _isLoading = false;
      if (response.successful) {
        _testList = response.data; // Store the tests in _testList
      } else {
        _errorMessage = response.message!;
      }
    });
  }

  // Handle test selection and auto-fill the interpretation field
  void _onTestSelected(int? testId) {
    setState(() {
      _selectedTestId = testId;
      final selectedTest = _testList.firstWhere((test) => test['id'] == testId, orElse: () => {});
      _interpretationController.text = selectedTest.isNotEmpty ? selectedTest['interpretation'] : '';
    });
  }

  // Submit the report creation request
  Future<void> _createReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Create a ReportModel object from the form data
      ReportModel report = ReportModel(
        reportName: _reportNameController.text,
        description: _descriptionController.text,
        testDate: _testDateController.text,
        reportResult: _resultController.text,
        interpretation: _interpretationController.text,
        testId: _selectedTestId,
      );

      // Call the ReportService to create the report
      ApiResponse response = await _reportService.createReport(report);

      setState(() {
        _isLoading = false;
        if (response.successful) {
          // If successful, navigate back to the report list
          Navigator.pop(context);
        } else {
          _errorMessage = response.message!;
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
            : Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              TextFormField(
                controller: _reportNameController,
                decoration: const InputDecoration(labelText: 'Report Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter report name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedTestId,
                hint: const Text('Select Test'),
                onChanged: _onTestSelected,
                items: _testList.map((test) {
                  return DropdownMenuItem<int>(
                    value: test['id'],
                    child: Text(test['reportName']),
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
                decoration: const InputDecoration(labelText: 'Test Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter test date';
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
                decoration: const InputDecoration(labelText: 'Interpretation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter interpretation';
                  }
                  return null;
                },
                readOnly: true, // This field will be auto-filled based on test selection
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
    );
  }
}
