import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradientBackgroundOnBoarding extends StatelessWidget {
  final Widget child;

  const GradientBackgroundOnBoarding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0E1466), Color(0x490B0F47), Color(0x490B0F47), Color(0x490B0F47)])),
        child: Stack(children: [
          Positioned(
              right: 20,
              bottom: 20,
              child: SvgPicture.asset("assets/images/login_images/triangles.svg", width: 300, height: 300)),
          child
        ]));
  }
}
