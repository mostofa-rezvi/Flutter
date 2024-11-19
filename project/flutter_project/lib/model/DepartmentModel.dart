class DepartmentModel {
  int? id;
  String departmentName;
  String description;

  DepartmentModel({
    this.id,
    required this.departmentName,
    required this.description,
  });

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['id'],
      departmentName: map['departmentName'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departmentName': departmentName,
      'description': description,
    };
  }
}
