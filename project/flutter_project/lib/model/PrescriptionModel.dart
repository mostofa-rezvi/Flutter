

import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/model/TestModel.dart';
import 'package:flutter_project/model/UserModel.dart';

class PrescriptionModel {
  int id;
  DateTime prescriptionDate;
  String notes;
  DateTime createdAt;
  DateTime updatedAt;
  TestModel test;
  List<MedicineModel> medicine;
  UserModel user;

  // Constructor
  PrescriptionModel({
    required this.id,
    required this.prescriptionDate,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.test,
    required this.medicine,
    required this.user,
  });

  // Factory method to create PrescriptionModel from a map (e.g., JSON data)
  factory PrescriptionModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionModel(
      id: map['id'],
      prescriptionDate: DateTime.parse(map['prescriptionDate']),
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      test: TestModel.fromMap(map['test']),
      medicine: List<MedicineModel>.from(map['medicine']?.map((x) => MedicineModel.fromMap(x))),
      user: UserModel.fromMap(map['user']),
    );
  }

  // Method to convert PrescriptionModel to a map (e.g., for sending to the backend)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prescriptionDate': prescriptionDate.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'test': test.toMap(),
      'medicine': medicine.map((x) => x.toMap()).toList(),
      'user': user.toMap(),
    };
  }
}

extension on UserModel {
  toMap() {}
}
