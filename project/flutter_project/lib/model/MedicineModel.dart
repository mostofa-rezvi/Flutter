class MedicineModel {
  int id;
  String medicineName;
  String dosageForm;
  String instructions;
  String medicineStrength;
  double price;
  int stock;
  String createdAt;
  String updatedAt;
  Manufacturer manufacturer;

  // Constructor
  MedicineModel({
    required this.id,
    required this.medicineName,
    required this.dosageForm,
    required this.instructions,
    required this.medicineStrength,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
    required this.manufacturer,
  });

  // Factory method to create MedicineModel from a map (e.g., JSON data)
  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      id: map['id'],
      medicineName: map['medicineName'],
      dosageForm: map['dosageForm'],
      instructions: map['instructions'],
      medicineStrength: map['medicineStrength'],
      price: map['price']?.toDouble() ?? 0.0,
      stock: map['stock'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      manufacturer: Manufacturer.fromMap(map['manufacturer']),
    );
  }

  // Method to convert MedicineModel to a map (e.g., for sending to the backend)
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'medicineName': medicineName,
      'dosageForm': dosageForm,
      'instructions': instructions,
      'medicineStrength': medicineStrength,
      'price': price,
      'stock': stock,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'manufacturer': manufacturer.toMap(),
    };
  }

}

class Manufacturer {
  int id;
  String name;

  // Constructor
  Manufacturer({
    required this.id,
    required this.name,
  });

  // Factory method to create Manufacturer from a map
  factory Manufacturer.fromMap(Map<String, dynamic> map) {
    return Manufacturer(
      id: map['id'],
      name: map['name'],
    );
  }

  // Method to convert Manufacturer to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
