import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:demo_flutter/pages/LoginPage.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();
  final DateTimeFieldPickerPlatform dob = DateTimeFieldPickerPlatform.material;

  String? selectedGender;
  DateTime? selectedDOB;
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      String uName = name.text;
      String uEmail = email.text;
      String uPassword = password.text;
      String uCell = cell.text;
      String uAddress = address.text;
      String uGender = selectedGender ?? 'Others';
      String uDob = selectedDOB != null ? selectedDOB!.toIso8601String(): '';

      final response = await _sendDataToBackend(uName, uEmail, uPassword, uCell, uAddress, uGender, uDob);

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Registration Successful.');
      }
      else if (response.statusCode == 409) {
        print('User already exists.');
      }
      else {
        print('Registration falied with status: ${response.statusCode}');
      }
    }
  }

  Future<http.Response> _sendDataToBackend(
      String name,
      String email,
      String password,
      String cell,
      String address,
      String gender,
      String dob,
      ) async {
    const String url = 'http://localhost:8080/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'cell': cell,
        'address': address,
        'gender': gender,
        'dob': dob,
      }),
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 25,),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 25,),
                TextField(
                  controller: password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 25,),
                TextField(
                  controller: cell,
                  decoration: InputDecoration(
                    labelText: 'Cell Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(height: 25,),
                TextField(
                  controller: address,
                  decoration: InputDecoration(
                    labelText: "Address (Home)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.maps_home_work_rounded),
                  ),
                ),
                SizedBox(height: 25,),
                TextField(
                  controller: confirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 25,),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  pickerPlatform: dob,
                  onChanged: (DateTime? value) {
                    setState(() {
                      selectedDOB = value;
                    });
                  },
                ),
                SizedBox(height: 25,),
                Row(
                  children: [
                    Text('Gender:'),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                              value: 'Male',
                              groupValue: selectedGender,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              }),
                          Text('Male'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                              value: 'Female',
                              groupValue: selectedGender,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              }),
                          Text('Female'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                              value: 'Others',
                              groupValue: selectedGender,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                          ),
                          Text('Others'),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _register();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "Registration",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts
                          .lato()
                          .fontFamily,
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage()
                          ),
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}