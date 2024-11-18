import 'package:flutter/material.dart';
import 'package:flutter_project/auth/AuthService.dart';
import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/model/UserModel.dart';
import 'package:flutter_project/login/LoginPage.dart';
import 'package:flutter_project/pages/common/Activities.dart';
import 'package:flutter_project/pages/common/Notification.dart';
import 'package:flutter_project/pages/common/Payroll.dart';
import 'package:flutter_project/pages/common/Salary.dart';
import 'package:flutter_project/pages/receptionist/ReceptionistMainPage.dart';
import 'package:flutter_project/service/MedicineService.dart';
import 'package:flutter_project/util/ApiResponse.dart';

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
    MedicineListScreen(),
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
                    'Prescription Management',
                    Icons.medical_services,
                    Colors.blueAccent,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlankPage())); // Update accordingly
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
                              builder: (context) => MedicineListScreen()));
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
                    'Payslip',
                    Icons.attach_money,
                    Colors.purpleAccent,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PayslipPage()));
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

class MedicineListScreen extends StatefulWidget {
  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MedicineService _medicineService = MedicineService();

  List<MedicineModel> medicines = [];
  List<MedicineModel> filteredMedicines = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      ApiResponse response = await _medicineService.getAllMedicines();
      if (response.successful) {
        final List<MedicineModel> fetchedMedicines = (response.data as List)
            .map((e) => MedicineModel.fromMap(e))
            .toList();
        setState(() {
          medicines = fetchedMedicines;
          filteredMedicines = medicines;
        });
      } else {
        _showError("Failed to load medicines.");
      }
    } catch (e) {
      _showError("An error occurred while fetching medicines.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // View Medicine Details function
  void _viewMedicineDetails(MedicineModel medicine) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${medicine.medicineName} Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Name: ${medicine.medicineName ?? ''}'),
                Text('Strength: ${medicine.medicineStrength ?? ''}'),
                Text('Price: \$${medicine.price?.toStringAsFixed(2) ?? ''}'),
                Text('Stock: ${medicine.stock ?? '' }'),
                Text('Description: ${medicine.instructions ?? ''}'),
                Text('Manufacturer: ${medicine.manufacturer ?? ''}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _searchMedicine(String query) {
    setState(() {
      filteredMedicines = medicines
          .where((medicine) =>
          medicine.medicineName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchMedicine,
              decoration: InputDecoration(
                hintText: 'Search medicines...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _fetchMedicines,
                    child: Text("Retry"),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: filteredMedicines.length,
              itemBuilder: (context, index) {
                final medicine = filteredMedicines[index];
                return ListTile(
                  title: Text(medicine.medicineName ?? ''),
                  subtitle: Text('Strength: ${medicine.medicineStrength ?? ''}'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => _viewMedicineDetails(medicine),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
