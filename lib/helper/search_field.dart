import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isSuffix;
  final String? suffixPath;
  final VoidCallback? callback;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isSuffix = false,
    this.suffixPath,
    this.callback,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoTextField(
            controller: controller,
            onChanged: onChanged,
            cursorColor: Colors.black,
            placeholder: hintText,
            placeholderStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
              ),
            ),
            suffix: GestureDetector(
              onTap: callback,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: suffixPath != null
                    ? Image.asset(
                        suffixPath!,
                        width: 20,
                        height: 20,
                      )
                    : Icon(
                        Icons.search,
                        color: Colors.grey.shade400,
                      ),
              ),
            ),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          )
        : TextFormField(
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            controller: controller,
            onChanged: onChanged,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              suffixIcon: GestureDetector(
                onTap: callback,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: suffixPath != null
                      ? Image.asset(
                          suffixPath!,
                          width: 20,
                          height: 20,
                        )
                      : Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                        ),
                ),
              ),
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
            ),
          );
  }
}
