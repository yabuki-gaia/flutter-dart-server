class BaseResponse {
  final int statusCode;
  final String message;
  final dynamic body;

  BaseResponse({
    required this.statusCode,
    required this.message,
    required this.body,
  });

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'message': message,
    'body': body,
  };
}

class SuccessResponse extends BaseResponse {
  SuccessResponse({
    required super.statusCode,
    required super.message,
    required super.body,
  });
}
