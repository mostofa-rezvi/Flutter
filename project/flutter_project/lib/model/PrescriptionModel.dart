import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/model/TestModel.dart';
import 'package:flutter_project/model/UserModel.dart';

class PrescriptionModel {
  int? id;
  DateTime? prescriptionDate;
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;

  TestModel? test;
  MedicineModel? medicines;
  UserModel? issuedBy;
  UserModel? patient;

  PrescriptionModel({
    this.id,
    this.prescriptionDate,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.test,
    this.medicines,
    this.issuedBy,
    this.patient,
  });


// Adjusted fromJson and toJson for a single MedicineModel
  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'],
      prescriptionDate: json['prescriptionDate'] != null
          ? DateTime.parse(json['prescriptionDate'])
          : null,
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      test: json['test'] != null
          ? TestModel.fromJson(json['test'])
          : null,
      medicines: json['medicines'] != null
          ? MedicineModel.fromJson(json['medicines'])
          : null, // Single MedicineModel
      issuedBy: json['issuedBy'] != null
          ? UserModel.fromJson(json['issuedBy'])
          : null,
      patient: json['patient'] != null
          ? UserModel.fromJson(json['patient'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prescriptionDate': prescriptionDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'test': test?.toJson(),
      'medicines': medicines?.toJson(), // Single MedicineModel
      'issuedBy': issuedBy?.toJson(),
      'patient': patient?.toJson(),
    };
  }

}
