import 'package:flutter/material.dart';
import 'package:flutter_project/model/ReportModel.dart';
import 'package:flutter_project/service/ReportService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class ReportListPage extends StatefulWidget {
  const ReportListPage({Key? key}) : super(key: key);

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  late ReportService _reportService;
  late Future<List<ReportModel>> _reportList;
  int? _expandedReportIndex;

  @override
  void initState() {
    super.initState();
    _reportService = ReportService(httpClient: http.Client());
    _reportList = fetchReports();
  }

  Future<List<ReportModel>> fetchReports() async {
    ApiResponse response = await _reportService.getAllReports();
    if (response.successful) {
      return response.data as List<ReportModel>;
    } else {
      throw Exception(response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report List'),
      ),
      body: FutureBuilder<List<ReportModel>>(
        future: _reportList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final report = snapshot.data![index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          report.reportName ?? 'Unnamed Report',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text('Test Date: ${report.testDate ?? 'N/A'}'),
                        trailing: IconButton(
                          icon: Icon(
                            _expandedReportIndex == index
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_expandedReportIndex == index) {
                                _expandedReportIndex = null;
                              } else {
                                _expandedReportIndex = index;
                              }
                            });
                          },
                        ),
                      ),
                      if (_expandedReportIndex == index) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Description: ${report.description ?? 'N/A'}'),
                              Text('Sample ID: ${report.sampleId ?? 'N/A'}'),
                              Text(
                                  'Result: ${report.reportResult ?? 'No Result'}'),
                              Text(
                                  'Interpretation: ${report.interpretation ?? 'N/A'}'),
                              Text('Patient ID: ${report.name ?? 'N/A'}'),
                              Text('Test ID: ${report.testName ?? 'N/A'}'),
                              Text('Test Date: ${report.testDate ?? 'N/A'}'),
                              Text('Created At: ${report.createdAt ?? 'N/A'}'),
                              if (report.updatedAt != null)
                                Text('Updated At: ${report.updatedAt}'),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No reports available.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
        },
      ),
    );
  }
}
