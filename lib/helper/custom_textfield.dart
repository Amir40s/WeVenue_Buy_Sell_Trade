import 'dart:io';

import 'package:biouwa/helper/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isSuffix;

  final String? suffixPath;
  final Color fillColor;
  final VoidCallback? callback;
  final TextInputType keyboardType;
  final String? error;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isSuffix = false,
    this.suffixPath,
    this.fillColor = customGrey,
    this.callback,
    this.keyboardType = TextInputType.text,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoTextFormFieldRow(
            controller: controller,
            placeholderStyle:
                const TextStyle(fontSize: 12.0, color: Colors.black),
            style: const TextStyle(fontSize: 12.0, color: Colors.black),
            obscureText: false,
            placeholder: hintText,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            validator: (value) =>
                value!.isEmpty ? error ?? 'Field is required' : null,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
          )
        : TextFormField(
            controller: controller,
            cursorColor: Colors.black,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Field is required';
              }
              return null;
            },
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: fillColor,
              suffixIcon: GestureDetector(
                onTap: callback,
                child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: suffixPath != null
                        ? Image.asset(
                            suffixPath!,
                            width: 20.0,
                            height: 20.0,
                          )
                        : Image.asset(
                            AppIcons.ic_password_visible,
                            width: 20.0,
                            height: 20.0,
                            color: Colors.grey.shade300,
                          )),
              ),
              hintStyle: const TextStyle(fontSize: 12.0, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
              ),
            ),
            // onSubmitted: (String value) {
            //   debugPrint(value);
            // },
          );
  }
}
