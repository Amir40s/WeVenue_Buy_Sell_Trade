// custom_dropdown.dart

import 'package:biouwa/helper/dropdown_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CustomDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dropdownModel = Provider.of<DropdownProvider>(context,listen: false);

    return Container(
      width: Get.width,
      height: 50.0,
      decoration: BoxDecoration(
       color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: dropdownModel.selectedAccountType,
            onChanged: (String? newValue) {
              dropdownModel.setSelectedItem(newValue!);
            },
            items: dropdownModel.items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
