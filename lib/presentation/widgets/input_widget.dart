import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  TextEditingController controller;
  String? hint;
  String? label;
  bool? obscureText;
  Widget? prefixIcon;
  double? paddingContent;
  double? elevationShadow;
  TextInputType? keyboardType;

  InputWidget(
      {super.key,
      required this.controller,
      this.hint,
      this.label,
      this.obscureText,
      this.prefixIcon,
      this.paddingContent,
      this.elevationShadow,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      elevation: elevationShadow ?? 8,
      shadowColor: Colors.grey.shade100,
      color: Colors.white,
      child: TextField(
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          controller: controller,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: paddingContent ?? 12),
              prefixIcon: prefixIcon,
              label: label != null
                  ? Text(
                      label ?? "",
                      style: const TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.w500),
                    )
                  : null,
              border: InputBorder.none)),
    );
  }
}
