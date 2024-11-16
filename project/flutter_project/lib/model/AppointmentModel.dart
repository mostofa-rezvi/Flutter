import 'package:flutter_project/model/UserModel.dart';

class AppointmentModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? age;
  DateTime? birthday;
  DateTime? date;
  String? time;
  String? notes;

  UserModel? requestedBy;
  UserModel? doctor;

  AppointmentModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.age,
    this.birthday,
    this.date,
    this.time,
    this.notes,
    this.requestedBy,
    this.doctor,
  });

  // Factory constructor to create an instance from JSON
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      age: json['age'],
      birthday: DateTime.parse(json['birthday']),
      date: DateTime.parse(json['date']),
      time: json['time'],
      notes: json['notes'],
      requestedBy: json['requestedBy'] != null
          ? UserModel.fromJson(json['requestedBy'])
          : null,
      doctor: json['doctor'] != null
          ? UserModel.fromJson(json['doctor'])
          : null
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'age': age,
      'birthday': birthday?.toIso8601String(),
      'date': date?.toIso8601String(),
      'time': time,
      'notes': notes,
      'requestedBy': requestedBy?.toJson(),
      'doctor': doctor?.toJson(),
    };
  }
}
