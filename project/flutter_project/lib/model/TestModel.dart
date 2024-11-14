class TestModel {
  int id;
  String testName;
  String description;
  String result;
  String instructions;
  String? createdAt;
  String? updatedAt;

  // Constructor
  TestModel({
    required this.id,
    required this.testName,
    required this.description,
    required this.result,
    required this.instructions,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create TestModel from a map (e.g., JSON data)
  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      id: map['id'],
      testName: map['testName'],
      description: map['description'],
      result: map['result'],
      instructions: map['instructions'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  // Method to convert TestModel to a map (e.g., for sending to the backend)
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'testName': testName,
      'description': description,
      'result': result,
      'instructions': instructions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
