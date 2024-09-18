import 'package:dor_companion/login_view/mobile_number_verify/login_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitButton extends StatelessWidget {
  final LogInViewController controller = Get.find<LogInViewController>();

  SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        margin: const EdgeInsets.only(left: 30, right: 30,top: 30),
        height: 50,
        width: double.infinity,
        decoration: controller.mobNum.value.length == 10 && controller.isPrivacyPolicyChecked.value
            ? ShapeDecoration(
                color: Colors.white.withOpacity(0.96),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
            : ShapeDecoration(
                color: const Color(0x725E5E5E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: TextButton(
            onPressed: () {
              if (controller.currentStatus.value.name == LoginPageStatus.MOBILE_NUMBER.name) {
                if(controller.mobNum.value.length == 10 && controller.isPrivacyPolicyChecked.value) {
                  controller.requestOtp(context);
                }
              } else if (controller.currentStatus.value.name == LoginPageStatus.PROFILE_VERIFICATION.name) {
                controller.signUp();
              }
            },
            child: Text(controller.getSubmitButtonLabel(),
                style: controller.isPostingNumber.value
                    ? const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        height: 0)
                    : const TextStyle(
                        color: Color(0xFF5E5E5E),
                        fontSize: 17,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        height: 0)))));
  }
}
