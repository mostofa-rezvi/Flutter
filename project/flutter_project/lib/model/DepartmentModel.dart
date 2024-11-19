class DepartmentModel {
  int? id;
  String departmentName;
  String description;

  // Constructor
  DepartmentModel({
    this.id,
    required this.departmentName,
    required this.description,
  });

  // Factory method to create DepartmentModel from a map (e.g., JSON data)
  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['id'],
      departmentName: map['departmentName'],
      description: map['description'],
    );
  }

  // Method to convert DepartmentModel to a map (e.g., for sending to the backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departmentName': departmentName,
      'description': description,
    };
  }
}
