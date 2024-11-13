import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';

class DoctorPage extends StatelessWidget {
  // Simulate user data from the database for the doctor
  final Map<String, String> doctorProfile = {
    'name': 'Dr. John Doe',
    'role': 'Doctor',
    'hospital': 'City Hospital',
    'email': 'john.doe@hospital.com',
    'phone': '987-654-3210'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Dashboard"),
        backgroundColor: Colors.greenAccent,
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
                          "Doctor",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Name: ${doctorProfile['name']}"),
                        Text("Role: ${doctorProfile['role']}"),
                        Text("Hospital: ${doctorProfile['hospital']}"),
                        Text("Email: ${doctorProfile['email']}"),
                        Text("Phone: ${doctorProfile['phone']}"),
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
                // Define the feature cards for the doctor role
                final List<Map<String, dynamic>> doctorFeatures = [
                  {'name': 'Patient Diagnosis', 'icon': Icons.local_hospital},
                  {'name': 'Prescription Management', 'icon': Icons.medical_services},
                  {'name': 'Medical History', 'icon': Icons.history},
                  {'name': 'Patient Care', 'icon': Icons.healing},
                  {'name': 'Medical Reports', 'icon': Icons.report},
                  {'name': 'Emergency Response', 'icon': Icons.warning},
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
                        color: Colors.greenAccent.shade100,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              doctorFeatures[index]['icon'],
                              size: 40,
                              color: Colors.black,
                            ),
                            SizedBox(height: 10),
                            Text(
                              doctorFeatures[index]['name'],
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
                backgroundColor: Colors.greenAccent.shade100,  // Set the background color to black
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
        backgroundColor: Colors.greenAccent,
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
    home: DoctorPage(),
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
