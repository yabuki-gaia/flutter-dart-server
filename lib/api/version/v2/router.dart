import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_server/main.dart'; // navigatorKey を使う場合
import 'package:flutter_server/api/version/v1/response.dart';

typedef RouteHandler = Future<void> Function(HttpRequest request);

const basePath = '/api/v2';
const _port = 8080;

final Map<String, Map<String, RouteHandler>> routes = {
  '$basePath/passport': {
    'GET': (req) async {
      /**
       * パスポート読み取り画面に遷移
       */
      navigatorKey.currentState?.pushReplacementNamed('/passport');
      await jsonResponse(
        req,
        BaseResponse(statusCode: 200, message: 'OK', body: {'ok': true}),
      );
    },
  },
  '$basePath/mynumber': {
    'GET': (req) async {
      /**
       * マイナンバー認証画面に遷移
       */
      navigatorKey.currentState?.pushReplacementNamed('/mynumber');
      await jsonResponse(
        req,
        BaseResponse(statusCode: 200, message: 'OK', body: {'ok': true}),
      );
    },
  },
  '$basePath/mynumber_pin': {
    'GET': (req) async {
      /**
       * マイナンバー暗証番号入力画面に遷移
       */
      navigatorKey.currentState?.pushReplacementNamed('/mynumber_pin');
      await jsonResponse(
        req,
        BaseResponse(statusCode: 200, message: 'OK', body: {'ok': true}),
      );
    },
  },
  /**
   * ヘルスチェック
   */
  '/healthz': {
    'GET': (req) async {
      await jsonResponse(
        req,
        BaseResponse(statusCode: 200, message: 'ok', body: 'ok'),
      );
    },
  },
};

String _normalizePath(String path) {
  if (path.length > 1 && path.endsWith('/'))
    return path.substring(0, path.length - 1);
  return path;
}

bool _hasRoute(String path, String method) =>
    routes[path] != null && routes[path]![method] != null;

void _applyCors(HttpResponse res) {
  res.headers.set('Access-Control-Allow-Origin', '*'); // 本番は絞るべし
  res.headers.set('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
  res.headers.set('Access-Control-Allow-Headers', 'Origin,Content-Type');
}

void _log(HttpRequest req, int status) {
  final ip = req.connectionInfo?.remoteAddress.address ?? '-';
  final q = req.uri.query.isEmpty ? '' : '?${req.uri.query}';
  // 例: 127.0.0.1 GET /api/v1/mynumber 200
  stdout.writeln('$ip ${req.method} ${req.uri.path}$q $status');
}

Future<void> startHttpServer() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, _port);
  server.autoCompress = true;
  stdout.writeln('✅ Listening on http://${server.address.host}:${server.port}');

  await for (final request in server) {
    final method = request.method.toUpperCase();
    final path = _normalizePath(request.uri.path);

    try {
      _applyCors(request.response);
      if (method == 'OPTIONS') {
        request.response.statusCode = HttpStatus.noContent;
        await request.response.close();
        _log(request, HttpStatus.noContent);
        continue;
      }

      if (!_hasRoute(path, method)) {
        await jsonResponse(
          request,
          BaseResponse(statusCode: 404, message: 'Not found', body: null),
        );
        _log(request, 404);
        continue;
      }
      final handler = routes[path]![method]!;
      await handler(request);
    } catch (e, st) {
      stderr.writeln('Error: $e\n$st');
      _log(request, 500);
    }
  }
}

Future<void> jsonResponse(HttpRequest req, BaseResponse body) async {
  final res = req.response;
  _applyCors(res);
  res.statusCode = body.statusCode;
  res.headers.contentType = ContentType(
    'application',
    'json',
    charset: 'utf-8',
  );
  final bytes = utf8.encode(jsonEncode(body.toJson()));
  res.headers.set(HttpHeaders.contentLengthHeader, bytes.length);
  res.add(bytes);
  await res.close();
  _log(req, body.statusCode);
}
