import 'dart:io';

import 'package:biouwa/helper/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isSuffix;
  final String? suffixPath;
  final VoidCallback? callback;

  const SearchField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isSuffix = false,
    this.suffixPath,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoTextField(
            controller: controller,
            cursorColor: Colors.black,
            placeholder: hintText,
            placeholderStyle:
                const TextStyle(fontSize: 12.0, color: Colors.black),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey.shade300, width: 2.0),
            ),
            suffix: GestureDetector(
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
                      ),
              ),
            ),
            style: const TextStyle(fontSize: 12.0, color: Colors.black),
          )
        : TextField(
            controller: controller,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
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
                      : Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                        ),
                ),
              ),
              hintStyle: const TextStyle(fontSize: 12.0, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
              ),
            ),
          );
  }
}
