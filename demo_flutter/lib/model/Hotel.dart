import 'package:demo_flutter/model/Location.dart';

class Hotel {
  final int id;
  final String name;
  final String address;
  final String rating;
  final int minPrice;
  final int maxPrice;
  final String image;
  final Location location;

  Hotel(
      {required this.id,
      required this.name,
      required this.address,
      required this.rating,
      required this.minPrice,
      required this.maxPrice,
      required this.image,
      required this.location});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      rating: json['rating'],
      minPrice: json['minPrice'].toDouble(),
      maxPrice: json['maxPrice'].toDouble(),
      image: json['image'],
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'rating': rating,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'image': image,
      'location': location.toJson(),
    };
  }
}
