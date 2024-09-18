import 'package:auto_size_text/auto_size_text.dart';
import 'package:dor_companion/login_view/mobile_number_verify/login_view_controller.dart';
import 'package:dor_companion/login_view/widgets/mobile_number_field.dart';
import 'package:dor_companion/login_view/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../widgets/gradient_background_onboarding.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: GradientBackgroundOnBoarding(child: LoginForm())));
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logInViewController = Get.find<LogInViewController>();
    return Obx(() => Stack(children: [
          Center(
              child: SingleChildScrollView(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            _buildDorLogo(),
            const SizedBox(height: 20),
            _buildHeaderText(logInViewController),
            _buildSubtitle(),
            if (logInViewController.currentStatus.value.name == LoginPageStatus.PROFILE_VERIFICATION.name)
              _buildNameFields(logInViewController, context),
            if (logInViewController.currentStatus.value.name == LoginPageStatus.MOBILE_NUMBER.name)
              MobileNumberField(label: 'MOBILE NUMBER'),
            SubmitButton()
          ]))),
          if (logInViewController.loading.value)
            Container(
              color: Colors.black.withOpacity(0.5),
              //  child: const Center(child: CircularProgressIndicator()),
            )
        ]));
  }

  Widget _buildDorLogo() {
    return Center(
        child: SizedBox(width: 200, height: 95, child: SvgPicture.asset("assets/icons/icon_dor.svg")));
  }

  Widget _buildHeaderText(LogInViewController controller) {
    return const AutoSizeText("Sign into your Dor account",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Color(0xFFF2F2F2),
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.40));
  }

  Widget _buildSubtitle() {
    return const Padding(
        padding: EdgeInsets.all(10),
        child: AutoSizeText('Get the most out of your Dor stream',
            style: TextStyle(
                color: Color(0xFFE2E2E2),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25),
            maxLines: 1));
  }

  Widget _buildNameFields(LogInViewController controller, BuildContext context) {
    return Column(children: [
      controller.buildNameField(context, 'FIRST NAME', controller.firstNameController),
      const SizedBox(height: 18),
      controller.buildNameField(context, 'LAST NAME', controller.lastNameController),
      const SizedBox(height: 18)
    ]);
  }
}
