import 'dart:ui';

import 'package:flutter/material.dart';

class PreventPopupDialog extends StatelessWidget {
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;

  const PreventPopupDialog({
    Key? key,
    required this.onYesPressed,
    required this.onNoPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(32)),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Padding(
                      padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 32),
                      child: Text('Do you want to stop the OTP\nverification process?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFE5E5E5),
                              fontSize: 16,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20))),
                  Container(height: 1, width: double.infinity, color: const Color(0xFF666666)),
                  SizedBox(
                      height: kToolbarHeight - 5,
                      width: double.infinity,
                      child: Row(children: [
                        Expanded(
                            child: TextButton(
                                onPressed: onYesPressed,
                                child: const Text('Yes, stop',
                                    style: TextStyle(
                                        color: Color(0xFFC95159),
                                        fontSize: 16,
                                        fontFamily: 'DMSans',
                                        letterSpacing: 0.20)))),
                        Container(width: 0.5, height: kToolbarHeight - 5, color: Colors.grey),
                        Expanded(
                            child: TextButton(
                                onPressed: onNoPressed,
                                child: const Text('No',
                                    style: TextStyle(
                                        color: Color(0xFF7399F4),
                                        fontSize: 16,
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.20))))
                      ]))
                ]))));
  }
}
