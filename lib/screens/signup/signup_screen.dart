import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/custom_richtext.dart';
import 'package:biouwa/helper/custom_textfield.dart';
import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/simple_header.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/provider/signnup/firebase_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../helper/button_loading_widget.dart';
import '../../helper/custom_password_textfield.dart';
import '../../helper/dropdown_provider.dart';
import '../../helper/dropdown_widget.dart';
import '../../provider/constant/value_provider.dart';
import '../login/login_screen.dart';
class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  var nameController  = TextEditingController();
  var emailController  = TextEditingController();
  var phoneController  = TextEditingController();
  var passwordController  = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  @override
  Widget build(BuildContext context) {
    var dropDownProvider = Provider.of<DropdownProvider>(context,listen: false);
    final key = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: key,
            child: Container(
              width: Get.width,
              height: Get.height,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   const SimpleHeader(),
                  const SizedBox(height: 40.0,),
                  TextWidget(text: "Sign Up",size: 22.0,isBold: true,),

                  const SizedBox(height: 40.0,),
                  CustomTextField(hintText: "Name", controller: nameController,suffixPath: AppIcons.ic_name,),
                  const SizedBox(height: 20.0,),
                  CustomTextField(hintText: "Email", controller: emailController,suffixPath: AppIcons.ic_email,),
                  const SizedBox(height: 20.0,),
                  CustomTextField(hintText: "Phone", controller: phoneController,suffixPath: AppIcons.ic_phone,
                  keyboardType: TextInputType.number,),
                  const SizedBox(height: 20.0,),
                  const CustomDropdown(),
                  const SizedBox(height: 20.0,),
                  CustomPasswordTextField(hintText: "Password", controller: passwordController,suffixPath: AppIcons.ic_password_visible, obscurePassword: _obscurePassword,),

                  const SizedBox(height: 40.0,),
                  Consumer<ValueProvider>(
                    builder: (context,provider,index){
                      return provider.isLoading == false ? ButtonWidget(
                          text: "Create Account",
                          onClicked: (){
                            if(key.currentState!.validate()){
                              provider.setLoading(true);
                              Provider.of<FirebaseDataProvider>(context,listen: false)
                                  .createUserAccount(
                                  name: nameController.text.toString(),
                                  email: emailController.text.toString(),
                                  phone: phoneController.text.toString(),
                                  accountType: dropDownProvider.selectedAccountType.toString(),
                                  password: passwordController.text.toString(),
                                  context: context);
                            }
                          },
                          width: MediaQuery.sizeOf(context).width, height: 50.0) :
                      ButtonLoadingWidget(loadingMesasge: "creating",width: MediaQuery.sizeOf(context).width, height: 50.0);
                    },
                  ),

                  const SizedBox(height: 30.0,),
                  CustomRichtext(press: (){
                    Get.to(LoginScreen());
                  }, firstText: "Already have an account?", secondText: "Log In"),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
