class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) {
    return ApiResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'],
    );
  }
}