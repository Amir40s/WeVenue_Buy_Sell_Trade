import 'package:biouwa/helper/images.dart';
import 'package:biouwa/provider/password_visible_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomPasswordTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  bool isSuffix = false;
  final obscurePassword;
  var suffixPath;
  VoidCallback? callback;
  CustomPasswordTextField({Key? key,
     required this.hintText,
     required this.controller,
    this.isSuffix = false,
     this.suffixPath,
     this.callback, required this.obscurePassword
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: obscurePassword,
     builder: (context, value, child){
       return TextFormField(
         controller: controller,
         cursorColor: Colors.black,
         obscureText: obscurePassword.value,
         obscuringCharacter: '*',
         validator: (value){
           if(value!.isEmpty){
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
                 padding: EdgeInsets.all(15.0),
                 child: suffixPath != null ? GestureDetector(

                     onTap: (){
                       obscurePassword.value =
                       !obscurePassword.value;
                     },
                     child: obscurePassword.value
                         ? Image.asset(suffixPath,width: 20.0,height: 20.0,) : const Icon(
                       Icons.visibility,
                       color: Colors.black,
                     )) :
                 Image.asset(AppIcons.ic_password_visible,width: 20.0,height: 20.0,color: Colors.grey.shade300,)),
           ),
           hintStyle: TextStyle(fontSize: 12.0,color: Colors.black),
           enabledBorder:  OutlineInputBorder(
             borderRadius: BorderRadius.circular(20.0),
             borderSide:  BorderSide(color: Colors.grey.shade300),
           ),
           focusedBorder:  OutlineInputBorder(
             borderRadius: BorderRadius.circular(20.0),
             borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
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