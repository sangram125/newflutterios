import 'package:dor_companion/assets.dart';
import 'package:dor_companion/redesign/login/view/login_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeLoginPage extends StatefulWidget {
  const WelcomeLoginPage({super.key});

  @override
  State<WelcomeLoginPage> createState() => _WelcomeLoginPageState();
}

class _WelcomeLoginPageState extends State<WelcomeLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Align(
              alignment: Alignment.topCenter,
              child: ClipPath(
                  clipper: ClippingClass(),
                  child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.69,
                      width: MediaQuery.sizeOf(context).width,
                      color: Colors.black,
                      child: Column(children: [
                        const SizedBox(height: 35),
                        Image.asset(Assets.assets_images_login_images_animation_png)
                      ])))),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                  clipper: OvalTopBorderClipper(),
                  child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.62,
                      width: MediaQuery.sizeOf(context).width,
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [Color(0xFF363636), Color(0xFF010008)]),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0),
                            BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0)
                          ]),
                      child: Column(children: [
                        const SizedBox(height: 150),
                        const Text('Welcome to the\nmember-only\nDor app',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontFamily: 'DMSerifDisplay',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20)),
                        const SizedBox(height: 50),
                        SizedBox(
                            height: kToolbarHeight - 10,
                            width: MediaQuery.sizeOf(context).width * 0.6,
                            child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: SvgPicture.asset(Assets.assets_icons_explorer_membership_icon_svg),
                                label: const Text('Explore membership',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700)),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))))),
                        const SizedBox(height: 24),
                        InkWell(
                            onTap: () => showLoginBottomSheet(context),
                            child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.6,
                                height: kToolbarHeight - 10,
                                decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
                                        borderRadius: BorderRadius.circular(100))),
                                child: const Center(
                                    child: Text('Login',
                                        style: TextStyle(
                                            color: Color(0xFFE5E5E5),
                                            fontSize: 16,
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.20)))))
                      ]))))
        ]));
  }
}

class OvalTopBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(size.width / 2, size.height * 0.5, 0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.55);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height * 0.55);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
