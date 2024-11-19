import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';
import 'package:flutter_project/model/AppointmentModel.dart';
import 'package:flutter_project/model/UserModel.dart';
import 'package:flutter_project/pages/receptionist/AppointmentSuccessful.dart';
import 'package:flutter_project/service/AppointmentService.dart';
import 'package:provider/provider.dart';

class AppointmentCreatePage extends StatefulWidget {
  @override
  _AppointmentCreatePageState createState() => _AppointmentCreatePageState();
}

class _AppointmentCreatePageState extends State<AppointmentCreatePage> {
  AppointmentModel appointmentModel = AppointmentModel(
    id: null,
    name: '',
    email: '',
    phone: '',
    gender: '',
    age: null,
    birthday: null,
    date: null,
    time: '',
    notes: '',
    requestedBy: null,
    doctor: null,
  );

  List<DateTime> availableDates = [];
  List<String> availableTimes = [];
  DateTime? selectedDate;
  String? selectedTime;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    generateAvailableDates();
  }

  void generateAvailableDates() {
    final today = DateTime.now();
    for (int i = 1; i <= 5; i++) {
      availableDates.add(today.add(Duration(days: i)));
    }
  }

  void onDateSelect(DateTime date) {
    setState(() {
      selectedDate = date;
      generateAvailableTimes();
    });
  }

  void generateAvailableTimes() {
    availableTimes.clear();
    const intervals = [
      {'start': 9, 'end': 12},
      {'start': 15, 'end': 18},
    ];
    for (var interval in intervals) {
      for (int hour = interval['start']!; hour < interval['end']!; hour++) {
        availableTimes.add('$hour:00');
        availableTimes.add('$hour:30');
      }
    }
  }

  void onTimeSelect(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  Future<void> createAppointment() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both date and time')),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      appointmentModel.date = selectedDate;
      appointmentModel.time = selectedTime;

      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await AuthService.getStoredUser();

      if (user != null) {
        appointmentModel.requestedBy = user;
      }

      final appointmentService = Provider.of<AppointmentService>(context, listen: false);
      final response = await appointmentService.createAppointment(appointmentModel);

      if (response.successful) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Congratulations! Appointment created successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AppointmentSuccessful()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Failed to create appointment'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Appointment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Available Dates", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 10,
                    children: availableDates.map((date) {
                      return ChoiceChip(
                        label: Text("${date.toLocal()}".split(' ')[0]),
                        selected: selectedDate == date,
                        onSelected: (_) => onDateSelect(date),
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (selectedDate != null) ...[
                const SizedBox(height: 20),
                Text("Available Times", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 10,
                      children: availableTimes.map((time) {
                        return ChoiceChip(
                          label: Text(time),
                          selected: selectedTime == time,
                          onSelected: (_) => onTimeSelect(time),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
              if (selectedTime != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Form(
                    key: _formKey,
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Patient Name', border: OutlineInputBorder()),
                              onSaved: (value) => appointmentModel.name = value ?? '',
                              validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                              onSaved: (value) => appointmentModel.email = value ?? '',
                              validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
                              onSaved: (value) => appointmentModel.phone = value ?? '',
                              validator: (value) => value!.isEmpty ? 'Please enter your phone' : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                              onSaved: (value) => appointmentModel.age = value,
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter your age';
                                if (int.tryParse(value) == null) return 'Age must be a number';
                                return null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
                              items: ['Male', 'Female', 'Other'].map((gender) {
                                return DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              onChanged: (value) => appointmentModel.gender = value ?? '',
                              validator: (value) => value == null ? 'Please select a gender' : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Birthday (YYYY-MM-DD)', border: OutlineInputBorder()),
                              onSaved: (value) => appointmentModel.birthday = DateTime.tryParse(value ?? ''),
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter your birthday';
                                if (DateTime.tryParse(value) == null) return 'Enter date in YYYY-MM-DD format';
                                return null;
                              },
                              keyboardType: TextInputType.datetime,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Notes', border: OutlineInputBorder()),
                              onSaved: (value) => appointmentModel.notes = value ?? '',
                              validator: (value) => value!.isEmpty ? 'Please enter notes' : null,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              onPressed: createAppointment, // Call the createAppointment method
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Submit Appointment', style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 8),
                                  Icon(Icons.send, size: 24),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
