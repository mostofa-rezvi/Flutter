class ManufacturerModel {
  int? id;
  String manufacturerName;
  String address;
  String contactNumber;
  String email;
  String? createdAt; // Represented as String to handle ISO 8601 date format
  String? updatedAt;

  // Constructor
  ManufacturerModel({
    this.id,
    required this.manufacturerName,
    required this.address,
    required this.contactNumber,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create ManufacturerModel from a map (e.g., JSON data)
  factory ManufacturerModel.fromMap(Map<String, dynamic> map) {
    return ManufacturerModel(
      id: map['id'],
      manufacturerName: map['manufacturerName'],
      address: map['address'],
      contactNumber: map['contactNumber'],
      email: map['email'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  // Method to convert ManufacturerModel to a map (e.g., for sending to the backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'manufacturerName': manufacturerName,
      'address': address,
      'contactNumber': contactNumber,
      'email': email,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
