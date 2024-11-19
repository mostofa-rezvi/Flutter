class BillModel {
  int? id;
  String name;
  int phone;
  String email;
  String address;
  String? invoiceDate; // Represented as String to handle ISO 8601 date format
  int totalAmount;
  int amountPaid;
  int balance;
  String status;
  String description;
  int patientId; // Assuming patient is represented by their ID
  int doctorId; // Assuming doctor is represented by their ID
  int pharmacistId; // Assuming pharmacist is represented by their ID
  List<int>? medicineIds; // Medicine IDs
  String? createdAt;
  String? updatedAt;

  // Constructor
  BillModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    this.invoiceDate,
    required this.totalAmount,
    required this.amountPaid,
    required this.balance,
    required this.status,
    required this.description,
    required this.patientId,
    required this.doctorId,
    required this.pharmacistId,
    this.medicineIds,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create BillModel from a map (e.g., JSON data)
  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      invoiceDate: map['invoiceDate'],
      totalAmount: map['totalAmount'],
      amountPaid: map['amountPaid'],
      balance: map['balance'],
      status: map['status'],
      description: map['description'],
      patientId: map['patient']['id'],
      // Assuming nested structure for patient
      doctorId: map['doctor']['id'],
      // Assuming nested structure for doctor
      pharmacistId: map['pharmacist']['id'],
      // Assuming nested structure for pharmacist
      medicineIds: (map['medicineList'] as List?)
          ?.map((item) => item['id'] as int)
          .toList(),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  // Method to convert BillModel to a map (e.g., for sending to the backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'invoiceDate': invoiceDate,
      'totalAmount': totalAmount,
      'amountPaid': amountPaid,
      'balance': balance,
      'status': status,
      'description': description,
      'patient': {'id': patientId}, // Nested structure for patient
      'doctor': {'id': doctorId}, // Nested structure for doctor
      'pharmacist': {'id': pharmacistId}, // Nested structure for pharmacist
      'medicineList': medicineIds?.map((id) => {'id': id}).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
