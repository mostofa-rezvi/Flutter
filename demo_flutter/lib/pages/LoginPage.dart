import 'dart:convert';

import 'package:demo_flutter/pages/HomePage.dart';
import 'package:demo_flutter/pages/RegistrationPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final storage = new FlutterSecureStorage();

  Future<void> loginUser(BuildContext context) async {
    final url = Uri.parse('');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.text, 'password': password.text}),
    );

    if (response.statusCode == 200) {
      final responseDate = jsonDecode(response.body);
      final token = responseDate['token'];

      Map<String, dynamic> payload = Jwt.parseJwt(token);

      String subject = payload['subject'];
      String role = payload['role'];

      await storage.write(key: 'token', value: token);
      await storage.write(key: 'subject', value: subject);
      await storage.write(key: 'role', value: role);

      print('Login Successful, Subject: $subject, Role: $role');

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
      );
    }
    else {
      print('Login failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {
                String uEmail = email.text;
                String uPassword = password.text;

                print('Email: $uEmail, Password: $uPassword');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.lato().fontFamily,
                ),
              ),
            ),
            SizedBox(height: 25,),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationPage()
                      ),
                  );
                },
                child: Text(
                  'Registration',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
