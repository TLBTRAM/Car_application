import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Widget? prefixIcon;

  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.25)),
        ),
        prefixIcon: prefixIcon ?? Icon(
          Icons.edit_outlined,
          color: theme.colorScheme.primary,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}

