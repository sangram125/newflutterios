import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradientBackgroundOnBoarding extends StatelessWidget{
  final Widget child;

  const GradientBackgroundOnBoarding( {super.key,required this.child,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E1466),
            Color(0x490B0F47),
            Color(0x490B0F47),
            Color(0x490B0F47)],
        ),
      ),

      child: Stack(
        children: [
          Positioned(
            right: 0, // Adjust as needed
            bottom: 20, // Adjust as needed
            child: SvgPicture.asset(
              "assets/images/login_images/triangles.svg",
              width: 300, // Adjust as needed
              height:300, // Adjust as needed
            ),
          ),
          Positioned(
            right: 0, // Adjust as needed
            bottom: 50, // Adjust as needed
            child: SvgPicture.asset(
              "assets/images/login_images/mobile_otp_hand.svg",
              width: 170, // Adjust as needed
              height:170, // Adjust as needed
            ),
          ),
          child
        ],
      ),);
  }

}