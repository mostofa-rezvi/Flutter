import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';  // A new page to show basic profile info
import 'package:flutter_project/login/LoginPage.dart';
import 'package:flutter_project/pages/receptionist/AppointmentCreatePage.dart';

class ReceptionistDashboardPage extends StatefulWidget {
  @override
  _ReceptionistDashboardPageState createState() =>
      _ReceptionistDashboardPageState();
}

class _ReceptionistDashboardPageState extends State<ReceptionistDashboardPage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> dashboardItems = [
    {'icon': Icons.schedule, 'label': 'Appointments'},
    {'icon': Icons.people, 'label': 'Patients'},
    {'icon': Icons.account_box, 'label': 'Doctors'},
    {'icon': Icons.payment, 'label': 'Payments'},
    {'icon': Icons.notifications, 'label': 'Notifications'},
    {'icon': Icons.settings, 'label': 'Settings'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages() => [
    ProfilePage(profile: {},),
    // AppointmentHistoryPage(),
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
            ProfileCard(profile: {}),
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
                            builder: (context) => AppointmentCreatePage(),  // Navigate to appointment history page
                          ),
                        );
                      } else if (item['label'] == 'Settings') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(profile: {}),  // Navigate to Profile Page
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
            const SizedBox(height: 20),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',  // Changed to Appointments
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',  // Settings button to show profile info and logout
          ),
        ],
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


// class AppointmentHistoryPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Appointment History"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Here is the list of all appointments:',
//                 style: TextStyle(fontSize: 18),
//               ),
//               // You can display the appointment history here
//               // Example: Displaying some placeholder appointment data
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: 10, // Example number of appointments
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text("Appointment #${index + 1}"),
//                     subtitle: Text("Details of Appointment #${index + 1}"),
//                     trailing: Icon(Icons.arrow_forward),
//                     onTap: () {
//                       // Add navigation logic if needed (e.g., view details of a specific appointment)
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


class ProfilePage extends StatelessWidget {
  final Map<String, String> profile;

  const ProfilePage({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${profile['name']}', style: TextStyle(fontSize: 18)),
            Text('Role: ${profile['role']}', style: TextStyle(fontSize: 18)),
            Text('Email: ${profile['email']}', style: TextStyle(fontSize: 18)),
            Text('Phone: ${profile['phone']}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await AuthService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
