import 'dart:ffi';

import 'package:dor_companion/login_view/mobile_number_verify/login_view_controller.dart';
import 'package:dor_companion/mobile/privacy_policy/privacy_policy.dart';
import 'package:dor_companion/mobile/terms_and_conditions/terms_and_conditions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MobileNumberField extends StatelessWidget {
  final String label;

  final LogInViewController controller = Get.find<LogInViewController>();

  MobileNumberField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
          child: Obx(() => TextFormField(
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) {
                controller.mobNum.value = value;
                controller.update();
              },
              toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: true),
              inputFormatters: [
                label == "MOBILE NUMBER"
                    ? FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    : FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                label == "MOBILE NUMBER"
                    ? LengthLimitingTextInputFormatter(10)
                    : LengthLimitingTextInputFormatter(100)
              ],
              controller: controller.mobNumController,
              keyboardType: label == "MOBILE NUMBER" ? TextInputType.phone : TextInputType.text,
              style: TextStyle(
                  color: !controller.isPostingNumber.value && controller.mobNum.isEmpty
                      ? Colors.white
                      : const Color(0xFFF2F2F2),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500),
              validator: (value) {
                if (label == "MOBILE NUMBER") {
                  if (value!.isEmpty) {
                    return "Mobile number is required";
                  } else if (value.length < 10) {
                    return "Mobile number should be 10 digits";
                  } else {
                    return null;
                  }
                }
                return null;
              },
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 25),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(5)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Color(0x66A8C7FA)),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Color(0xFFA8C7FA)),
                      borderRadius: BorderRadius.circular(5)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Theme.of(context).colorScheme.error),
                      borderRadius: BorderRadius.circular(5)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.error),
                      borderRadius: BorderRadius.circular(5)),
                  labelStyle: TextStyle(
                      color: !controller.isPostingNumber.value && controller.mobNum.isEmpty
                          ? Colors.white
                          : const Color(0xFFF2F2F2),
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400),
                  suffixIcon: Visibility(
                      visible: controller.loading.value,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: 8,
                              height: 8,
                              child: CircularProgressIndicator(
                                  strokeWidth: 3, color: Theme.of(context).colorScheme.tertiary)))),
                  labelText: label,
                  prefixText: label == "MOBILE NUMBER" ? "${controller.countryCode} " : "",
                  prefixStyle: const TextStyle(
                      color: Color(0xFFF2F2F2),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500))))),
      const SizedBox(height: 5),
      Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Row(children: [
            Obx(() => Checkbox(
                activeColor: const Color(0xFFFFFFFF),
                checkColor: Colors.black87,
                value: controller.isPrivacyPolicyChecked.value,
                onChanged: (value) {
                  controller.isPrivacyPolicyChecked.value = !controller.isPrivacyPolicyChecked.value;
                  controller.update();
                })),
            Expanded(
                child: Text.rich(TextSpan(children: [
              const TextSpan(
                  text: 'By Signing up, I agree to dor ',
                  style: TextStyle(
                      color: Color(0xFFC7C7C7),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.25)),
              TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.25),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const PrivacyPolicy(showSearchIcon: false)))),
              const TextSpan(
                  text: ' and ',
                  style: TextStyle(
                      color: Color(0xFFC7C7C7),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.25)),
              TextSpan(
                  text: 'Terms & Conditions',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.25),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsAndConditions(showSearchIcon: false)))),
              const TextSpan(
                  text: '.',
                  style: TextStyle(
                      color: Color(0xFFC7C7C7),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.25))
            ])))
          ]))
    ]);
  }
}
