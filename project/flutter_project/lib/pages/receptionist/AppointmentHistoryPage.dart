import 'package:flutter/material.dart';
import 'package:flutter_project/model/AppointmentModel.dart';
import 'package:flutter_project/service/AppointmentService.dart';
import 'package:flutter_project/util/ApiResponse.dart';
import 'package:http/http.dart' as http;

class AppointmentListPage extends StatefulWidget {
  @override
  _AppointmentListPageState createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  List<AppointmentModel> appointments = [];
  bool isLoading = true;
  final AppointmentService _appointmentService =
      AppointmentService(httpClient: http.Client());

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() {
      isLoading = true;
    });
    try {
      ApiResponse apiResponse = await _appointmentService.getAllAppointments();
      if (apiResponse.successful) {
        final List<AppointmentModel> fetchedAppointments =
            (apiResponse.data['appointments'] as List)
                .map((e) => AppointmentModel.fromJson(e))
                .toList();
        setState(() {
          appointments = fetchedAppointments;
        });
      } else {
        _showError("Invalid appointment.");
      }
    } catch (e) {
      _showError('Failed to load appointments.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteAppointment(int id) async {
    try {
      ApiResponse apiResponse = await _appointmentService.deleteAppointment(id);
      if (apiResponse.successful) {
        _showSuccess('Appointment deleted successfully.');
        await _fetchAppointments();
      } else {
        _showError("Invalid appointment ID.");
      }
    } catch (e) {
      _showError('Failed to delete appointment.');
    }
  }

  void _viewAppointmentDetails(AppointmentModel appointment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Appointment Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Name: ${appointment.name ?? ''}'),
                Text('Email: ${appointment.email ?? ''}'),
                Text('Phone: ${appointment.phone ?? ''}'),
                Text('Gender: ${appointment.gender ?? ''}'),
                Text('Age: ${appointment.age ?? ''}'),
                Text(
                    'Date: ${appointment.date?.toLocal().toString().split(' ')[0] ?? ''}'),
                Text('Time: ${appointment.time ?? ''}'),
                Text('Notes: ${appointment.notes ?? ''}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment History'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : appointments.isEmpty
              ? Center(child: Text('No appointments found.'))
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(appointment.name ?? 'No Name'),
                        subtitle: Text(
                            'Date: ${appointment.date?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteAppointment(appointment.id!),
                        ),
                        onTap: () => _viewAppointmentDetails(appointment),
                      ),
                    );
                  },
                ),
    );
  }
}
