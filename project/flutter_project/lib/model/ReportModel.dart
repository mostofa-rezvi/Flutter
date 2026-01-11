import 'package:flutter_project/model/TestModel.dart';
import 'package:flutter_project/model/UserModel.dart';

class ReportModel {
  int? id;
  String? reportName;
  String? description;
  String? sampleId;
  String? reportResult;
  String? interpretation;
  UserModel? name;
  TestModel? testName;
  DateTime? testDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReportModel({
    this.id,
    this.reportName,
    this.description,
    this.sampleId,
    this.reportResult,
    this.interpretation,
    this.name,
    this.testName,
    this.testDate,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor for deserialization
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      reportName: json['reportName'],
      description: json['description'],
      sampleId: json['sampleId'],
      reportResult: json['reportResult'],
      interpretation: json['interpretation'],
      testDate: DateTime.parse(json['testDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      name: json['name'] != null ? UserModel.fromJson(json['name']) : null,
      testName: json['testName'] != null ? TestModel.fromJson(json['testName']) : null,
    );
  }

  /// Method for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportName': reportName,
      'description': description,
      'sampleId': sampleId,
      'reportResult': reportResult,
      'interpretation': interpretation,
      'testDate': testDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'name': name?.toJson(),
      'testName': testName?.toJson(),
    };
  }
}
