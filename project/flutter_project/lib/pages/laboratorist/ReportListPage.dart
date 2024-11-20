import 'package:flutter/material.dart';
import 'package:flutter_project/model/ReportModel.dart';
import 'package:flutter_project/service/ReportService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  late ReportService _reportService;
  List<ReportModel> _reports = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _reportService = ReportService(httpClient: http.Client());
    _fetchReports();
  }

  // Fetch reports from the backend
  Future<void> _fetchReports() async {
    ApiResponse response = await _reportService.getAllReports();
    if (response.successful) {
      setState(() {
        _reports = response.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = response.message!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report List'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
          : _reports.isEmpty
          ? const Center(child: Text('No reports available'))
          : ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          ReportModel report = _reports[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(report.reportName ?? 'Unknown Report'),
              subtitle: Text(report.reportResult ?? 'No result'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  // Handle navigation to report details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportDetailPage(report: report),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReportDetailPage extends StatelessWidget {
  final ReportModel report;

  const ReportDetailPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report.reportName ?? 'Report Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Report Name: ${report.reportName ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Description: ${report.description ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Test Date: ${report.testDate ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Result: ${report.reportResult ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Interpretation: ${report.interpretation ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
