import 'package:dor_companion/redesign/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _showKeyboard() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showKeyboard, // Show keyboard when tapped
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            Container(
              width: 55,
              height: 4,
              decoration: ShapeDecoration(
                color: const Color(0xFF4D4D4D),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 38),
            const Text(
              'Enter the OTP sent to',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontFamily: 'DMSerifDisplay',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.20,
              ),
            ),
            const SizedBox(height: 8),
            Consumer<LoginVm>(
              builder: (context, value, child) => Text(
                '+91 ${value.mobileNumberController.text}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFB2B2B2),
                  fontSize: 14,
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.20,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Icon(Icons.cloud_download),
            // Hidden TextField to trigger keyboard
            Visibility(
              visible: false,
              child: TextField(
                autofocus: true,
                focusNode: _focusNode,
                style: const TextStyle(color: Colors.transparent), // Make text invisible
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter OTP',
                  hintStyle: TextStyle(color: Colors.transparent), // Make hint invisible
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}