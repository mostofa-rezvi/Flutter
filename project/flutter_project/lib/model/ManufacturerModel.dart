class ManufacturerModel {
  int id;
  String manufacturerName;
  String address;
  String contactNumber;
  String email;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructor
  ManufacturerModel({
    required this.id,
    required this.manufacturerName,
    required this.address,
    required this.contactNumber,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create ManufacturerModel from a map (e.g., JSON data)
  factory ManufacturerModel.fromMap(Map<String, dynamic> map) {
    return ManufacturerModel(
      id: map['id'],
      manufacturerName: map['manufacturerName'],
      address: map['address'],
      contactNumber: map['contactNumber'],
      email: map['email'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Method to convert ManufacturerModel to a map (e.g., for sending to the backend)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'manufacturerName': manufacturerName,
      'address': address,
      'contactNumber': contactNumber,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
