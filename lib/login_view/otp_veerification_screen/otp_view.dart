import 'dart:async';
import 'dart:io';

import 'package:dor_companion/login_view/gradient_background_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:telephony/telephony.dart';

import '../mobile_number_verify/login_view_controller.dart';

class VerifyOtpWidget extends StatefulWidget {
  final StreamController<int> countdownController;
  final void Function(String) onVerifyOtp;
  final VoidCallback onRequestOtpResetCountdown;
  final VoidCallback onOTPSubmitted;
  final String number;
  final bool isVerifyingOtp;
  final FocusNode focusNode;

  const VerifyOtpWidget(
      {Key? key,
      required this.isVerifyingOtp,
      required this.number,
      required this.countdownController,
      required this.onVerifyOtp,
      required this.focusNode,
      required this.onRequestOtpResetCountdown,
      required this.onOTPSubmitted})
      : super(key: key);

  @override
  _VerifyOtpWidgetState createState() => _VerifyOtpWidgetState();
}

class _VerifyOtpWidgetState extends State<VerifyOtpWidget> {
  final controller = Get.find<LogInViewController>();
  final otpTextEditController = TextEditingController();

  @override
  void initState() {
    smsAutoFill();
    super.initState();
  }

  void smsAutoFill() {
    if (Platform.isAndroid) {
      Telephony telephony = Telephony.instance;
      telephony.listenIncomingSms(
          onNewMessage: (SmsMessage message) async {
            print('message ${message.body}');
            debugPrint('address${message.address}');
            debugPrint(message.body);
            debugPrint(message.date.toString());
            String sms = message.body.toString();
            if (message.body!
                .contains('is your one time password (OTP) for login into your DOR Account. DOR')) {
              String otpCode = sms.replaceAll(RegExp(r'[^0-9]'), '');
              otpTextEditController.text = otpCode;
              setState(() {});
              controller.updateOtp(otpCode);
              debugPrint("before submit OTP: ${otpTextEditController.text}");
              Timer(const Duration(seconds: 1), () => controller.submit(context));
            } else {
              debugPrint("Normal message.");
            }
          },
          listenInBackground: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
        width: 46,
        height: 53,
        textStyle: const TextStyle(fontSize: 14, fontFamily: 'Roboto', color: Colors.white),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.deepOrange),
            borderRadius: BorderRadius.circular(5)));

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
        color: Colors.transparent,
        border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
        borderRadius: BorderRadius.circular(5));
    final submittedPinTheme =
        defaultPinTheme.copyWith(decoration: defaultPinTheme.decoration!.copyWith(color: Colors.transparent));
    return Scaffold(
        body: SafeArea(
            child: GradientBackgroundOnBoarding(
                child: Container(
                    color: const Color(0x490B0F47),
                    height: double.infinity,
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                          _buildHeader(context),
                          // FlutterDynamicOTP(
                          //     digitsLength: 6,
                          //     controller: otpTextEditController,
                          //     textInputType: TextInputType.number,
                          //     digitDecoration: InputDecoration(
                          //         counter: const Offstage(),
                          //         enabledBorder: OutlineInputBorder(
                          //             borderSide: const BorderSide(width: 1, color: Colors.deepOrange),
                          //             borderRadius: BorderRadius.circular(5)),
                          //         focusedBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(
                          //                 width: 1,
                          //                 color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4)),
                          //             borderRadius: BorderRadius.circular(5))),
                          //     digitsPadding: 4,
                          //     onSubmit: (p0) => widget.onOTPSubmitted(),
                          //     digitHeight: kToolbarHeight + 5,
                          //     digitWidth: kToolbarHeight - 10,
                          //     onChanged: (p0) {
                          //       debugPrint('p1----- $p0');
                          //       if (p0.length == 6) {
                          //         debugPrint('api-call');
                          //         controller.updateOtp(p0);
                          //         controller.submit(context);
                          //       }
                          //     }),
                          const SizedBox(height: 30),
                          Pinput(
                              length: 6,
                              showCursor: true,
                              autofocus: true,
                              defaultPinTheme: PinTheme(
                                  width: 46,
                                  height: 53,
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(30, 60, 87, 1),
                                      fontWeight: FontWeight.w600),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: Colors.deepOrange),
                                      borderRadius: BorderRadius.circular(5))),
                              focusedPinTheme: focusedPinTheme,
                              errorText: '',
                              submittedPinTheme: submittedPinTheme,
                              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.number,
                              controller: otpTextEditController,
                              onSubmitted: (val) => widget.onOTPSubmitted(),
                              onChanged: (pin) {
                                if (pin.length == 6) {
                                  debugPrint('api-call');
                                  controller.updateOtp(pin);
                                  controller.submit(context);
                                }
                              }),
                          const SizedBox(height: 30),
                          // Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal: 34),
                          //     child: PinFieldAutoFill(
                          //         controller: otpTextEditController,
                          //         autoFocus: true,
                          //         keyboardType: TextInputType.number,
                          //         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          //         cursor: Cursor(
                          //             width: 2,
                          //             height: 20,
                          //             color: Colors.deepOrange,
                          //             radius: const Radius.circular(1),
                          //             enabled: true),
                          //         decoration: BoxLooseDecoration(
                          //             radius: const Radius.circular(5),
                          //             textStyle: const TextStyle(
                          //                 fontSize: 14, fontFamily: 'Roboto', color: Colors.white),
                          //             strokeColorBuilder: const FixedColorBuilder(Colors.deepOrange)),
                          //         onCodeSubmitted: (code) => widget.onOTPSubmitted(),
                          //         onCodeChanged: (code) {
                          //           if (code!.length == 6) {
                          //             debugPrint('api-call');
                          //             controller.updateOtp(code);
                          //             FocusScope.of(context).requestFocus(FocusNode());
                          //             controller.submit(context);
                          //           }
                          //         })),
                          _buildResendOtpSection()
                        ]))))));
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height *
                (MediaQuery.of(context).viewInsets.bottom != 0 ? 0.09 : 0.15)),
        child: Column(children: [
          SvgPicture.asset('assets/icons/icon_dor_play.svg', height: 32, width: 55),
          const SizedBox(height: 18),
          const Text('Sign into your Dor account',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFFF2F2F2),
                  fontSize: 24,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.40)),
          const SizedBox(height: 18),
          _buildOtpInstructionText()
        ]));
  }

  Widget _buildOtpInstructionText() {
    return Text.rich(TextSpan(children: [
      const TextSpan(
          text: 'Enter the OTP sent to',
          style: TextStyle(
              color: Color(0xFF8F8F8F),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25)),
      const TextSpan(text: ' '),
      TextSpan(
          text: '+91 ${widget.number} ',
          style: const TextStyle(
              color: Color(0xFF5AC8F5),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25))
    ]));
  }

  Widget _buildResendOtpSection() {
    final controller = Get.find<LogInViewController>();
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Didn't receive OTP?  ",
          style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15)),
      Obx(() => controller.countdown.value == 0
          ? Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: InkWell(
                  onTap: widget.onRequestOtpResetCountdown,
                  child: const Text("Send again",
                      style: TextStyle(color: Colors.blue, fontSize: 16, letterSpacing: 0.15))))
          : Text('${controller.countdown}s',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15)))
    ]);
  }
}
