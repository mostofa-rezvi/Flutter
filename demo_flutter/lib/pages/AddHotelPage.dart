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

      // final hotel = Hotel(
      //   id: 0,
      //   name: _nameController.text,
      //   address: _addressController.text,
      //   rating: _selectedRating,
      //   minPrice: double.parse(_minPriceController.text),
      //   maxPrice: double.parse(_maxPriceController.text),
      //   image: '',
      //   location: Location(
      //       id: 1,
      //       name: 'Sample Location'
      //   ),
      // );

      // try {
      //   await HotelService().createHotel(hotelId, _imageFile!);
      //
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(
      //       'Hotel added successfully!'
      //     )),
      //   );
      //
      //
      // }
    }
  }











  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
