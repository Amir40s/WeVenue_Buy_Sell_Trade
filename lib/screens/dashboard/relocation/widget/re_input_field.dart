import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String prefixPath;
  bool isPrefix;

  ReInputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.prefixPath,
    this.isPrefix = true,
  });
  final isIos = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    return !isIos
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
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              prefixIcon: Container(
                margin: const EdgeInsets.only(right: 5.0),
                padding: const EdgeInsets.all(8.0),
                child: isPrefix
                    ? Image.asset(prefixPath, width: 20.0, height: 20.0)
                    : const SizedBox(
                        width: 0.5,
                      ),
              ),
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
            ),
          );
  }
}
