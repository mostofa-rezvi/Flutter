class ReportModel {
  int? id;
  String reportName;
  String description;
  String sampleId;
  String reportResult;
  String interpretation;
  int patientId; // Assuming patient ID is an integer
  int testId; // Assuming test entity ID is an integer
  String? testDate;
  String? createdAt;
  String? updatedAt;

  // Constructor
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

  // Factory method to create ReportModel from a map (e.g., JSON data)
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'],
      reportName: map['reportName'],
      description: map['description'],
      sampleId: map['sampleId'],
      reportResult: map['reportResult'],
      interpretation: map['interpretation'],
      patientId: map['patient']['id'],
      // Assuming nested structure for patient
      testId: map['testEntity']['id'],
      // Assuming nested structure for testEntity
      testDate: map['testDate'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  // Method to convert ReportModel to a map (e.g., for sending to the backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportName': reportName,
      'description': description,
      'sampleId': sampleId,
      'reportResult': reportResult,
      'interpretation': interpretation,
      'patient': {'id': patientId}, // Nested structure for patient
      'testEntity': {'id': testId}, // Nested structure for testEntity
      'testDate': testDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
