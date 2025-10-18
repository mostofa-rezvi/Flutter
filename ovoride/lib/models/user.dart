class User {
  final int? id;
  final String shopName;
  final String ownerName;
  final String email;
  final String? password;
  final String? passwordConfirmation;
  final String? token;
  final int? agree;

  User({
    this.id,
    required this.shopName,
    required this.ownerName,
    required this.email,
    this.password,
    this.passwordConfirmation,
    this.token,
    this.agree,
  });

  User copyWith({String? token}) {
    return User(
      id: id,
      shopName: shopName,
      ownerName: ownerName,
      email: email,
      token: token ?? this.token,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final shopData = json['shop'] ?? {};
    return User(
      id: shopData['id'],
      shopName: shopData['shop_name'] ?? '',
      ownerName: shopData['owner_name'] ?? '',
      email: shopData['email'] ?? '',
      token: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shop_name': shopName,
      'owner_name': ownerName,
      'email': email,
      if (password != null) 'password': password,
      if (passwordConfirmation != null)
        'password_confirmation': passwordConfirmation,
      if (agree != null) 'agree': agree,
    };
  }
}