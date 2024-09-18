import 'dart:ui';

import 'package:flutter/material.dart';

class PhoneNumberConfirmationDialog extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onEdit;
  final VoidCallback onConfirm;

  const PhoneNumberConfirmationDialog(
      {Key? key, required this.phoneNumber, required this.onEdit, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                decoration:
                    BoxDecoration(color: const Color(0x99515151), borderRadius: BorderRadius.circular(32)),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 24),
                  Text('+91 $phoneNumber',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.20)),
                  const SizedBox(height: 8),
                  const Text('Is this your correct number?',
                      style: TextStyle(
                          color: Color(0xFFE5E5E5),
                          fontSize: 16,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.20)),
                  const SizedBox(height: 32),
                  Container(height: 1, width: double.infinity, color: const Color(0xFF666666)),
                  SizedBox(
                      height: kToolbarHeight - 5,
                      width: double.infinity,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        Expanded(
                            child: TextButton(
                                onPressed: onEdit,
                                child: const Text('Edit',
                                    style: TextStyle(
                                        color: Color(0xFF7399F4),
                                        fontSize: 16,
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.20)))),
                        Container(width: 0.8, height: kToolbarHeight - 5, color: Colors.grey),
                        Expanded(
                            child: TextButton(
                                onPressed: onConfirm,
                                child: const Text('Yes',
                                    style: TextStyle(
                                        color: Color(0xFF7399F4),
                                        fontSize: 16,
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.20))))
                      ]))
                ]))));
  }
}

void showPhoneConfirmationDialog(
    {required BuildContext context,
    required String phoneNumber,
    required void Function() onEdit,
    required void Function() onConfirm}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PhoneNumberConfirmationDialog(
            phoneNumber: phoneNumber, onEdit: () => onEdit(), onConfirm: () => onConfirm());
      });
}
