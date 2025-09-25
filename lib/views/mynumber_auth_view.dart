import 'package:flutter/material.dart';
import 'package:flutter_server/components/base_view.dart';
import 'package:flutter_server/components/stepper.dart';
import 'package:flutter_server/main.dart';

class MyNumberAuthView extends StatelessWidget {
  const MyNumberAuthView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () => {
              navigatorKey.currentState?.pushReplacementNamed('/'),
            },
            icon: const Icon(Icons.close),
            label: const Text('取消'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey[300],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: BaseView(
          titleContent: const Text(
            '読み取り',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'images/mynumber-down.gif',
                width: 300,
                height: 300,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 300,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ご自身のマイナンバーカードを',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'カードリーダーの上に置いてください',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  StepperContent(count: 3, current: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
