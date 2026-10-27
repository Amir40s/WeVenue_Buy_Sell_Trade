import 'dart:io';

import 'package:biouwa/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget? prefix;
  final bool enabled;
  final String? Function(String?)? validator;

  const ReInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.enabled = true,
    this.prefix,
    this.validator,
  });

  static const Color _textColor = Color(0xFF202033);
  static const Color _hintColor = Color(0xFF85859A);
  static const Color _borderColor = Color(0xFFEEEEF4);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTextField(
        controller: controller,
        enabled: enabled,
        prefix: prefix == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: IconTheme(
                  data: IconThemeData(
                    color: primaryColor,
                    size: 20,
                  ),
                  child: prefix!,
                ),
              ),
        cursorColor: primaryColor,
        placeholder: hintText,
        placeholderStyle: const TextStyle(
          fontSize: 13,
          color: _hintColor,
        ),
        style: const TextStyle(
          color: _textColor,
          fontSize: 14,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 17,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFDFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor),
        ),
      );
    }

    return TextFormField(
      controller: controller,
      enabled: enabled,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Field required';
            }
            return null;
          },
      cursorColor: primaryColor,
      style: const TextStyle(
        color: _textColor,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: _hintColor,
          fontSize: 13,
        ),
        prefixIcon: prefix == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 12, right: 10),
                child: IconTheme(
                  data: IconThemeData(
                    color: primaryColor,
                    size: 20,
                  ),
                  child: prefix!,
                ),
              ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 46,
          minHeight: 48,
        ),
        filled: true,
        fillColor: const Color(0xFFFDFDFF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        errorStyle: const TextStyle(
          fontSize: 11,
          height: 1.4,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD9485F)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFD9485F),
            width: 1.4,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _borderColor),
        ),
      ),
    );
  }
}
