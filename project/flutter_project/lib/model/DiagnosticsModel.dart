class DiagnosticsModel {
  int? id;
  String? testDate; // Represented as String to handle ISO 8601 format
  String testResult;
  int price;
  int doctorId; // Assuming doctor is represented by their ID
  int patientId; // Assuming patient is represented by their ID
  String? createdAt;
  String? updatedAt;

  // Constructor
  DiagnosticsModel({
    this.id,
    this.testDate,
    required this.testResult,
    required this.price,
    required this.doctorId,
    required this.patientId,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create DiagnosticsModel from a map (e.g., JSON data)
  factory DiagnosticsModel.fromMap(Map<String, dynamic> map) {
    return DiagnosticsModel(
      id: map['id'],
      testDate: map['testDate'],
      testResult: map['testResult'],
      price: map['price'],
      doctorId: map['doctor']['id'],
      // Assuming nested structure for doctor
      patientId: map['patient']['id'],
      // Assuming nested structure for patient
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  // Method to convert DiagnosticsModel to a map (e.g., for sending to the backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testDate': testDate,
      'testResult': testResult,
      'price': price,
      'doctor': {'id': doctorId}, // Nested structure for doctor
      'patient': {'id': patientId}, // Nested structure for patient
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
