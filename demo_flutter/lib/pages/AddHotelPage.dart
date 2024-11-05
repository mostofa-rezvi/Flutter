import 'dart:typed_data';

import 'package:demo_flutter/model/Hotel.dart';
import 'package:demo_flutter/model/Location.dart';
import 'package:demo_flutter/service/HotelService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddHotelPage extends StatefulWidget {
  const AddHotelPage({super.key});

  @override
  State<AddHotelPage> createState() => _AddHotelPageState();
}

class _AddHotelPageState extends State<AddHotelPage> {

  final _formkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Uint8List? _imageData;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  String _selectedRating = '3';

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = pickedFile;
          _imageData = bytes;
        });
      }
    } catch (exception) {
      print('Error picking image: $exception');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${exception.toString()}')),
      );
    }
  }

  Future<void> _saveHotel() async {
    if (_formkey.currentState!.validate() && _imageFile != null) {
      if (double.parse(_minPriceController.text) >
          double.parse(_maxPriceController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('Maximum price must be greater than minimum price.')),
        );
        return;
      }

      final hotel = Hotel(
        id: 0,
        name: _nameController.text,
        address: _addressController.text,
        rating: _selectedRating,
        minPrice: double.parse(_minPriceController.text),
        maxPrice: double.parse(_maxPriceController.text),
        image: '',
        location: Location(
            id: 1,
            name: 'Sample Location'
        ),
      );

      try {
        await HotelService().createHotel(hotel, _imageFile!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
              'Hotel added successfully!'
          )),
        );

        _nameController.clear();
        _addressController.clear();
        _minPriceController.clear();
        _maxPriceController.clear();
        _imageFile = null;
        _imageData = null;

        setState(() {});
      }
      catch (exception) {
        print(exception);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error adding hotel: ${exception.toString()}'),
          ),
        );
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:
        Text('Please complete the form and upload an image.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new hotel.'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
            key: _formkey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Hotel Name.'
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Enter Hotel Name'
                      : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Enter Address'
                      : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedRating,
                  items: ['1', '2', '3', '4', '5'].map(
                          (rating) =>
                          DropdownMenuItem(
                            value: rating,
                            child: Text('Rating: $rating'),
                          )).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedRating = value!),
                  decoration: InputDecoration(labelText: 'Rating'),
                ),
                TextFormField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Minimum Price'
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Enter minimum price'
                      : null,
                ),
                TextFormField(
                  controller: _maxPriceController,
                  decoration: InputDecoration(
                      labelText: 'Maximum Price'
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Enter maximum price'
                      : null,
                ),
                SizedBox(height: 16,),
                TextButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                  label: Text('Upload Image.'),
                ),
                if (_imageData != null)
                  Image.memory(
                    _imageData!,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 16,),
                ElevatedButton(
                    onPressed: _saveHotel,
                    child: Text('Save Hotel')
                ),
              ],
            )
        ),
      ),
    );
  }
}
