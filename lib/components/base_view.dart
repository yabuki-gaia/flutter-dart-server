import 'package:flutter/material.dart';

class BaseView extends StatelessWidget {
  const BaseView({
    super.key,
    required this.children,
    required this.titleContent,
  });
  final List<Widget> children;
  final Widget titleContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titleContent,
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
        ...children,
      ],
    );
  }
}
