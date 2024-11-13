import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Appointment {
  final String name;
  final String email;
  final String phone;
  final String date;
  final String time;
  final String notes;
  final String doctorName;
  String? doctorId;

  Appointment({
    required this.name,
    required this.email,
    required this.phone,
    required this.date,
    required this.time,
    required this.notes,
    required this.doctorName,
    this.doctorId,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      date: json['date'],
      time: json['time'],
      notes: json['notes'],
      doctorName: json['doctor'] != null ? json['doctor']['name'] : 'Not Assigned',
      doctorId: json['doctor'] != null ? json['doctor']['id'] : null,
    );
  }
}

class Doctor {
  final String id;
  final String name;

  Doctor({required this.id, required this.name});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
    );
  }
}

class AppointmentList extends StatefulWidget {
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List<Appointment> appointments = [];
  List<Appointment> filteredAppointments = [];
  List<Doctor> doctors = [];
  bool isLoading = true;
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    fetchAppointments();
    fetchDoctors();
  }

  Future<void> fetchAppointments() async {
    final response = await http.get(Uri.parse('your_api_url/appointments'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        appointments = data.map((item) => Appointment.fromJson(item)).toList();
        filteredAppointments = appointments;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  Future<void> fetchDoctors() async {
    final response = await http.get(Uri.parse('your_api_url/doctors'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        doctors = data.map((item) => Doctor.fromJson(item)).toList();
      });
    } else {
      // Handle error
    }
  }

  void onDoctorSelect(Appointment appointment, String selectedDoctorId) {
    setState(() {
      appointment.doctorId = selectedDoctorId;
    });
  }

  void assignDoctor(Appointment appointment) async {
    if (appointment.doctorId == null || appointment.doctorId!.isEmpty) {
      // Show alert: "Please select a doctor"
      return;
    }

    final response = await http.put(
      Uri.parse('your_api_url/appointments/${appointment.name}'),
      body: json.encode({
        'doctorId': appointment.doctorId,
      }),
    );

    if (response.statusCode == 200) {
      // Show success alert
      fetchAppointments(); // Refresh the appointments
    } else {
      // Show failure alert
    }
  }

  void searchAppointments() {
    setState(() {
      if (searchTerm.isNotEmpty) {
        filteredAppointments = appointments.where((appointment) {
          return appointment.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
              appointment.doctorName.toLowerCase().contains(searchTerm.toLowerCase());
        }).toList();
      } else {
        filteredAppointments = appointments;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointments List')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
                searchAppointments();
              },
              decoration: InputDecoration(
                labelText: 'Search by Patient Name or Doctor',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),

            // Loading indicator
            if (isLoading)
              Center(child: CircularProgressIndicator()),

            // No appointments found
            if (!isLoading && filteredAppointments.isEmpty)
              Center(child: Text('No appointments found')),

            // Appointments list
            if (!isLoading && filteredAppointments.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = filteredAppointments[index];
                    return Card(
                      child: ListTile(
                        title: Text(appointment.name),
                        subtitle: Text('Doctor: ${appointment.doctorName}'),
                        trailing: DropdownButton<String>(
                          hint: Text('Assign Doctor'),
                          value: appointment.doctorId,
                          onChanged: (value) {
                            onDoctorSelect(appointment, value!);
                          },
                          items: doctors.map((doctor) {
                            return DropdownMenuItem<String>(
                              value: doctor.id,
                              child: Text(doctor.name),
                            );
                          }).toList(),
                        ),
                        onTap: () {
                          assignDoctor(appointment);
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
