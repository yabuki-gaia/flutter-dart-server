import 'package:flutter/material.dart';
import 'package:flutter_server/components/base_view.dart';
import 'package:flutter_server/components/input_box.dart';
import 'package:flutter_server/components/stepper.dart';
import 'package:flutter_server/main.dart';
import 'package:flutter_server/components/key_pat_view.dart';

class MyNumberPinView extends StatefulWidget {
  const MyNumberPinView({super.key});

  @override
  State<MyNumberPinView> createState() => _MyNumberPinViewState();
}

class _MyNumberPinViewState extends State<MyNumberPinView> {
  String _pin = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () {
              navigatorKey.currentState?.pushReplacementNamed('/');
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
            '暗証番号の入力',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          children: [
            Container(
              alignment: Alignment.center,
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                // color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: InputBox(count: 4, current: _pin.length),
            ),

            KeyPadView(
              onKeyPressed: (key) {
                setState(() {
                  if (_pin.length < 4) {
                    _pin += key;
                  }
                });
              },
              onBackPressed: () {
                setState(() {
                  _pin = _pin.substring(0, _pin.length - 1);
                });
              },
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
                    '利用者照明用電子証明書の',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '暗証番号(4桁の数字)を入力してください。',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  StepperContent(count: 3, current: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
