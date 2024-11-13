import 'package:flutter/material.dart';
import 'package:flutter_project/login/LoginPage.dart';
import 'package:flutter_project/auth/AuthService.dart';
import 'package:flutter_project/pages/MainPage.dart';
import 'package:flutter_project/service/AppointmentService.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
          // child: Provider<AppointmentService>(create: (_) => AppointmentService(),
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

