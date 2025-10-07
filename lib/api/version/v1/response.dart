import 'dart:convert';
import 'dart:io';

import 'package:flutter_server/api/utils/logger.dart';

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

void jsonResponse(HttpRequest req, BaseResponse body) async {
  log(req, body.statusCode);
  req.response
    ..statusCode = body.statusCode
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(body.toJson()));
  await req.response.close();
}
