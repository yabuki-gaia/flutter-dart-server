import 'package:flutter/material.dart';

class StepperContent extends StatelessWidget {
  const StepperContent({super.key, required this.count, required this.current});
  final int count;
  final int current;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          for (int i = 0; i < count; i++) ...{
            StepperItem(count: i + 1, current: current),

            if (i != count - 1) ...{
              Container(
                width: 20,
                height: 5,
                decoration: BoxDecoration(
                  color: (i + 1 < current) ? Colors.blue[200] : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            },
          },
        ],
      ),
    );
  }
}

class StepperItem extends StatelessWidget {
  const StepperItem({super.key, required this.count, required this.current});
  final int count;
  final int current;

  // 現在対応中のステップであれば、数字を表示し、色を変える
  bool get isActive => count == current;
  // 完了したステップであれば、✓を表示し、色を変える
  bool get isDone => count < current;
  // 未完了のステップであれば、数字を表示し、色を変えない

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive || isDone ? Colors.blue[200] : Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Text(
          isDone ? "✓" : count.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isActive || isDone ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
