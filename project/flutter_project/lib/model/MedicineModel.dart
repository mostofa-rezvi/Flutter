class MedicineModel {
  int? id;
  String? medicineName;
  String? dosageForm;
  String? instructions;
  String? medicineStrength;
  double? price;
  int? stock;
  String? createdAt;
  String? updatedAt;
  Manufacturer? manufacturer;

  MedicineModel({
    this.id,
    this.medicineName,
    this.dosageForm,
    this.instructions,
    this.medicineStrength,
    this.price,
    this.stock,
    this.createdAt,
    this.updatedAt,
    this.manufacturer,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> map) {
    return MedicineModel(
      id: map['id'] as int?, // Ensure null safety by using nullable type
      medicineName: map['medicineName'] as String? ?? '', // Default to an empty string if null
      dosageForm: map['dosageForm'] as String? ?? '', // Default to an empty string if null
      instructions: map['instructions'] as String? ?? '', // Default to an empty string if null
      medicineStrength: map['medicineStrength'] as String? ?? '', // Default to an empty string if null
      price: (map['price'] as num?)?.toDouble() ?? 0.0, // Convert to double and default to 0.0 if null
      stock: map['stock'] as int? ?? 0, // Default to 0 if null
      createdAt: map['createdAt'] as String? ?? '', // Default to an empty string if null
      updatedAt: map['updatedAt'] as String? ?? '', // Default to an empty string if null
      manufacturer: map['manufacturer'] != null
          ? Manufacturer.fromJson(map['manufacturer'] as Map<String, dynamic>)
          : null, // Handle null manufacturer
    );
  }


  Map<String, dynamic> toJson() {
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
      'manufacturer': manufacturer?.toJson(),
    };
  }
}

class Manufacturer {
  String? name;
  String? address;

  Manufacturer({this.name, this.address});

  factory Manufacturer.fromJson(Map<String, dynamic> map) {
    return Manufacturer(
      name: map['name'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
    };
  }
}
