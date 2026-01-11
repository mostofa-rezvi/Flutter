import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';

class NursePage extends StatelessWidget {
  // Simulate user data from the database
  final Map<String, String> nurseProfile = {
    'name': 'Nurse Alice',
    'role': 'Nurse',
    'hospital': 'City Hospital',
    'email': 'alice@hospital.com',
    'phone': '123-456-7890'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nurse Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 106),
                child: Card(
                  margin: EdgeInsets.all(0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Name: ${nurseProfile['name']}"),
                        Text("Role: ${nurseProfile['role']}"),
                        Text("Hospital: ${nurseProfile['hospital']}"),
                        Text("Email: ${nurseProfile['email']}"),
                        Text("Phone: ${nurseProfile['phone']}"),
                      ],
                    ),
                  ),
                ),
              ),

            ),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final List<Map<String, dynamic>> nurseFeatures = [
                  {'name': 'Patient Monitoring', 'icon': Icons.accessibility_new},
                  {'name': 'Medication', 'icon': Icons.medication},
                  {'name': 'Vitals Check', 'icon': Icons.favorite},
                  {'name': 'Shift Schedule', 'icon': Icons.schedule},
                  {'name': 'Emergency Care', 'icon': Icons.warning},
                  {'name': 'Report Management', 'icon': Icons.report},
                ];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(index: index),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blueAccent.shade100,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              nurseFeatures[index]['icon'],
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              nurseFeatures[index]['name'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
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

class DetailPage extends StatelessWidget {
  final int index;

  const DetailPage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feature ${index + 1} Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          "Detail page for Feature ${index + 1}",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NursePage(),
    routes: {
      '/login': (context) => LoginPage(),
    },
  ));
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Center(child: Text("Login Here")),
    );
  }
}
