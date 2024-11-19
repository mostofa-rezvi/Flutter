import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cellController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _birthday;
  String? _gender;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userData = {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "cell": _cellController.text,
        "age": int.parse(_ageController.text),
        "gender": _gender,
        "birthday": _birthday?.toIso8601String(),
        "address": _addressController.text,
        "role": "PATIENT",
      };

      final uri = Uri.parse("http://localhost:8080/api/user/saveUser");
      final request = http.MultipartRequest("POST", uri)
        ..fields['user'] = jsonEncode(userData);

      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _selectedImage!.path,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful!")),
        );
        Navigator.of(context).pushReplacementNamed("/login");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed. Please try again.")),
        );
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: validator ?? (value) => value == null || value.isEmpty ? "Please enter your $label" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _buildTextField("Name", _nameController, TextInputType.name),
              SizedBox(height: 16.0),

              _buildTextField("Email", _emailController, TextInputType.emailAddress, validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                } else if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
                  return "Please enter a valid email";
                }
                return null;
              }),
              SizedBox(height: 16.0),

              _buildTextField("Password", _passwordController, TextInputType.text, obscureText: true),
              SizedBox(height: 16.0),

              _buildTextField("Cell", _cellController, TextInputType.phone),
              SizedBox(height: 16.0),

              _buildTextField("Age", _ageController, TextInputType.number),
              SizedBox(height: 16.0),

              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                items: ["MALE", "FEMALE"].map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _gender = value),
                validator: (value) => value == null ? "Please select your gender" : null,
              ),
              SizedBox(height: 16.0),

              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Birthday",
                  hintText: _birthday == null
                      ? "Select your birthday"
                      : "${_birthday!.year}-${_birthday!.month}-${_birthday!.day}",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() => _birthday = pickedDate);
                  }
                },
              ),
              SizedBox(height: 16.0),

              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),

              Row(
                children: [
                  Text("Profile Image:", style: TextStyle(fontSize: 16)),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text("Choose File"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.file(
                      _selectedImage!,
                      height: 100,
                    ),
                  ),
                ),
              SizedBox(height: 24.0),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Register"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
