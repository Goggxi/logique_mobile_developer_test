import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: double.infinity),
        Icon(
          Icons.wysiwyg_outlined,
          size: 100,
          color: Colors.grey[300],
        ),
        Text(
          message,
          style: TextStyle(color: Colors.grey[300]),
        ),
      ],
    );
  }
}
