import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:test_flutter/page/HomePage.dart';
import 'package:test_flutter/page/RegistrationPage.dart';

class LoginPage extends StatelessWidget {
  // const LoginPage({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final storage = new FlutterSecureStorage();

  LoginPage({super.key});

  Future<void> loginUser (BuildContext context) async {
    final url = Uri.parse('http://localhost:8080/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.text, 'password': password.text}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String sub = payload['sub'];
      String role = payload['role'];

      await storage.write(key: 'token', value: token);
      await storage.write(key: 'sub', value: sub);
      await storage.write(key: 'role', value: role);

      print('Login Successful. Sub: $sub, Role: $role');

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            SizedBox(
              height: 20,
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
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                // String em = email.text;
                // String pass = password.text;
                // print('Email: $em & Password: $pass');

                loginUser(context);

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.black,
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
              height: 20,
            ),
            TextButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage(),
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
