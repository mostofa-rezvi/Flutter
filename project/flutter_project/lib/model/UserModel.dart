import 'dart:convert';

enum Role {
  ADMIN,
  PATIENT,
  DOCTOR,
  NURSE,
  RECEPTIONIST,
  PHARMACIST,
  LAB,
}

class UserModel {
  int? id;
  String? name;
  String? email;
  String? password;
  int? cell;
  int? age;
  String? gender;
  DateTime? birthday;
  String? address;
  String? image;
  String? doctorDegree;
  String? doctorSpeciality;
  String? doctorLicense;
  String? nurseDegree;
  String? nurseSpeciality;
  String? nurseLicense;
  int? departmentId;
  Role? role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.cell,
    required this.age,
    required this.gender,
    required this.birthday,
    required this.address,
    required this.image,
    required this.doctorDegree,
    required this.doctorSpeciality,
    required this.doctorLicense,
    required this.nurseDegree,
    required this.nurseSpeciality,
    required this.nurseLicense,
    required this.departmentId,
    required this.role,
  });

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      cell: json['cell'],
      age: json['age'],
      gender: json['gender'],
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      address: json['address'],
      image: json['image'],
      doctorDegree: json['doctorDegree'],
      doctorSpeciality: json['doctorSpeciality'],
      doctorLicense: json['doctorLicense'],
      nurseDegree: json['nurseDegree'],
      nurseSpeciality: json['nurseSpeciality'],
      nurseLicense: json['nurseLicense'],
      departmentId: json['departmentId'],
      role: Role.values.byName(json['role']),
    );
  }

  // To JSON
   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'cell': cell,
      'age': age,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'address': address,
      'image': image,
      'doctorDegree': doctorDegree,
      'doctorSpeciality': doctorSpeciality,
      'doctorLicense': doctorLicense,
      'nurseDegree': nurseDegree,
      'nurseSpeciality': nurseSpeciality,
      'nurseLicense': nurseLicense,
      'departmentId': departmentId,
      'role': role?.name,
    };
  }

  static fromMap(map) {}
}

// UserRoleMap
const userRoleMap = [
  {'value': Role.ADMIN, 'label': 'Administrator'},
  {'value': Role.PATIENT, 'label': 'Patient'},
  {'value': Role.DOCTOR, 'label': 'Doctor'},
  {'value': Role.NURSE, 'label': 'Nurse'},
  {'value': Role.RECEPTIONIST, 'label': 'Receptionist'},
  {'value': Role.PHARMACIST, 'label': 'Pharmacist'},
  {'value': Role.LAB, 'label': 'Lab'}
];
