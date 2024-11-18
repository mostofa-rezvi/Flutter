class ApiResponse {
  final String? message;
  final dynamic data;
  final Map<String, String>? errors;
  final bool successful;

  ApiResponse({
    this.message,
    this.data,
    this.errors,
    required this.successful,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'],
      data: json['data'],
      errors: json['errors'] != null
          ? Map<String, String>.from(json['errors'])
          : null,
      successful: json['successful'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
      'errors': errors,
      'successful': successful,
    };
  }


  // Success response
  factory ApiResponse.success(dynamic data, {String? message}) {
    return ApiResponse(
      message: message ?? 'Request was successful.',
      data: data,
      errors: null,
      successful: true,
    );
  }

  // Error response
  factory ApiResponse.error(String message, {Map<String, String>? errors}) {
    return ApiResponse(
      message: message,
      data: null,
      errors: errors,
      successful: false,
    );
  }
}
