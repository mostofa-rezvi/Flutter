import 'package:demo_flutter/model/Hotel.dart';
import 'package:demo_flutter/model/Room.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RoomService {

  Future<Hotel> fetchHotelById(int hotelId) async {
    final String apiUrl = 'http://localhost:8080/api/hotel/$hotelId';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Hotel.fromJson(data);
    }
    else {
      throw Exception('Failed to load hotel data');
    }
  }

  Future<List<Room>> fetchRoomsByHotelById(int hotelId) async {
    final String apiUrl = 'http://localhost:8080/api/room/r/searchroombyid?hotelid=$hotelId';

    try{
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if(data is List) {
          return data.map((room) => Room.fromJson(room as Map<String, dynamic>)).toList();
        }
        else if (data is Map) {
          return [Room.fromJson(data as Map<String, dynamic>)];
        }
        else {
          throw Exception('Unexpected data format');
        }
      }
      else {
        throw Exception('Failed to load room data: ${response.statusCode}');
      }
    }
    catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}