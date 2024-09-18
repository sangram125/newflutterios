import 'dart:ui';

import 'package:dor_companion/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MembershipDialog extends StatelessWidget {
  final String phoneNumber;

  const MembershipDialog({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(32)),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 32),
                  SvgPicture.asset(Assets.assets_icons_error_icon_svg),
                  const SizedBox(height: 24),
                  const Text("Oops! Looks like your\nmobile number isn't\npart of Dor membership",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.20)),
                  const SizedBox(height: 10),
                  Text('+91 $phoneNumber',
                      style: const TextStyle(
                          color: Color(0xFFE5E5E5),
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.20)),
                  const SizedBox(height: 40),
                  Container(height: 1, width: double.infinity, color: const Color(0xFF666666)),
                  const SizedBox(height: 5),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Use different number',
                          style: TextStyle(
                              color: Color(0xFF7399F4),
                              fontSize: 16,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.20))),
                  const SizedBox(height: 15),
                  SizedBox(
                      height: kToolbarHeight - 18,
                      child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: SvgPicture.asset(Assets.assets_icons_explorer_membership_icon_svg),
                          label: const Text('Explore membership',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.20)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))))),
                  const SizedBox(height: 32)
                ]))));
  }
}

void showMembershipDialog({required BuildContext context, required String phoneNumber}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MembershipDialog(phoneNumber: phoneNumber);
      });
}
