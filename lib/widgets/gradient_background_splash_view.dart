import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradientBackgroundSplashView extends StatefulWidget {
  final Widget child;

  const GradientBackgroundSplashView({Key? key, required this.child}) : super(key: key);

  @override
  State<GradientBackgroundSplashView> createState() => _GradientBackgroundSplashViewState();
}

class _GradientBackgroundSplashViewState extends State<GradientBackgroundSplashView> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height, // Set to cover the entire screen
      child: Center(
        child: Stack(

          children: [
            Image.asset('assets/icons/splash.png',
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            widget.child
          ],
        ),
      ),
    );
  }
}
