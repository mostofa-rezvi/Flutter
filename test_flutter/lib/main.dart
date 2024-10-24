import 'package:flutter/material.dart';
import 'package:test_flutter/page/RegistrationPage.dart';
import 'package:test_flutter/page/loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        // home: LoginPage()
        home: LoginPage()



    //     Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: const Text(
    //       "First Flutter",
    //       style: TextStyle(
    //         color: Colors.green,
    //       ),
    //     ),
    //   ),
    //   body: const Text("data"),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () => {},
    //     backgroundColor: Colors.amberAccent,
    //     child: const Icon(Icons.thumb_up, color: Colors.blueAccent),
    //   ),
    // )



    );
  }
}