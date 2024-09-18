import 'package:dor_companion/assets.dart';
import 'package:dor_companion/redesign/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpWidget extends StatelessWidget {
  const OtpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
        width: 46,
        height: 53,
        textStyle: const TextStyle(
            fontSize: 22, fontFamily: 'Roboto', color: Colors.white, fontWeight: FontWeight.w700),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: const Color(0xFF666666)),
            borderRadius: BorderRadius.circular(60)));
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
        color: Colors.transparent,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(60));
    final followingPinTheme = defaultPinTheme.copyDecorationWith(
        color: Colors.transparent,
        border: Border.all(color: const Color(0xFF666666)),
        borderRadius: BorderRadius.circular(60));
    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
        color: Colors.transparent,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(60));
    return Column(children: [
      Container(
          width: 55,
          height: 4,
          decoration: ShapeDecoration(
              color: const Color(0xFF4D4D4D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
      const SizedBox(height: 38),
      const Text('Enter the OTP sent to',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontFamily: 'DMSerifDisplay',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.20)),
      const SizedBox(height: 8),
      Consumer<LoginVm>(
          builder: (context, value, child) => Text('+91 ${value.mobileNumberController.text}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFFB2B2B2),
                  fontSize: 14,
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.20))),
      const SizedBox(height: 40),
      Consumer<LoginVm>(
          builder: (context, value, child) => Pinput(
              length: 6,
              showCursor: false,
              autofocus: true,
              isCursorAnimationEnabled: false,
              defaultPinTheme: PinTheme(
                  width: 46,
                  height: 53,
                  textStyle: const TextStyle(
                      fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.deepOrange),
                      borderRadius: BorderRadius.circular(40))),
              focusedPinTheme: focusedPinTheme,
              errorText: '',
              preFilledWidget: SvgPicture.asset(Assets.assets_icons_custom_cursor_svg),
              submittedPinTheme: submittedPinTheme,
              followingPinTheme: followingPinTheme,
              closeKeyboardWhenCompleted: false,
              pinputAutovalidateMode: PinputAutovalidateMode.disabled,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              controller: value.otpController,
           //  onSubmitted: (val) => value.submitOtp(),
              onChanged: (pin) {
                if (pin.length == 6) {
                  value.submitOtp();
                }
              })),
      const SizedBox(height: 26),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Didn't receive OTP?  ",
            style: TextStyle(
                color: Color(0xFFB2B2B2),
                fontSize: 14,
                fontFamily: 'DMSans',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.20)),
        Consumer<LoginVm>(
            builder: (context, value, child) => Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: value.countDownRunning
                    ? Text('${value.countDownValue} sec',
                        style: const TextStyle(
                            color: Color(0xFF4D7DF1),
                            fontSize: 14,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.20))
                    : InkWell(
                        onTap: () => value.startTimer(),
                        child: const Text('Resend OTP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF4D7DF1),
                                fontSize: 14,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20))))),
        const SizedBox(height: 90)
      ])
    ]);
  }
}
