import 'package:flutter/material.dart';
import 'package:flutter_project/pages/ForgetPasswordPage.dart';
import 'package:flutter_project/pages/MainPage.dart';
import 'package:flutter_project/pages/RegistrationPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/service/AuthService.dart';
// import 'package:flutter_project/pages/AdminPage.dart'; // Import different role pages
// import 'package:flutter_project/pages/DoctorPage.dart'; // Import different role pages

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
      bool loginSuccess = await authService.login(email, password);

      if (loginSuccess) {
        // Get user role to navigate to the appropriate page
        String? role = await authService.getUserRole();

        if (role == 'ADMIN') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()), // Admin page
          );
        } else if (role == 'DOCTOR') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()), // Doctor page
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()), // Main page (default)
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please check your credentials.';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Please fill in all required fields correctly';
      });
    }
  }
}
