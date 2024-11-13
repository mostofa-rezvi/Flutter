import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';
import 'package:flutter_project/login/LoginPage.dart';

class PharmacistPage extends StatelessWidget {
  // Function to navigate to each feature's specific page
  void navigateToFeature(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacist Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Info Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pharmacist: User Name',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Email: pha@gmail.com',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 4),
                    Text('Phone: +123 456 7890',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Dashboard Feature Cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  DashboardCard(
                      icon: Icons.medical_services,
                      label: 'Medicines',
                      onTap: () => navigateToFeature(
                          context,
                          MedicineView(
                              medicineName: "Amoxicillin",
                              strength: "500mg",
                              instructions: "Take twice daily"))),
                  DashboardCard(
                      icon: Icons.people,
                      label: 'Patients',
                      onTap: () => navigateToFeature(
                          context, PlaceholderPage(label: 'Patients'))),
                  DashboardCard(
                      icon: Icons.receipt_long,
                      label: 'Prescriptions',
                      onTap: () => navigateToFeature(
                          context, PlaceholderPage(label: 'Prescriptions'))),
                  DashboardCard(
                      icon: Icons.history,
                      label: 'Order History',
                      onTap: () => navigateToFeature(
                          context, PlaceholderPage(label: 'Order History'))),
                  DashboardCard(
                      icon: Icons.notifications,
                      label: 'Notifications',
                      onTap: () => navigateToFeature(
                          context, PlaceholderPage(label: 'Notifications'))),
                  DashboardCard(
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () => navigateToFeature(
                          context, PlaceholderPage(label: 'Settings'))),
                ],
              ),
            ),

            // Logout Button
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await AuthService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Card Widget for Dashboard Features
class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onTap;

  DashboardCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        color: Colors.lightBlue[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// Unique Medicine View UI Design
class MedicineView extends StatelessWidget {
  final String medicineName;
  final String strength;
  final String instructions;

  MedicineView(
      {required this.medicineName,
      required this.strength,
      required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medicine Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.teal[50],
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicineName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Strength: $strength",
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                ),
                SizedBox(height: 8),
                Text(
                  "Instructions:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  instructions,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder page for navigation examples
class PlaceholderPage extends StatelessWidget {
  final String label;

  PlaceholderPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Center(
        child: Text(
          '$label Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
