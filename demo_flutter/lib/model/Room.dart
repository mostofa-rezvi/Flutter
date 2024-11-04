import 'package:demo_flutter/model/Hotel.dart';

class Room {
  final int id;
  final String roomType;
  final String image;
  final double price;
  final int area;
  final int adultNo;
  final int childNo;
  final bool availability;
  final Hotel hotel;

  Room({
    required this.id,
    required this.roomType,
    required this.image,
    required this.price,
    required this.area,
    required this.adultNo,
    required this.childNo,
    required this.availability,
    required this.hotel,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
        id: json['id'],
        roomType: json['roomType'],
        image: json['image'],
        price: json['price'],
        area: json['area'],
        adultNo: json['adultNo'],
        childNo: json['childNo'],
        availability: json['availability'],
        hotel: Hotel.fromJson(json['hotel']),
    );
  }
}
