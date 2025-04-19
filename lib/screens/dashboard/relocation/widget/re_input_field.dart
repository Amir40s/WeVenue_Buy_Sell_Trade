import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget? prefix;
  final bool enabled;

  ReInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.enabled = true,
    this.prefix,
  });

  final isIos = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    return isIos
        ? CupertinoTextField(
            controller: controller,
            cursorColor: Colors.black,
            placeholder: hintText,
            placeholderStyle:
                const TextStyle(fontSize: 12.0, color: Colors.black),
            style: const TextStyle(color: Colors.black),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.white),
            ),
          )
        : TextFormField(
            controller: controller,
            cursorColor: Colors.black,
            validator: (value) {
              if (value!.isEmpty) {
                return 'field required';
              }
              return null;
            },
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              prefixIcon: prefix,
              fillColor: Colors.white,
              hintStyle: const TextStyle(fontSize: 12.0, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
          );
  }
}
