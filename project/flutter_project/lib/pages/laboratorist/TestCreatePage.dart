import 'package:flutter/material.dart';
import 'package:flutter_project/model/TestModel.dart';
import 'package:flutter_project/service/TestService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class TestCreatePage extends StatefulWidget {
  const TestCreatePage({super.key});

  @override
  State<TestCreatePage> createState() => _TestCreatePageState();
}

class _TestCreatePageState extends State<TestCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _testNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _resultController = TextEditingController();
  final _instructionsController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  List<TestModel> _tests = [];
  TestModel? _selectedTest;

  Future<void> _fetchTests() async {
    setState(() {
      _isLoading = true;
    });

    ApiResponse response = await TestService(httpClient: http.Client()).getAllTests();

    setState(() {
      _isLoading = false;
    });

    if (response.successful) {
      setState(() {
        _tests = response.data;
      });
    } else {
      setState(() {
        _errorMessage = response.message!;
      });
    }
  }

  Future<void> _createTest() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      TestModel test = TestModel(
        testName: _testNameController.text,
        description: _descriptionController.text,
        result: _resultController.text,
        instructions: _instructionsController.text,
      );

      ApiResponse response = await TestService(httpClient: http.Client()).createTest(test);

      setState(() {
        _isLoading = false;
      });

      if (response.successful) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.message}')),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = response.message!;
        });
      }
    }
  }

  void _onTestSelected(TestModel? test) {
    setState(() {
      _selectedTest = test;
      _instructionsController.text = test?.instructions ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTests();
  }

  @override
  void dispose() {
    _testNameController.dispose();
    _descriptionController.dispose();
    _resultController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Test Name Dropdown
              DropdownButtonFormField<TestModel>(
                value: _selectedTest,
                onChanged: _onTestSelected,
                decoration: const InputDecoration(
                  labelText: 'Select Test Name',
                  border: OutlineInputBorder(),
                ),
                items: _tests.map((TestModel test) {
                  return DropdownMenuItem<TestModel>(
                    value: test,
                    child: Text(test.testName ?? ''),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a test';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _resultController,
                decoration: const InputDecoration(
                  labelText: 'Result',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Instructions',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16.0),

              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              ElevatedButton(
                onPressed: _isLoading ? null : _createTest,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
