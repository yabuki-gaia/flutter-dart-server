import 'package:flutter/material.dart';
import 'dart:math';

class KeyPadView extends StatefulWidget {
  const KeyPadView({
    super.key,
    required this.onKeyPressed,
    required this.onBackPressed,
  });
  final Function(String) onKeyPressed;
  final Function() onBackPressed;

  @override
  State<KeyPadView> createState() => _KeyPadViewState();
}

class _KeyPadViewState extends State<KeyPadView> {
  late List<String> keys;

  @override
  void initState() {
    super.initState();
    keys = _generateKeys();
  }

  List<String> _generateKeys() {
    final numbers = List<String>.generate(10, (i) => i.toString());
    numbers.shuffle(Random());
    return [...numbers.sublist(0, 9), "", numbers[9], "←"];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.2,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];
          if (key.isEmpty) {
            return const SizedBox.shrink();
          }
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(5),
            ),
            onPressed: () =>
                key == "←" ? widget.onBackPressed() : widget.onKeyPressed(key),
            child: Text(
              key,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
