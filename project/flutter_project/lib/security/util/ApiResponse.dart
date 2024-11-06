class ApiResponse {
  String? message;
  dynamic data;
  bool? successful;

  ApiResponse({this.message, this.data, this.successful});

  // Optional: Add factory constructor to parse from JSON, if you are receiving JSON response.
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'],
      data: json['data'],
      successful: json['successful'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
      'successful': successful,
    };
  }
}
