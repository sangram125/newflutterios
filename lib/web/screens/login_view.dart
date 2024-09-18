import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/api/sensy_api.dart';
import '../../data/models/models.dart';
import '../../data/models/user_account.dart';
import '../../injection/injection.dart';
import '../../utils.dart';
import '../../widgets/loader.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static const countryCode = "+91";

  List<String> appLogos = [];

  final mobNumController = TextEditingController();
  final otpController = TextEditingController();

  String mobNum = '';

  bool isPostingNumber = false;
  bool isVerifyingOtp = false;

  String mobNumError = '';
  String otpError = '';

  @override
  void initState() {
    super.initState();
    _fetchLogos();
  }

  _fetchLogos() async {
    final appLogos = await _initAppLogos(context);
    setState(() {
      this.appLogos = appLogos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildHeroBanner(context),
          const SizedBox(height: 48),
          buildLoginForm(context),
          const SizedBox(height: 64),
          buildTnC(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget buildHeroBanner(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 600,
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.width / 10,
            left: MediaQuery.of(context).size.width / 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDorLogo(),
                const SizedBox(height: 48),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    "Endless entertainment, bundled up in one easy subscription",
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.normal,
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...buildAppLogos(),
                    Text(
                      " & more",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 8 - 20,
            right: MediaQuery.of(context).size.width / 8,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: const Image(
                alignment: Alignment.center,
                fit: BoxFit.cover,
                image:
                    AssetImage("assets/images/login_images/homepage_tv_2.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildAppLogos() {
    List<Widget> logos = [];
    if (appLogos.isEmpty) {
      return logos;
    }

    for (final logo in appLogos) {
      logos.add(getAppLogoWidget(logo));
    }

    return logos;
  }

  Widget getAppLogoWidget(String path) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Image(
          alignment: Alignment.center,
          fit: BoxFit.cover,
          image: AssetImage(path),
        ),
      ),
    );
  }

  Widget buildDorLogo() {
    return SizedBox(
      width: 120,
      height: 57,
      child: SvgPicture.asset(
        "assets/icons/icon_dor_play.svg",
      ),
    );
  }

  Widget buildLoginForm(BuildContext context) {
    return Column(
      children: <Widget>[
        buildMobileNumberField(context),
        const SizedBox(height: 8),
        buildOtpField(context),
        const SizedBox(height: 8),
        buildSubmitButton(context),
      ],
    );
  }

  Widget buildMobileNumberField(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        SizedBox(
          width: 350,
          child: TextFormField(
            onFieldSubmitted: (value) => mobNum.isEmpty ? requestOtp() : null,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            controller: mobNumController,
            keyboardType: TextInputType.phone,
            enabled: !isPostingNumber && mobNum.isEmpty,
            style: TextStyle(
              color: !isPostingNumber && mobNum.isEmpty
                  ? Colors.white
                  : Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 25),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.error,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.error,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              labelStyle: TextStyle(
                  color: !isPostingNumber && mobNum.isEmpty
                      ? Colors.white
                      : Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.4)),
              labelText: 'Mobile Number',
              helperText: ' ',
              errorText: mobNumError.isNotEmpty ? mobNumError : null,
              prefixText: "$countryCode ",
              prefixStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ),
        ),
        // ProgressIndicator visible when posting a number
        Visibility(
          visible: isPostingNumber && mobNum.isEmpty,
          child: const Padding(
            padding: EdgeInsets.only(right: 14, bottom: 22),
            child: Loader(),
          ),
        ),
        // Edit button visible after submitting a number but before
        // verifying OTP
        Visibility(
          visible: mobNum.isNotEmpty && !isVerifyingOtp,
          child: IconButton(
            padding: const EdgeInsets.only(right: 14, bottom: 24),
            onPressed: editNumber,
            icon: const Icon(Icons.edit),
          ),
        ),
      ],
    );
  }

  Widget buildOtpField(BuildContext context) {
    return Visibility(
      visible: mobNum.isNotEmpty,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: SizedBox(
        width: 350,
        child: TextFormField(
          onFieldSubmitted: (value) => verifyOtp(),
          inputFormatters: [
            LengthLimitingTextInputFormatter(8),
          ],
          controller: otpController,
          keyboardType: TextInputType.phone,
          enabled: !isVerifyingOtp && mobNum.isNotEmpty,
          decoration: InputDecoration(
            suffixIcon: isVerifyingOtp
                ? Container(
                    width: 26,
                    padding: const EdgeInsets.only(right: 10),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 26,
                        height: 26,
                        child: Loader(),
                      ),
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.only(left: 25),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 2,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).colorScheme.error,
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).colorScheme.error,
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
            labelStyle: TextStyle(
                color:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.4)),
            labelText: 'OTP',
            helperText: ' ',
            errorText: otpError.isNotEmpty ? otpError : null,
          ),
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
          color: isVerifyingOtp || isPostingNumber
              ? Theme.of(context).colorScheme.onSecondary.withOpacity(0.4)
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(50)),
      child: TextButton(
        onPressed: () => mobNum.isEmpty ? requestOtp() : verifyOtp(),
        child: Text(
          mobNum.isNotEmpty
              ? isVerifyingOtp
                  ? 'Verifying'
                  : 'Verify'
              : isPostingNumber
                  ? 'Submitting'
                  : 'Login/Sign Up',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget buildTnC() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              launchUrl(Uri.parse("https://dorplay.tv/terms-and-conditions/"));
            },
            child: const Text(
              "Terms & Conditions",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              launchUrl(Uri.parse("https://dorplay.tv/privacy-policy/"));
            },
            child: const Text(
              "Privacy Policy",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  requestOtp() async {
    final tempMobileNum = mobNumController.text;

    if (tempMobileNum.isEmpty ||
        tempMobileNum.length != 10 ||
        !isPositiveNumber(tempMobileNum)) {
      return;
    }

    otpController.text = "";
    setState(() {
      isPostingNumber = true;
      mobNumError = "";
      otpError = "";
    });

    MobileNumber number = MobileNumber(
      countryCode: countryCode,
      number: tempMobileNum,
    );

    getIt<SensyApi>()
        .requestCrmOtp(number)
        .then((value) => setState(() {
              isPostingNumber = false;
              mobNum = tempMobileNum;
            }))
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          setState(() {
            isPostingNumber = false;
            mobNumError =
                "Failed to submit, try again: ${response?.statusCode}";
          });
      }
    });
  }

  verifyOtp() {
    final tempOtp = otpController.text;
    if (tempOtp.isEmpty || !isPositiveNumber(tempOtp)) {
      return;
    }

    setState(() {
      isVerifyingOtp = true;
      otpError = "";
    });

    MobileNumber number = MobileNumber(
      countryCode: countryCode,
      number: mobNum,
      otp: tempOtp,
    );

    getIt<SensyApi>()
        .verifyCrmOtp(number)
        .then(getIt<UserAccount>().loginUser)
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          if (kDebugMode) {
            print("Error code ${response?.statusCode}, ${response.toString()}");
          }
          setState(() {
            isVerifyingOtp = false;
            otpError =
                "Failed to verify OTP, try again. Status: ${response?.statusCode}";
          });
      }
    });
  }

  void editNumber() {
    setState(() {
      mobNumError = "";
      mobNum = "";
      otpError = "";
    });
  }

  @override
  void dispose() {
    mobNumController.dispose();
    otpController.dispose();
    super.dispose();
  }
}

Future<List<String>> _initAppLogos(BuildContext context) async {
  final manifestContents =
      await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContents);
  return manifestMap.keys
      .where((element) => element.contains('login_images/app_'))
      .toList(growable: false);
}
