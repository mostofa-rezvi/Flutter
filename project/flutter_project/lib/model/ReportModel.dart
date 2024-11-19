class ReportModel {
  int? id;
  String reportName;
  String description;
  String sampleId;
  String reportResult;
  String interpretation;
  int patientId;
  int testId;
  String? testDate;
  String? createdAt;
  String? updatedAt;

  ReportModel({
    this.id,
    required this.reportName,
    required this.description,
    required this.sampleId,
    required this.reportResult,
    required this.interpretation,
    required this.patientId,
    required this.testId,
    this.testDate,
    this.createdAt,
    this.updatedAt,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'],
      reportName: map['reportName'],
      description: map['description'],
      sampleId: map['sampleId'],
      reportResult: map['reportResult'],
      interpretation: map['interpretation'],
      patientId: map['patient']['id'],
      testId: map['testEntity']['id'],
      testDate: map['testDate'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportName': reportName,
      'description': description,
      'sampleId': sampleId,
      'reportResult': reportResult,
      'interpretation': interpretation,
      'patient': {'id': patientId},
      'testEntity': {'id': testId},
      'testDate': testDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
