import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class TextFormFieldWidget extends StatelessWidget {
  TextEditingController controller;
  String? hintText;
  bool? isPrefixRequired = false;
   TextFormFieldWidget({super.key, required this.controller, this.hintText, this.isPrefixRequired});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24),
              child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 25),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(200)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color:  AppColors.whiteColor600),
                          borderRadius: BorderRadius.circular(200)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color:  AppColors.whiteColor600),
                          borderRadius: BorderRadius.circular(200)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Theme.of(context).colorScheme.error),
                          borderRadius: BorderRadius.circular(200)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.error),
                          borderRadius: BorderRadius.circular(200)),
                      labelStyle:AppTypography.bodyLabel(16,AppColors.whiteColor500),
                      labelText: hintText ??"",
                      helperText: ' ',
                      prefixIcon: isPrefixRequired ?? false ? Icon(Icons.flag): null,
                      prefixText: "+91",
                      //errorText: "error text",
                      prefixStyle: AppTypography.headingMed(16,AppColors.whiteColor),
                      floatingLabelBehavior: FloatingLabelBehavior.auto)))
        ]));
  }
}