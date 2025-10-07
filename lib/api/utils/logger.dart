import 'dart:io';

/// ログを出力
void log(HttpRequest req, int status) {
  final ip = req.connectionInfo?.remoteAddress.address ?? '-';
  final q = req.uri.query.isEmpty ? '' : '?${req.uri.query}';
  final time = DateTime.now().toIso8601String();
  stdout.writeln('LOG: $time $ip ${req.method} ${req.uri.path}$q $status');
}
