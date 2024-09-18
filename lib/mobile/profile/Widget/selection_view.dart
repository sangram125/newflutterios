import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectionView extends StatelessWidget {
   final String? title;
   final String? iconPath;
   Function()? onTap;
   SelectionView(
      {Key? key, required this.title, required this.iconPath, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration:   BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient:   LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xFF5E5E5E).withOpacity(0.18),const Color(0xFF5E5E5E).withOpacity(0.18),const Color(0xFF5E5E5E).withOpacity(0.12)],

            ),
          ),
          child: Center(
            child: Column(
             // alignment: Alignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(iconPath ?? "", // Top image
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 10,),
                Text(title ?? "", style: AppTypography.profileViewMainTitle,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
