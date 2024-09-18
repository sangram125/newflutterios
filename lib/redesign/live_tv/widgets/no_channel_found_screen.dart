import 'package:dor_companion/assets.dart';
import 'package:flutter/material.dart';

class NoChannelFoundView extends StatelessWidget {
  const NoChannelFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF030303),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.assets_images_live_tv_no_channel_found_image_png),
              const SizedBox(height: 72),
              const Text('No Results found!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'DMSerifDisplay',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.20)),
              const SizedBox(height: 24),
              const Text('Check your language / category filters and\ntry again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.20))
            ]));
  }
}
