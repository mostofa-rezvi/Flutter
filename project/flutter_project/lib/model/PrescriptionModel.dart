import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/model/TestModel.dart';
import 'package:flutter_project/model/UserModel.dart';

class PrescriptionModel {
  String? id;
  DateTime? prescriptionDate;
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;
  TestModel? test;
  List<MedicineModel>? medicines;
  UserModel? issuedBy; // Doctor issuing the prescription
  UserModel? patient; // Patient receiving the prescription

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

  // Factory constructor to create an instance from JSON
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
      test: json['test'] != null ? TestModel.fromJson(json['test']) : null,
      medicines: json['medicines'] != null
          ? List<MedicineModel>.from(
          json['medicines'].map((x) => MedicineModel.fromJson(x)))
          : null,
      issuedBy: json['issuedBy'] != null
          ? UserModel.fromJson(json['issuedBy'])
          : null,
      patient: json['patient'] != null
          ? UserModel.fromJson(json['patient'])
          : null,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prescriptionDate': prescriptionDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'test': test?.toJson(),
      'medicines': medicines?.map((x) => x.toJson()).toList(),
      'issuedBy': issuedBy?.toJson(),
      'patient': patient?.toJson(),
    };
  }
}
