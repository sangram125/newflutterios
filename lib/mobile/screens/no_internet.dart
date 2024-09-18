import 'package:dor_companion/assets.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF030303),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF030303),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.assets_images_live_tv_no_internet_image_png),
                  const SizedBox(height: 72),
                  const Text('Whoops!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'DMSerifDisplay',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.20)),
                  const SizedBox(height: 24),
                  const Text('No internet connection found. Check your\nconnection and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.20))
                ])));
  }
}
