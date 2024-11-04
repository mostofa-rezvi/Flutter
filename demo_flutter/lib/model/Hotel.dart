import 'package:demo_flutter/model/Location.dart';

class Hotel {
  int? id;
  String? name;
  String? address;
  String? rating;
  int? minPrice;
  int? maxPrice;
  String? image;
  Location? location;

  Hotel(
      {this.id,
      this.name,
      this.address,
      this.rating,
      this.minPrice,
      this.maxPrice,
      this.image,
      this.location});

  Hotel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    address = json['address'];
    rating = json['rating'];
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    image = json['image'];
    location = json['location'] != null? new Location.fromJson(json['location']): null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['rating'] = this.rating;
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    data['image'] = this.image;

    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }

    return data;
  }
}
