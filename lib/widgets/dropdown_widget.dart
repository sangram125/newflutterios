import 'package:auto_size_text/auto_size_text.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/get_ticket_item_model.dart';

  class DropdownListWidget extends StatelessWidget {
   List<String>? list = ["a","b","c","d"];

   DropdownListWidget({
    super.key,
     this.list,

  });

  @override
  Widget build(BuildContext context) {
    list =['a','b','c','d'];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: DropdownButtonFormField<String>(
        //value: selectedCategory,

        decoration: InputDecoration(
          labelText: "Select Category",
            labelStyle: AppTypography.bodyLabel(16,AppColors.whiteColor500),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0x66A8C7FA), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0x66A8C7FA), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0x66A8C7FA), width: 1.5),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        icon: const Icon(Icons.keyboard_arrow_down_sharp, size: 24, color: AppColors.whiteColor),
        dropdownColor: const Color(0xFF0E1466),
        items: list!.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child:Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.whiteColor,),
            ),
          );
        }).toList(),
        onChanged: (_){},
        isExpanded: true,
        validator: (value) => value == null ? 'Please select a category' : null,
        style: const TextStyle(color: AppColors.whiteColor,overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
