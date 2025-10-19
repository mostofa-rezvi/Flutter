class Driver {
  final int id;
  final String firstname;
  final String lastname;
  final String? email;
  final String? mobile;

  Driver({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.email,
    this.mobile,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: _toInt(json['id']),
      firstname: json['firstname']?.toString() ?? '',
      lastname: json['lastname']?.toString() ?? '',
      email: json['email']?.toString(),
      mobile: json['mobile']?.toString(),
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}
