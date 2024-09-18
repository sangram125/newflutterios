import 'package:dor_companion/assets.dart';
import 'package:dor_companion/redesign/login/login_vm.dart';
import 'package:dor_companion/redesign/login/view/login_bottom_sheet.dart';
import 'package:dor_companion/widgets/phone_number_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          width: 55,
          height: 4,
          decoration: ShapeDecoration(
              color: const Color(0xFF4D4D4D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
      const SizedBox(height: 38),
      const Text('Login',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontFamily: 'DMSerifDisplay',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.20)),
      const SizedBox(height: 8),
      const Text('Use the registered number you\nused to login on TV',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xFFB2B2B2),
              fontSize: 14,
              fontFamily: 'DMSans',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.20)),
      const SizedBox(height: 34),
      Consumer<LoginVm>(
          builder: (context, value, child) => TextFormField(
              controller: value.mobileNumberController,
              autofocus: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.20),
              onChanged: (query) => value.onChangeMobileNumber(query),
              decoration: InputDecoration(
                  hintText: 'Registered mobile number',
                  hintStyle: const TextStyle(
                      color: Color(0xFF808080),
                      fontSize: 16,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.20),
                  prefixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(width: 24),
                    SvgPicture.asset(Assets.assets_images_login_images_india_flag_svg),
                    const SizedBox(width: 10),
                    const Text('+91',
                        style: TextStyle(
                            color: Color(0xFFE5E5E5),
                            fontSize: 16,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.20)),
                    const SizedBox(width: 10)
                  ]),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(30)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Color(0xFF666666)),
                      borderRadius: BorderRadius.circular(30)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Color(0xFF666666)),
                      borderRadius: BorderRadius.circular(30)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Theme.of(context).colorScheme.error),
                      borderRadius: BorderRadius.circular(30)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.error),
                      borderRadius: BorderRadius.circular(30))))),
      const SizedBox(height: 20),
      Row(children: [
        Consumer<LoginVm>(
            builder: (context, value, child) => CustomCheckbox(
                isChecked: value.agreeToTerms, onChanged: (val) => value.setAgreeToTerms(!val!))),
        const SizedBox(width: 12),
        Expanded(
            child: RichText(
                text: TextSpan(style: TextStyle(color: Colors.grey[400], fontSize: 12), children: const [
          TextSpan(text: 'By checking this, I agree to your '),
          TextSpan(text: 'terms of use', style: TextStyle(color: Colors.blue)),
          TextSpan(text: ' & '),
          TextSpan(text: 'privacy policy', style: TextStyle(color: Colors.blue))
        ])))
      ]),
      const SizedBox(height: 36),
      Consumer<LoginVm>(
          builder: (context, value, child) => ElevatedButton(
              onPressed: () {
                if (value.enableButton) {
                  showPhoneConfirmationDialog(
                      onConfirm: () {
                        Navigator.of(context).pop();
                        value.otpRequest();
                      },
                      onEdit: () => Navigator.of(context).pop(),
                      context: context,
                      phoneNumber: value.mobileNumberController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: value.enableButton ? Colors.white : const Color(0xFF333333),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Get OTP',
                    style: TextStyle(
                        color: value.enableButton ? Colors.black : const Color(0xFF666666),
                        fontSize: 16,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.20)),
                const SizedBox(width: 8),
                SvgPicture.asset(Assets.assets_images_login_images_next_icon_svg)
              ])))
    ]);
  }
}
