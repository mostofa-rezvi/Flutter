import 'package:demo_flutter/model/Hotel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelService {

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
}