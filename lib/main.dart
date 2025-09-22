import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  _startHttpServer();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> _startHttpServer() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  server.listen((request) {
    try {
      final path = request.uri.path;
      final method = request.method;

      if (path == "/api") {
        if (method == "GET") {
          navigatorKey.currentState?.pushReplacementNamed('/auth');
          _json(request, 200, {'ok': true});
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  });
}

void _json(HttpRequest req, int status, Object body) {
  req.response
    ..statusCode = status
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(body))
    ..close();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => const ScreenA(),
        '/auth': (context) => const ScreenB(),
      },
    );
  }
}

class ScreenA extends StatelessWidget {
  const ScreenA({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Aの画面を操作してください',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Please operate the A screen',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              height: 4,
              width: 80,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'images/OperateA.png',
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenB extends StatelessWidget {
  const ScreenB({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('認証画面'),
        actions: [
          TextButton(
            onPressed: () {
              navigatorKey.currentState?.pushReplacementNamed('/');
            },
            child: const Text('取り消し'),
          ),
        ],
      ),
      body: const Center(child: Text('認証画面')),
    );
  }
}
