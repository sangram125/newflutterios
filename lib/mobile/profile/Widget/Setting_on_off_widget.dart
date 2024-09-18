import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/mobile/profile/Widget/switch_button.dart';
import 'package:dor_companion/mobile/profile/controller/profile_controller.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SettingOnOffWidget extends StatelessWidget {
  final String? title;
  final String? iconPath;
  final bool isNotificationMenu;
  Function()? onTap;

  SettingOnOffWidget(
      {Key? key,required this.title, required this.iconPath,required this.onTap, required this.isNotificationMenu })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      decoration: isNotificationMenu ? null :
      BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.white.withOpacity(0.10000000149011612),
          ),
        ),
      ),
      child: Row(
        children: [
          isNotificationMenu ? Container() : SvgPicture.asset(
            iconPath!,
            // Adjust the height as needed
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                title!,
                style: AppTypography.settingsViewTitle,
              ),
            ),
          ),
          SwitchButton(switchValue: false,onTap: (){},)
        ],
      ),
    );
  }
}
