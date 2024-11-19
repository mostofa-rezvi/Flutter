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
      id: map['id'],
      medicineName: map['medicineName'],
      dosageForm: map['dosageForm'],
      instructions: map['instructions'],
      medicineStrength: map['medicineStrength'],
      price: map['price']?.toDouble() ?? 0.0,
      stock: map['stock'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      manufacturer: map['manufacturer'] != null
          ? Manufacturer.fromJson(map['manufacturer'])
          : null,
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
