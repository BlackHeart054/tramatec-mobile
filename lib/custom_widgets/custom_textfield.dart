import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final bool hasError;

  const CustomTextField({super.key, 
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    const errorColor = Color(0xFFE53935);
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.white, width: 1.5),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: defaultBorder,
            enabledBorder: defaultBorder,
            focusedBorder: defaultBorder.copyWith(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: defaultBorder.copyWith(
              borderSide: const BorderSide(color: errorColor, width: 2),
            ),
            focusedErrorBorder: defaultBorder.copyWith(
              borderSide: const BorderSide(color: errorColor, width: 2),
            ),
            suffixIcon: hasError && !isPassword
                ? const Icon(Icons.cancel, color: errorColor)
                : null,
          ),
        ),
      ],
    );
  }
}
