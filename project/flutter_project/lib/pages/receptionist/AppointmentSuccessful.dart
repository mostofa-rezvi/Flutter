import 'package:flutter/material.dart';

class AppointmentSuccessful extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Successful"),
        automaticallyImplyLeading: false, // Removes the default back button
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text(
              "Your appointment has been successfully scheduled!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Thank you for booking with us. We look forward to seeing you!",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst); // Goes back to the first page
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Back to Home', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Icon(Icons.home, size: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
