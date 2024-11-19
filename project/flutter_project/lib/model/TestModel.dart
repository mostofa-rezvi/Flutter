class TestModel {
  int? id;
  String testName;
  String description;
  String? result;
  String? instructions;
  String? createdAt;
  String? updatedAt;

  TestModel({
    this.id,
    required this.testName,
    required this.description,
    this.result,
    this.instructions,
    this.createdAt,
    this.updatedAt,
  });

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

  Map<String, dynamic> toJson() {
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

  static fromJson(x) {}
}
