import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';
import 'package:flutter_project/pages/receptionist/AppointmentCreatePage.dart';
import 'package:flutter_project/pages/login/LoginPage.dart';

class ReceptionistDashboardPage extends StatelessWidget {
  final Map<String, String> receptionistProfile = {
    'name': 'Jane Doe',
    'role': 'Receptionist',
    'email': 'jane.doe@example.com',
    'phone': '+123 456 7890',
  };

  final List<Map<String, dynamic>> dashboardItems = [
    {'icon': Icons.schedule, 'label': 'Appointments'},
    {'icon': Icons.people, 'label': 'Patients'},
    {'icon': Icons.account_box, 'label': 'Doctors'},
    {'icon': Icons.payment, 'label': 'Payments'},
    {'icon': Icons.notifications, 'label': 'Notifications'},
    {'icon': Icons.settings, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receptionist Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCard(profile: receptionistProfile),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: dashboardItems.length,
                itemBuilder: (context, index) {
                  final item = dashboardItems[index];
                  return DashboardCard(
                    icon: item['icon'],
                    label: item['label'],
                    onTap: () {
                      if (item['label'] == 'Appointments') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentCreatePage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeaturePage(label: item['label']),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20), // Add spacing above the logout button
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

class ProfileCard extends StatelessWidget {
  final Map<String, String> profile;

  const ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(profile['name'] ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(profile['role'] ?? '', style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
            const SizedBox(height: 8),
            Text("Email: ${profile['email']}"),
            Text("Phone: ${profile['phone']}"),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DashboardCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class FeaturePage extends StatelessWidget {
  final String label;

  const FeaturePage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Center(
        child: Text("Welcome to the $label page!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

// class AppointmentCreatePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Appointment'),
//       ),
//       body: Center(
//         child: Text('Here you can create a new appointment!', style: TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }
