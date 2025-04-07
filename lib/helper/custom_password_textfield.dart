import 'dart:io';

import 'package:biouwa/helper/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPasswordTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  bool isSuffix = false;
  final obscurePassword;
  var suffixPath;
  VoidCallback? callback;

  CustomPasswordTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isSuffix = false,
    this.suffixPath,
    this.callback,
    required this.obscurePassword,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: obscurePassword,
      builder: (context, value, child) {
        return Platform.isIOS
            ? CupertinoTextFormFieldRow(
                controller: controller,
                obscureText: false,
                placeholderStyle:
                    const TextStyle(fontSize: 12.0, color: Colors.black),
                placeholder: hintText,
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                validator: (value) => value!.isEmpty ? 'Field required' : null,
                style: const TextStyle(fontSize: 12.0, color: Colors.black),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
              )
            : TextFormField(
                controller: controller,
                cursorColor: Colors.black,
                obscureText: obscurePassword.value,
                obscuringCharacter: '*',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'field required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: hintText,
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  suffixIcon: GestureDetector(
                    onTap: callback,
                    child: Container(
                        padding: const EdgeInsets.all(15.0),
                        child: suffixPath != null
                            ? GestureDetector(
                                onTap: () {
                                  obscurePassword.value =
                                      !obscurePassword.value;
                                },
                                child: obscurePassword.value
                                    ? Image.asset(
                                        suffixPath,
                                        width: 20.0,
                                        height: 20.0,
                                      )
                                    : const Icon(
                                        Icons.visibility,
                                        color: Colors.black,
                                      ))
                            : Image.asset(
                                AppIcons.ic_password_visible,
                                width: 20.0,
                                height: 20.0,
                                color: Colors.grey.shade300,
                              )),
                  ),
                  hintStyle:
                      const TextStyle(fontSize: 12.0, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2.0),
                  ),
                ),
                // onSubmitted: (String value) {
                //   debugPrint(value);
                // },
              );
      },
    );
  }
}
