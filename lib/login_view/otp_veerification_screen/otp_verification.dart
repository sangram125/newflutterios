import 'package:dor_companion/login_view/gradient_background_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class OtpVerificationWidget extends StatefulWidget {
  const OtpVerificationWidget({super.key});

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: GradientBackgroundOnBoarding(
                child: Container(
                    color: const Color(0x490B0F47),
                    height: double.infinity,
                    width: double.infinity,
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  (MediaQuery.of(context).viewInsets.bottom != 0 ? 0.09 : 0.15)),
                          SvgPicture.asset('assets/icons/icon_dor_play.svg', height: 32, width: 55),
                          const SizedBox(height: 18),
                          const Text('Verifying OTP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFFF2F2F2),
                                  fontSize: 24,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: -0.40)),
                          const SizedBox(height: 25),
                          const Text("Hang in there, we’re getting your account info",
                              style: TextStyle(
                                  color: Color(0xFF8F8F8F),
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  height: 0.12,
                                  letterSpacing: 0.25)),
                          const SizedBox(height: 25),
                          Lottie.asset('assets/json/loading.json', width: 80, height: 80)
                        ]))))));
  }
}
