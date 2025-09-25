import 'package:flutter/material.dart';
import 'views/standy_view.dart';
import 'views/passport_auh_view.dart';
import 'views/mynumber_auth_view.dart';
import 'views/mynumber_pin_View.dart';
import 'api/version/v1/router.dart';

void main() {
  startHttpServer();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => const StandyView(),
        '/passport': (context) => const PassportAuthView(),
        '/mynumber': (context) => const MyNumberAuthView(),
        '/mynumber_pin': (context) => const MyNumberPinView(),
      },
    );
  }
}
