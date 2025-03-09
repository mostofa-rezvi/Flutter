import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';
import 'package:flutter_project/login/LoginPage.dart';
import 'package:flutter_project/model/UserModel.dart';
import 'package:flutter_project/pages/common/Notification.dart';
import 'package:flutter_project/pages/common/Salary.dart';
import 'package:flutter_project/pages/laboratorist/ReportCreatePage.dart';
import 'package:flutter_project/pages/laboratorist/ReportListPage.dart';
import 'package:flutter_project/pages/laboratorist/TestCreatePage.dart';
import 'package:flutter_project/pages/laboratorist/TestListPage.dart';

class LaboratoristPage extends StatefulWidget {
  @override
  _LaboratoristPageState createState() => _LaboratoristPageState();
}

class _LaboratoristPageState extends State<LaboratoristPage> {
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

  List<Widget> _pages() => [
    LaboratoristHomeScreen(userModel: userModel),
    SettingsScreen(userModel: userModel),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laboratorist Dashboard"),
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
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class LaboratoristHomeScreen extends StatelessWidget {
  final UserModel? userModel;

  LaboratoristHomeScreen({this.userModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Welcome, ${userModel?.name ?? 'Laboratorist'}!',
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 600,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                padding: const EdgeInsets.all(20),
                children: [
                  _buildCard(
                    'All Reports',
                    Icons.file_copy,
                    Colors.blueAccent,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReportListPage()),
                      );
                    },
                  ),
                  _buildCard(
                    'Create Report',
                    Icons.add_box,
                    Colors.purpleAccent,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReportCreatePage()),
                      );
                    },
                  ),
                  _buildCard(
                    'All Tests',
                    Icons.list,
                    Colors.orange,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TestListPage()),
                      );
                    },
                  ),
                  _buildCard(
                    'Create Test',
                    Icons.add_circle,
                    Colors.greenAccent,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TestCreatePage()),
                      );
                    },
                  ),
                  _buildCard(
                    'Notifications',
                    Icons.notifications,
                    Colors.red,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage()),
                      );
                    },
                  ),
                  _buildCard(
                    'Salary',
                    Icons.calculate,
                    Colors.blueAccent,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalarySettingsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
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
              Icon(icon, size: 40, color: color),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blank Page'),
      ),
      body: Center(child: Text('This is a blank page.')),
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