class BillModel {
  int? id;
  String? name;
  int? phone;
  String? email;
  String? address;
  String? invoiceDate;
  int? totalAmount;
  int? amountPaid;
  int? balance;
  String? status;
  String? description;
  int? patientId;
  int? doctorId;
  int? pharmacistId;
  int? medicineIds;
  String? createdAt;
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
      patientId: map['patient']['id'],
      doctorId: map['doctor']['id'],
      pharmacistId: map['pharmacist']['id'],
      medicineIds: map['medicineList']['id'],
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
      'medicineList': {'id': medicineIds},
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
