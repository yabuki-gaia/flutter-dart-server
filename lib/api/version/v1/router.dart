import 'dart:io';
import 'package:flutter_server/main.dart';
import 'dart:convert';
import 'package:flutter_server/api/version/v1/response.dart';

typedef RouteHandler = void Function(HttpRequest request);

Future<void> startHttpServer() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  server.listen((request) {
    final path = request.uri.path;
    final method = request.method;

    if (routes[path] == null || routes[path]?[method] == null) {
      jsonResponse(
        request,
        BaseResponse(statusCode: 404, message: 'Not found', body: null),
      );
      return;
    }
    try {
      routes[path]?[method]!(request);
    } catch (e) {
      print('Error: $e');
      jsonResponse(
        request,
        BaseResponse(
          statusCode: 500,
          message: 'Internal server error',
          body: null,
        ),
      );
    }
  });
}

const basePath = '/api/v1';

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
};

void jsonResponse(HttpRequest req, BaseResponse body) async {
  req.response
    ..statusCode = body.statusCode
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(body.toJson()));
  await req.response.close();
}
