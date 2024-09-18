
import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayScreenButton extends StatelessWidget {
  final String title;
  final SvgPicture imageWidget;
  final VoidCallback onPressed;

  const PlayScreenButton({
    super.key,
    required this.title,
    required this.imageWidget,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            border:
            Border.all(color: Colors.white.withOpacity(0.20), width: 1.0),
            borderRadius: const BorderRadius.all(
                Radius.circular(500.0) //                 <--- border radius here
            ),
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageWidget,
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: AppTypography.mediaHeaderTitleImageText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}