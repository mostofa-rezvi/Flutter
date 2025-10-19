class User {
  final int? id;
  final String firstname;
  final String lastname;
  final String email;
  final String? password;
  final String? passwordConfirmation;
  final String? token;
  final int? agree;

  User({
    this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.password,
    this.passwordConfirmation,
    this.token,
    this.agree,
  });

  User copyWith({String? token}) {
    return User(
      id: id,
      firstname: firstname,
      lastname: lastname,
      email: email,
      token: token ?? this.token,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? {};
    return User(
      id: userData['id'],
      firstname: userData['first_name'] ?? '',
      lastname: userData['last_name'] ?? '',
      email: userData['email'] ?? '',
      token: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstname,
      'last_name': lastname,
      'email': email,
      if (password != null) 'password': password,
      if (passwordConfirmation != null)
        'password_confirmation': passwordConfirmation,
      if (agree != null) 'agree': agree,
    };
  }
}