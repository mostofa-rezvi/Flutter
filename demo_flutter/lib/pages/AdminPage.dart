import 'package:demo_flutter/pages/LoginPage.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                'Welcome, Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20,),
            ElevatedButton.icon(
                onPressed: () {
                  print("View Users Clicked");
                },
                label: Text('View Users'),
              icon: Icon(Icons.people),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton.icon(
                onPressed: (){
                  print('Manage Hotels Clicked');
                },
                icon: Icon(Icons.hotel),
                label: Text('Manage Hotels'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
            ),
            SizedBox(height: 10,),
            ElevatedButton.icon(
                onPressed: () {
                  print('Settings Clicked');
                },
                label: Text('Settings'),
              icon: Icon(Icons.settings),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(),
                      ),
                  );
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
