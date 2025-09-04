import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.warning_amber_rounded,
            color: Color(0xFFE53935), size: 20),
        const SizedBox(width: 8),
        Text(
          message,
          style: const TextStyle(color: Color(0xFFE53935), fontSize: 13),
        ),
      ],
    );
  }
}
