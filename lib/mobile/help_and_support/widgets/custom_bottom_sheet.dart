import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomSheet extends StatelessWidget{
  final Widget content;
   const CustomBottomSheet({super.key,required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF080C42),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 5,
                decoration: ShapeDecoration(
                  color: const Color(0x4CEBEBF5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 42),
            content
          ],
        ),
      ),
    );
  }

}

class MenuItem extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              icon ?? "", // Top image
              fit: BoxFit.fill,
              height: 28,
              width: 28,
              color: Colors.white,
            ),
            const SizedBox(width: 16),
            Text(text,
                style: AppTypography.settingsViewSubTitle
                    .copyWith(fontFamily: "F Pro",color: Colors.white)),
          ],
        ),
      ),
    );
  }
}