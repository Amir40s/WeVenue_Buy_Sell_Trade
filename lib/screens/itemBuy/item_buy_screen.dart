import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/simple_header.dart';
import 'package:flutter/material.dart';
class ItemBuyScreen extends StatelessWidget {
  const ItemBuyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              SimpleHeader(),
              SizedBox(height: 20.0,),
            ],
          ),
        ),
      ),
    );
  }
}
