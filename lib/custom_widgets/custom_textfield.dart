import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final int? maxLength;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.maxLength,
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
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          enableSuggestions: false,
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          maxLength: maxLength,
          autovalidateMode: AutovalidateMode.onUserInteraction, 
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            counterText: "",
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: defaultBorder,
            enabledBorder: defaultBorder,
            focusedBorder: defaultBorder.copyWith(
              borderSide: const BorderSide(color: Color(0xFF3F8A99), width: 2),
            ),
            errorBorder: defaultBorder.copyWith(
              borderSide: const BorderSide(color: errorColor, width: 2),
            ),
            focusedErrorBorder: defaultBorder.copyWith(
              borderSide: const BorderSide(color: errorColor, width: 2),
            ),
            errorStyle: const TextStyle(
              color: Color(0xFFE53935), 
              fontWeight: FontWeight.bold,
              fontSize: 12
            ),
          ),
        ),
      ],
    );
  }
}