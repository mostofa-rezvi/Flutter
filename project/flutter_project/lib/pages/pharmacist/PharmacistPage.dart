import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';
import 'package:flutter_project/model/UserModel.dart';
import 'package:flutter_project/pages/common/Activities.dart';
import 'package:flutter_project/pages/common/Notification.dart';
import 'package:flutter_project/pages/common/Salary.dart';
import 'package:flutter_project/pages/pharmacist/MedicineBillListPage.dart';
import 'package:flutter_project/pages/pharmacist/MedicineBillPage.dart';
import 'package:flutter_project/pages/pharmacist/MedicineListPage.dart';
import 'package:flutter_project/pages/receptionist/ReceptionistMainPage.dart';

class PharmacistMainPage extends StatefulWidget {
  @override
  _PharmacistMainPageState createState() => _PharmacistMainPageState();
}

class _PharmacistMainPageState extends State<PharmacistMainPage> {
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
    PharmacistHomeScreen(userModel: userModel),
    MedicineListPage(),
    SettingsScreen(userModel: userModel),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pharmacist Dashboard"),
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
            icon: Icon(Icons.medical_services),
            label: 'Medicine List',
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

class PharmacistHomeScreen extends StatelessWidget {
  final UserModel? userModel;

  PharmacistHomeScreen({this.userModel});

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
                'Welcome, ${userModel?.name ?? 'Pharmacist'}!',
                style:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    'Medicine Bill',
                    Icons.medical_services,
                    Colors.blueAccent,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MedicineBillPage()));
                    },
                  ),
                  _buildCard(
                    'Bill List',
                    Icons.attach_money,
                    Colors.purpleAccent,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MedicineBillListPage()));
                    },
                  ),
                  _buildCard(
                    'Activities',
                    Icons.local_activity,
                    Colors.orange,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActivitiesPage()));
                    },
                  ),
                  _buildCard(
                    'View Medicines',
                    Icons.local_pharmacy,
                    Colors.greenAccent,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MedicineListPage()));
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
                              builder: (context) => NotificationPage()));
                    },
                  ),
                  _buildCard(
                    'Salary Calculator',
                    Icons.calculate,
                    Colors.blueAccent,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalarySettingsPage()));
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