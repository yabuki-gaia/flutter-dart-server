import 'dart:io';
import 'package:flutter_server/api/version/v1/response.dart';
import 'package:flutter_server/api/version/v1/router.dart';

Future<void> startHttpServer() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  server.listen((request) {
    final method = request.method.toUpperCase();
    final path = _normalizePath(request.uri.path);

    if (!hasRoute(path, method)) {
      jsonResponse(
        request,
        BaseResponse(statusCode: 404, message: 'Not found', body: null),
      );
      return;
    }

    try {
      final handler = routes[path]![method]!;
      handler(request);
    } catch (e) {
      stderr.writeln('Error: $e');
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

/// パスを正規化
String _normalizePath(String path) {
  if (path.length > 1 && path.endsWith('/')) {
    return path.substring(0, path.length - 1);
  }
  return path;
}
