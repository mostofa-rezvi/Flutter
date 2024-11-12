import 'package:flutter_project/model/UserModel.dart';

class AppointmentModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  int? age;
  DateTime? birthday;
  DateTime? date;
  String? time;
  String? notes;

  UserModel requestedBy;
  UserModel doctor;

  AppointmentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.age,
    required this.birthday,
    required this.date,
    required this.time,
    required this.notes,
    required this.requestedBy,
    required this.doctor,
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
      requestedBy: UserModel.fromJson(json['requestedBy']),
      doctor: UserModel.fromJson(json['doctor']),
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
      'requestedBy': requestedBy.toJson(),
      'doctor': doctor.toJson(),
    };
  }
}
