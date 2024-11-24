import 'package:flutter_project/model/MedicineModel.dart';
import 'package:flutter_project/model/TestModel.dart';
import 'package:flutter_project/model/UserModel.dart';

class PrescriptionModel {
  int? id;
  DateTime? prescriptionDate;
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;

  List<TestModel>? test;
  List<MedicineModel>? medicineName;
  List<UserModel>? issuedBy;
  List<UserModel>? patient;

  PrescriptionModel({
    this.id,
    this.prescriptionDate,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.test,
    this.medicineName,
    this.issuedBy,
    this.patient,
  });

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
          ? (json['test'] as List)
          .map((item) => TestModel.fromJson(item))
          .toList()
          : null,
      medicineName: json['medicines'] != null
          ? (json['medicines'] as List)
          .map((item) => MedicineModel.fromJson(item))
          .toList()
          : null,
      issuedBy: json['issuedBy'] != null
          ? (json['issuedBy'] as List)
          .map((item) => UserModel.fromJson(item))
          .toList()
          : null,
      patient: json['patient'] != null
          ? (json['patient'] as List)
          .map((item) => UserModel.fromJson(item))
          .toList()
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
      'test': test?.map((item) => item.toJson()).toList(),
      'medicines': medicineName?.map((item) => item.toJson()).toList(),
      'issuedBy': issuedBy?.map((item) => item.toJson()).toList(),
      'patient': patient?.map((item) => item.toJson()).toList(),
    };
  }
}
