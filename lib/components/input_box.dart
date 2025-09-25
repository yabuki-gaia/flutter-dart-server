import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  const InputBox({super.key, required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        for (int i = 0; i < count; i++) ...{InputBoxItem(isDone: i < current)},
      ],
    );
  }
}

class InputBoxItem extends StatelessWidget {
  const InputBoxItem({super.key, required this.isDone});
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              isDone ? '＊' : '',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 2),

        if (isDone) ...{
          Container(
            width: 42,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.orange[600],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        },
      ],
    );
  }
}
