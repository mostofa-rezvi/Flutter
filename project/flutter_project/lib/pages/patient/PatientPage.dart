import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';
import 'package:flutter_project/pages/login/LoginPage.dart';

// Profile Info Card Widget
class ProfileInfoCard extends StatelessWidget {
  final String name;
  final int age;
  final String patientId;

  const ProfileInfoCard({required this.name, required this.age, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Patient: $name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Age: $age"),
            Text("Patient ID: $patientId"),
          ],
        ),
      ),
    );
  }
}

// Dashboard Card Widget
class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DashboardCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

// Main Patient Dashboard Page
class PatientDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Patient Dashboard")),
      body: Column(
        children: [
          // Profile Info Card at the top
          ProfileInfoCard(name: "Patient Name", age: 30, patientId: "P12345"),

          // Dashboard Cards in a Grid Layout
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  DashboardCard(
                    icon: Icons.medical_services,
                    label: "Appointments",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentsPage())),
                  ),
                  DashboardCard(
                    icon: Icons.history,
                    label: "Medical History",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalHistoryPage())),
                  ),
                  DashboardCard(
                    icon: Icons.local_hospital,
                    label: "Hospitals",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HospitalsPage())),
                  ),
                  DashboardCard(
                    icon: Icons.report,
                    label: "Reports",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsPage())),
                  ),
                  DashboardCard(
                    icon: Icons.chat_bubble,
                    label: "Consultations",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConsultationsPage())),
                  ),
                  DashboardCard(
                    icon: Icons.settings,
                    label: "Settings",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
                  ),
                ],
              ),
            ),
          ),

          // Logout Button at the bottom
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
    );
  }

}

// Placeholder for other page classes
class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Appointments")));
  }
}

class MedicalHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Medical History")));
  }
}

class HospitalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Hospitals")));
  }
}

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Reports")));
  }
}

class ConsultationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Consultations")));
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Settings")));
  }
}
