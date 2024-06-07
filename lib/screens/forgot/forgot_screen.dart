import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../helper/button_loading_widget.dart';
import '../../helper/button_widget.dart';
import '../../helper/custom_textfield.dart';
import '../../helper/images.dart';
import '../../helper/simple_header.dart';
import '../../helper/text_widget.dart';
import '../../provider/signnup/firebase_data_provider.dart';
import '../../provider/constant/value_provider.dart';
class ForgotPasswordScreen extends StatelessWidget {
   ForgotPasswordScreen({super.key});

   final _key =  GlobalKey<FormState>();
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseDataProvider>(context,listen: false);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            width: Get.width,
            height: Get.height,
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key:_key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   SimpleHeader(),
                  SizedBox(height: 40.0,),
                  TextWidget(text: "Forgot Password",size: 24.0,isBold: true,),
              
              
                  SizedBox(height: 40.0,),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextWidget(text: "please enter the email address associated with your account",size: 12.0,isBold: false,color: lightBlue,textAlignment: TextAlign.center,),
                  ),
              
                  SizedBox(height: 40.0,),
                  CustomTextField(hintText: "Email", controller: emailController,suffixPath: AppIcons.ic_email,),
              
                  SizedBox(height: 80.0,),
                  Consumer<ValueProvider>(
                    builder: (context, provider, child){
                      return provider.isLoading == false  ? ButtonWidget(text: "Reset Password", onClicked: (){
                        if(_key.currentState!.validate()){
                          provider.setLoading(true);
                        firebaseProvider.resetPassword(email: emailController.text.toString(), context: context);
                        }
                      }, width: Get.width, height: 50.0) :
                      ButtonLoadingWidget(loadingMesasge: "sending",width: MediaQuery.sizeOf(context).width, height: 50.0);
                    },
                  ),
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
