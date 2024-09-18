import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final String? iconPath;
  final Function()? onTap;
  final Color color;
  const CustomCard(
      {Key? key,
        required this.title,
        required this.iconPath,
        required this.onTap,
        required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            // alignment: Alignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath ?? "", // Top image
                fit: BoxFit.fill,
                height: 36,
                width: 36,
                color: Colors.black,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                title ?? "",
                style: AppTypography.profileViewMainTitle
                    .copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
