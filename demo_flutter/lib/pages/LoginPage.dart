import 'dart:convert';

import 'package:demo_flutter/pages/AdminPage.dart';
import 'package:demo_flutter/pages/AllHotelViewPage.dart';
import 'package:demo_flutter/pages/HomePage.dart';
import 'package:demo_flutter/pages/HotelProfilePage.dart';
import 'package:demo_flutter/pages/RegistrationPage.dart';
import 'package:demo_flutter/service/AuthService.dart';
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
  AuthService authService = AuthService();

  Future<void> loginUser(BuildContext context) async {
    try {
      final response = await authService.login(email.text, password.text);
      final role = await authService.getUserRole();

      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else if (role == 'HOTEL') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HotelProfilePage(
                      hotelName: 'Grand Plaza',
                      hotelImageUrl:
                          'http://localhost:8080/images/hotel/The Hotel One_a39545ad-787f-42cc-8bf3-ff352f25a520',
                      address: 'Coxs Bazar',
                      rating: '3',
                      minPrice: 5000,
                      maxPrice: 23000,
                    )));
      } else if (role == 'USER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllHotelViewPage()),
        );
      } else {
        print('Unknown role: $role');
      }
    } catch (error) {
      print('Login Falied: $error');
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
                loginUser(context);
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
            SizedBox(
              height: 25,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
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
