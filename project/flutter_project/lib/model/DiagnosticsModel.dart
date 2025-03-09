class DiagnosticsModel {
  int? id;
  String? testDate;
  String testResult;
  int price;
  int doctorId;
  int patientId;
  String? createdAt;
  String? updatedAt;

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

  factory DiagnosticsModel.fromMap(Map<String, dynamic> map) {
    return DiagnosticsModel(
      id: map['id'],
      testDate: map['testDate'],
      testResult: map['testResult'],
      price: map['price'],
      doctorId: map['doctor']['id'],
      patientId: map['patient']['id'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testDate': testDate,
      'testResult': testResult,
      'price': price,
      'doctor': {'id': doctorId},
      'patient': {'id': patientId},
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
