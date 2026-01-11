import 'package:flutter/material.dart';
import 'package:flutter_project/model/TestModel.dart';
import 'package:flutter_project/service/TestService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class TestListPage extends StatefulWidget {
  const TestListPage({Key? key}) : super(key: key);

  @override
  State<TestListPage> createState() => _TestListPageState();
}

class _TestListPageState extends State<TestListPage> {
  late TestService _testService;
  late Future<List<TestModel>> _testsFuture;

  @override
  void initState() {
    super.initState();
    _testService = TestService(httpClient: http.Client());
    _testsFuture = _fetchTests();
    print(_testsFuture);
  }

  Future<List<TestModel>> _fetchTests() async {
    ApiResponse response = await _testService.getAllTests();
    if (response.successful) {
      return response.data as List<TestModel>;
    } else {
      throw Exception(response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test List'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<TestModel>>(
        future: _testsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final test = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      test.testName ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(test.description ?? ''),
                    trailing: TextButton(
                      onPressed: () {
                        _showTestResultDialog(context, test.result);
                      },
                      child: const Text('View Result'),
                    ),
                    onTap: () {
                      _showTestDetails(context, test);
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No tests available.'));
          }
        },
      ),
    );
  }

// Method to show a dialog with the test result
  void _showTestResultDialog(BuildContext context, String? result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Test Result'),
          content: Text(result != null ? result : 'No Result Available'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


  void _showTestDetails(BuildContext context, TestModel test) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(test.testName ?? ''),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${test.description}'),
              const SizedBox(height: 8),
              Text('Result: ${test.result ?? 'No Result'}'),
              const SizedBox(height: 8),
              Text('Instructions: ${test.instructions ?? 'No Instructions'}'),
              const SizedBox(height: 8),
              Text('Created At: ${test.createdAt ?? 'N/A'}'),
              if (test.updatedAt != null)
                Text('Updated At: ${test.updatedAt ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
