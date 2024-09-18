import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradientBackgroundAmazonPrimeInitialPage extends StatelessWidget{
  final Widget child;

  const GradientBackgroundAmazonPrimeInitialPage( {super.key,required this.child,});

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
        top: 0, // Adjusted from bottom to top
        right: 0, // Adjust as needed
            child: Image.asset(
              "assets/images/amazon_prime/amazon_prime_background.png",
               // Adjust as needed
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height ,
              fit: BoxFit.fill,
            ),
          ),
          child
        ],
      ),);
  }

}