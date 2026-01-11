class BillModel {
  int? id;
  String? name;
  int? phone;
  String? email;
  String? address;
  String? invoiceDate; // It could be DateTime if you want to handle dates more efficiently.
  int? totalAmount;
  int? amountPaid;
  int? balance;
  String? status;
  String? description;
  int? patientId;
  int? doctorId;
  int? pharmacistId;
  List<int>? medicineIds;  // This should be a List of IDs.
  String? createdAt;  // This could be DateTime if you need to convert it to a DateTime.
  String? updatedAt;

  BillModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.invoiceDate,
    this.totalAmount,
    this.amountPaid,
    this.balance,
    this.status,
    this.description,
    this.patientId,
    this.doctorId,
    this.pharmacistId,
    this.medicineIds,
    this.createdAt,
    this.updatedAt,
  });

  factory BillModel.fromJson(Map<String, dynamic> map) {
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
      patientId: map['patient'] != null ? map['patient']['id'] : null,
      doctorId: map['doctor'] != null ? map['doctor']['id'] : null,
      pharmacistId: map['pharmacist'] != null ? map['pharmacist']['id'] : null,
      medicineIds: map['medicineList'] != null
          ? List<int>.from(map['medicineList'].map((x) => x['id']))
          : null, // Assuming the medicine list is a list of objects that contain 'id'.
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

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
      'patient': {'id': patientId},
      'doctor': {'id': doctorId},
      'pharmacist': {'id': pharmacistId},
      'medicineList': medicineIds?.map((id) => {'id': id}).toList(), // Mapping medicineIds to objects with 'id'.
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
