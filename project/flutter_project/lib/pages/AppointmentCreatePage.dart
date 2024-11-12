import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';
import 'package:flutter_project/model/AppointmentModel.dart';
import 'package:flutter_project/model/UserModel.dart';
import 'package:flutter_project/service/AppointmentService.dart';
import 'package:provider/provider.dart';


class AppointmentCreatePage extends StatefulWidget {
  @override
  _AppointmentCreatePageState createState() => _AppointmentCreatePageState();
}

class _AppointmentCreatePageState extends State<AppointmentCreatePage> {
  AppointmentModel appointmentModel = AppointmentModel(id: id, name: name, email: email, phone: phone, gender: gender, age: name, birthday: birthday, date: name, time: name, notes: notes, requestedBy: requestedBy, doctor: doctor);
  List<DateTime> availableDates = [];
  List<String> availableTimes = [];
  DateTime? selectedDate;
  String? selectedTime;

  final _formKey = GlobalKey<FormState>();

  static get id => null;
  static get name => null;
  static get email => null;
  static get phone => null;
  static get gender => null;
  static get birthday => null;
  static get notes => null;
  static get requestedBy => null;
  static get doctor => null;

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
      appointmentModel.date = selectedDate!;
      appointmentModel.time = selectedTime! + ":00";

      final authService = Provider.of<AuthService>(context, listen: false);
      final user = AuthService.getStoredUser();
      if (user != null) {
        appointmentModel.requestedBy = user as UserModel;
      }

      final appointmentService = Provider.of<AppointmentService>(context, listen: false);
      final response = await appointmentService.createAppointment(appointmentModel);
      if (response.successful) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message ?? 'Error creating appointment')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Available Dates", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: availableDates.map((date) {
                  return ChoiceChip(
                    label: Text("${date.toLocal()}".split(' ')[0]),
                    selected: selectedDate == date,
                    onSelected: (_) => onDateSelect(date),
                  );
                }).toList(),
              ),
              if (selectedDate != null) ...[
                SizedBox(height: 20),
                Text("Available Times", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 10,
                  children: availableTimes.map((time) {
                    return ChoiceChip(
                      label: Text(time),
                      selected: selectedTime == time,
                      onSelected: (_) => onTimeSelect(time),
                    );
                  }).toList(),
                ),
              ],
              if (selectedTime != null)
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Patient Name'),
                        onSaved: (value) => appointmentModel.name = value ?? '',
                        validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        onSaved: (value) => appointmentModel.email = value ?? '',
                        validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Phone'),
                        onSaved: (value) => appointmentModel.phone = value ?? '',
                        validator: (value) => value!.isEmpty ? 'Please enter your phone' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Age'),
                        onSaved: (value) => appointmentModel.age = int.parse(value ?? '0'),
                        validator: (value) => value!.isEmpty ? 'Please enter your age' : null,
                        keyboardType: TextInputType.number,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Gender'),
                        items: ['Male', 'Female', 'Other'].map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (value) => appointmentModel.gender = value ?? '',
                        validator: (value) => value == null ? 'Please select a gender' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Birthday'),
                        onSaved: (value) => appointmentModel.birthday = DateTime.parse(value!),
                        validator: (value) => value!.isEmpty ? 'Please enter your birthday' : null,
                        keyboardType: TextInputType.datetime,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Doctor Name'),
                        onSaved: (value) => appointmentModel.notes = value ?? '',
                        validator: (value) => value!.isEmpty ? 'Please enter doctor name' : null,
                        maxLines: 3,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: createAppointment,
                          child: Text('Submit Appointment'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
