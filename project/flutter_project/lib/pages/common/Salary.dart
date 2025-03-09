import 'package:flutter/material.dart';

class SalarySettingsPage extends StatefulWidget {
  const SalarySettingsPage({super.key});

  @override
  _SalarySettingsPageState createState() => _SalarySettingsPageState();
}

class _SalarySettingsPageState extends State<SalarySettingsPage> {
  final TextEditingController _basicSalaryController = TextEditingController();
  final TextEditingController _daController = TextEditingController();
  final TextEditingController _hraController = TextEditingController();
  final TextEditingController _pfEmployeeShareController = TextEditingController();
  final TextEditingController _pfOrgShareController = TextEditingController();
  final TextEditingController _esiEmployeeShareController = TextEditingController();
  final TextEditingController _esiOrgShareController = TextEditingController();

  double _netSalary = 0.0;

  void _calculateSalary() {
    final double basicSalary = double.tryParse(_basicSalaryController.text) ?? 0.0;
    final double daPercentage = double.tryParse(_daController.text) ?? 0.0;
    final double hraPercentage = double.tryParse(_hraController.text) ?? 0.0;
    final double pfEmployeeSharePercentage = double.tryParse(_pfEmployeeShareController.text) ?? 0.0;
    final double pfOrgSharePercentage = double.tryParse(_pfOrgShareController.text) ?? 0.0;
    final double esiEmployeeSharePercentage = double.tryParse(_esiEmployeeShareController.text) ?? 0.0;
    final double esiOrgSharePercentage = double.tryParse(_esiOrgShareController.text) ?? 0.0;

    final double daAmount = basicSalary * (daPercentage / 100);
    final double hraAmount = basicSalary * (hraPercentage / 100);
    final double pfEmployeeShare = basicSalary * (pfEmployeeSharePercentage / 100);
    final double pfOrgShare = basicSalary * (pfOrgSharePercentage / 100);
    final double esiEmployeeShare = basicSalary * (esiEmployeeSharePercentage / 100);
    final double esiOrgShare = basicSalary * (esiOrgSharePercentage / 100);

    final double totalEarnings = basicSalary + daAmount + hraAmount;
    final double totalDeductions = pfEmployeeShare + pfOrgShare + esiEmployeeShare + esiOrgShare;

    setState(() {
      _netSalary = totalEarnings - totalDeductions;
    });
  }

  @override
  void dispose() {
    _basicSalaryController.dispose();
    _daController.dispose();
    _hraController.dispose();
    _pfEmployeeShareController.dispose();
    _pfOrgShareController.dispose();
    _esiEmployeeShareController.dispose();
    _esiOrgShareController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Salary Settings',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              _buildSectionHeader('Basic Salary Details'),
              _buildTextField(
                label: 'Basic Salary',
                controller: _basicSalaryController,
                onChanged: (value) => _calculateSalary(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'DA (%)',
                      controller: _daController,
                      onChanged: (value) => _calculateSalary(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'HRA (%)',
                      controller: _hraController,
                      onChanged: (value) => _calculateSalary(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Provident Fund Settings'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Employee Share (%)',
                      controller: _pfEmployeeShareController,
                      onChanged: (value) => _calculateSalary(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'Organization Share (%)',
                      controller: _pfOrgShareController,
                      onChanged: (value) => _calculateSalary(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('ESI Settings'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Employee Share (%)',
                      controller: _esiEmployeeShareController,
                      onChanged: (value) => _calculateSalary(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'Organization Share (%)',
                      controller: _esiOrgShareController,
                      onChanged: (value) => _calculateSalary(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text(
                    'Net Salary: \$${_netSalary.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
    );
  }
}
