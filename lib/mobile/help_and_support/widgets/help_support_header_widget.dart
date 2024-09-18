import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HelpAndSupportHeaderWidget extends StatelessWidget{
  final String title;
  final VoidCallback? onPressed;


  const HelpAndSupportHeaderWidget({super.key,required this.title,
    this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: IconButton(
              onPressed:onPressed??()=> context.pop(),
              icon: SvgPicture.asset(
                'assets/icons/arrow_back.svg',
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Text(
                title,
                style: AppTypography.languageViewTitle.copyWith(
                    fontSize:18
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}