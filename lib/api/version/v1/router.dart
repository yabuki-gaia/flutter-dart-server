import 'dart:io';
import 'package:flutter_server/main.dart';
import 'package:flutter_server/api/version/v1/response.dart';

const basePath = '/api/v1';

typedef RouteHandler = void Function(HttpRequest request);
final Map<String, Map<String, RouteHandler>> routes = {
  '$basePath/passport': {
    'GET': (request) {
      navigatorKey.currentState?.pushReplacementNamed('/passport');
      jsonResponse(
        request,
        BaseResponse(statusCode: 200, message: 'OK', body: {'ok': true}),
      );
    },
  },
  '$basePath/mynumber': {
    'GET': (request) {
      navigatorKey.currentState?.pushReplacementNamed('/mynumber');
      jsonResponse(
        request,
        BaseResponse(statusCode: 200, message: 'OK', body: {'ok': true}),
      );
    },
  },
  '$basePath/mynumber_pin': {
    'GET': (request) {
      navigatorKey.currentState?.pushReplacementNamed('/mynumber_pin');
      jsonResponse(
        request,
        BaseResponse(statusCode: 200, message: 'OK', body: {'ok': true}),
      );
    },
  },
  '$basePath/passport_result': {
    'GET': (request) {
      navigatorKey.currentState?.pushReplacementNamed('/passport_result');
      jsonResponse(
        request,
        BaseResponse(statusCode: 200, message: 'OK', body: {'ok': true}),
      );
    },
  },
};

/// ルートが存在するかどうかを返す
bool hasRoute(String path, String method) {
  return routes[path] != null && routes[path]![method] != null;
}
