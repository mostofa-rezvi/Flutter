import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';

class LaboratoristPage extends StatelessWidget {
  // Simulate user data from the database for the laboratorist
  final Map<String, String> laboratoristProfile = {
    'name': 'Dr. Alice Smith',
    'role': 'Laboratorist',
    'hospital': 'City Hospital',
    'email': 'alice.smith@hospital.com',
    'phone': '123-456-7890'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laboratorist Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Full-width Profile info card section
            Card(
              margin: EdgeInsets.all(16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 106), // Adjust padding
                child: Card(
                  margin: EdgeInsets.all(0),  // Remove any margin if needed
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
                          "Laboratorist",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Name: ${laboratoristProfile['name']}"),
                        Text("Role: ${laboratoristProfile['role']}"),
                        Text("Hospital: ${laboratoristProfile['hospital']}"),
                        Text("Email: ${laboratoristProfile['email']}"),
                        Text("Phone: ${laboratoristProfile['phone']}"),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Cart/Feature Cards Section
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
                // Define the feature cards for the laboratorist role
                final List<Map<String, dynamic>> laboratoristFeatures = [
                  {'name': 'Sample Collection', 'icon': Icons.speaker_notes},
                  {'name': 'Test Analysis', 'icon': Icons.analytics},
                  {'name': 'Medical Reports', 'icon': Icons.report},
                  {'name': 'Lab Equipment', 'icon': Icons.build},
                  {'name': 'Patient Records', 'icon': Icons.receipt},
                  {'name': 'Lab Inventory', 'icon': Icons.inventory},
                ];

                return GestureDetector(
                  onTap: () {
                    // Navigate to the specific page on click
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
                              laboratoristFeatures[index]['icon'],
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              laboratoristFeatures[index]['name'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,  // Changed text color to black
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
            // Logout Button
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
                backgroundColor: Colors.blueAccent.shade100,  // Set the background color to black
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black, // Set text color to white for contrast
                ),
              ),
            )
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
    home: LaboratoristPage(),
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
