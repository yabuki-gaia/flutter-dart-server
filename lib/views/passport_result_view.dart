import 'package:flutter/material.dart';
import 'package:flutter_server/components/base_view.dart';

class PassportResultView extends StatefulWidget {
  const PassportResultView({super.key});

  @override
  State<PassportResultView> createState() => _PassportResultViewState();
}

class _PassportResultViewState extends State<PassportResultView> {
  @override
  Widget build(BuildContext context) {
    // argumentsを受け取る
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final name = args?['name'] ?? '不明';
    final nationality = args?['nationality'] ?? '不明';
    final source = args?['source'] ?? '不明';

    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Center(
        child: BaseView(
          titleContent: const Text('パスポート読み取り結果'),
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '氏名: $name',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '国籍: $nationality',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text('取得元: $source', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
