class ManufacturerModel {
  int? id;
  String manufacturerName;
  String address;
  String contactNumber;
  String email;
  String? createdAt;
  String? updatedAt;

  ManufacturerModel({
    this.id,
    required this.manufacturerName,
    required this.address,
    required this.contactNumber,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

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
