import 'package:flutter/material.dart';

import '../../../../helper/images.dart';
class ReInputField extends StatelessWidget {

  final String hintText;
  final TextEditingController controller;
  final String prefixPath;
   bool isPrefix;

  ReInputField({Key? key,
    required this.hintText,
    required this.controller, required this.prefixPath,this.isPrefix  = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      validator: (value){
        if(value!.isEmpty){
          return 'field required';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        prefixIcon: Container(
            margin: EdgeInsets.only(right: 5.0),
            padding: EdgeInsets.all(8.0),
            child:  isPrefix ?Image.asset(prefixPath,width: 20.0,height: 20.0) : SizedBox(width: 0.5,)),
        fillColor: Colors.white,
        hintStyle: TextStyle(fontSize: 12.0,color: Colors.black),
        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide:  BorderSide(color: Colors.white),
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.white, width: 2.0),
        ),
      ),
      // onSubmitted: (String value) {
      //   debugPrint(value);
      // },
    );
  }
}
