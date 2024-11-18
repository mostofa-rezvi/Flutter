import 'package:flutter/material.dart';
import 'package:flutter_project/login/LoginPage.dart';
import 'package:flutter_project/auth/AuthService.dart';
import 'package:flutter_project/pages/MainPage.dart';
import 'package:flutter_project/service/AppointmentService.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<AppointmentService>(
          create: (_) => AppointmentService(httpClient: http.Client()),
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/main': (context) => MainPage(),
      },
    );
  }
}

