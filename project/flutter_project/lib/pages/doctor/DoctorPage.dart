import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';
import 'package:flutter_project/model/UserModel.dart';
import 'package:flutter_project/login/LoginPage.dart';
import 'package:flutter_project/pages/common/Activities.dart';
import 'package:flutter_project/pages/common/Notification.dart';
import 'package:flutter_project/pages/common/Salary.dart';
import 'package:flutter_project/pages/doctor/PrescriptionCreatePage.dart';
import 'package:flutter_project/pages/receptionist/AppointmentCreatePage.dart';
import 'package:flutter_project/pages/receptionist/AppointmentHistoryPage.dart';
import 'package:flutter_project/pages/receptionist/ReceptionistMainPage.dart'; // New page for appointment history

class DoctorMainPage extends StatefulWidget {
  @override
  _DoctorMainPageState createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<DoctorMainPage> {
  int _selectedIndex = 0;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    userModel = await AuthService.getStoredUser();
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Updated _pages to reflect doctor's responsibilities
  List<Widget> _pages() => [
    DoctorHomeScreen(userModel: userModel),
    AppointmentList(),  // Manage appointment history
    // PrescriptionPage(),  // Manage prescriptions
    SettingsScreen(userModel: userModel),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Dashboard"),
        centerTitle: true,
      ),
      body: _pages()[_selectedIndex],
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
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class DoctorHomeScreen extends StatefulWidget {
  final UserModel? userModel;

  DoctorHomeScreen({this.userModel});

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Text(
              'Welcome, Dr. ${widget.userModel?.name}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Manage your appointments, prescriptions, and patient history.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Create cards for doctor's tasks
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              padding: EdgeInsets.all(20),
              children: [
                _buildCard('Patient History', Icons.person, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlankPage()),
                  );
                }),
                _buildCard('Schedule Appointment', Icons.calendar_today, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppointmentCreatePage()),
                  );
                }),
                _buildCard('Prescriptions', Icons.assignment, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrescriptionCreatePage()),
                  );
                }),
                _buildCard('Activities', Icons.local_activity, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ActivitiesPage()),
                  );
                }),
                _buildCard('Notifications', Icons.notifications, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                }),
                _buildCard('Salary Calculator', Icons.calculate, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalarySettingsPage()),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final UserModel? userModel;

  SettingsScreen({this.userModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${userModel?.name ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Email: ${userModel?.email ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
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
