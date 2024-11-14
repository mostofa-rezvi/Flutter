import 'package:flutter/material.dart';
import 'package:flutter_project/pages/doctor/DoctorPage.dart';
import 'package:flutter_project/pages/laboratorist/LaboratoristPage.dart';
import 'package:flutter_project/pages/nurse/NursePage.dart';
import 'package:flutter_project/pages/patient/PatientPage.dart';
import 'package:flutter_project/pages/pharmacist/PharmacistPage.dart';
import 'package:flutter_project/pages/receptionist/ReceptionistMainPage.dart';
import 'package:flutter_project/login/ForgetPasswordPage.dart';
import 'package:flutter_project/pages/MainPage.dart';
import 'package:flutter_project/login/RegistrationPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/auth/AuthService.dart';

import '../model/UserModel.dart';
import '../util/ApiResponse.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController()..text = 'admin@gmail.com';
  final TextEditingController _passwordController = TextEditingController()..text = '123';
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Image.asset(
                      'assets/image/logo-dark.png',
                      height: 100,
                    ),
                  ),
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  // Error Message
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 16.0),
                  ],
                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forgot password screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPasswordPage()),
                        );
                      },
                      child: Text('Forgot your password?'),
                    ),
                  ),
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () => loginUser(authService, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  // Register Link
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don’t have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationPage()),
                            );
                          },
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(AuthService authService, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Attempt to log in the user
      ApiResponse apiResponse = await AuthService.login(email, password);

      if (apiResponse.successful) {
        AuthService.initSession(apiResponse);

        final user = apiResponse.data['user'];
        Role role = Role.values.byName(user['role']);
        if (role == Role.ADMIN) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()), // Admin page
          );
        } else if (role == Role.DOCTOR) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DoctorMainPage()), // Doctor page
          );
        } else if (role == Role.NURSE) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => NursePage()), // Doctor page
          );
        } else if (role == Role.PHARMACIST) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PharmacistMainPage()), // Doctor page
          );
        } else if (role == Role.RECEPTIONIST) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ReceptionistMainPage()), // Doctor page
          );
        } else if (role == Role.LAB) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LaboratoristPage()), // Doctor page
          );
        } else if (role == Role.PATIENT) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PatientMainPage()), // Doctor page
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()), // Main page
          );
        }
            } else {
        setState(() {
          _errorMessage = apiResponse.message ?? 'Login failed. Please check your credentials.';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Please fill in all required fields correctly';
      });
    }
  }

}
