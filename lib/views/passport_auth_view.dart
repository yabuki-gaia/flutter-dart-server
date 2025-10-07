import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_server/main.dart';
import 'package:flutter_server/components/base_view.dart';
import 'package:flutter_server/utils/realpass.dart';

class PassportAuthView extends StatefulWidget {
  const PassportAuthView({super.key});
  @override
  State<PassportAuthView> createState() => _PassportAuthViewState();
}

class _PassportAuthViewState extends State<PassportAuthView> {
  StreamSubscription<Map<String, String>>? _sub;
  String _status = '';

  //　パスポートリーダーを起動する
  Future<void> _startAlwaysOn() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    try {
      RealPass.startAlwaysOn();
    } catch (e) {
      // 初期化失敗時の表示
      _status = 'Init error: $e';
    }

    // 結果を購読
    _sub = RealPass.results.listen(
      (info) {
        if (!mounted) return;
        final src = info['source'];
        final name = info['name'];
        final nat = info['nationality'];
        print('info: $name $nat, $src');

        // 読み取りが完了したら
        navigatorKey.currentState?.pushReplacementNamed(
          '/passport_result',
          arguments: {'name': name, 'nationality': nat, 'source': src},
        );
      },
      onError: (e) {
        if (!mounted) return;
        setState(() => _status = 'Error: $e');
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    RealPass.stopAlwaysOn();
    RealPass.shutdown();
    super.dispose();
  }

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
      body: FutureBuilder(
        future: _startAlwaysOn(),
        builder: (context, snapshot) {
          return Center(
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
                    'images/passport-down.gif',
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
                        'パスポート(ICチップ搭乗旅券に限る)を',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'リーダーにおいてください。',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        'images/two_stepper_1.png',
                        width: 200,
                        height: 60,
                      ),
                      TextButton(
                        onPressed: () {
                          _startAlwaysOn();
                        },
                        child: const Text('パスポートリーダーを起動'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
