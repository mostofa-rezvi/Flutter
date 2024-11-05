import 'package:demo_flutter/model/Hotel.dart';
import 'package:demo_flutter/service/AuthService.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class HotelService {

  final Dio _dio = Dio();
  final AuthService authService = AuthService();

  final String apiUrl = 'http://localhost:8080/api/hotel/';

  Future<List<Hotel>> fetchHotels() async {
    final response = await http.get(Uri.parse(apiUrl));

    print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> hotelJson = json.decode(response.body);

      return hotelJson.map((json) => Hotel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hotels');
    }
  }

  Future<Hotel?> createHotel(Hotel hotel, XFile? image) async {
    final formData = FormData();

    formData.fields.add(MapEntry('hotel', jsonEncode(hotel.toJson())));

    if (image != null) {
      final bytes = await image.readAsBytes();

      formData.files.add(MapEntry('image', MultipartFile.fromBytes(bytes, filename: image.name)));
    }

    final token = await authService.getToken();
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await _dio.post(
        '${apiUrl}save',
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        return Hotel.fromJson(data);
      }
      else {
        print('Error creating hotel: ${response.statusCode}');
        return null;
      }
    }
    on DioError catch (exception) {
      print('Error creating hotel: ${exception.message}');
      return null;
    }
  }
}