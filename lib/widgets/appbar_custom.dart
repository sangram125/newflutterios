import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogo;
  final String pageText;
  const LogoAppBar({
    super.key,
    required this.showLogo,
    required this.pageText,});

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return AppBar(
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding:const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showLogo)
              SvgPicture.asset(
                "assets/images/appbar_images/icon_dor_play.svg",
                alignment: Alignment.topLeft,
                height: 30,
                width: 62,
              ),
              if (!showLogo)
              Text(
                pageText,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.3,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: "DMSerifDisplay",
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          // SvgPicture.asset(
          //   "assets/images/appbar_images/topnav_avatar.svg",
          //   alignment: Alignment.topRight,
          //   height: 30,
          //   width: 30,
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset(
              "assets/images/appbar_images/avatar_top.png",
              alignment: Alignment.topRight,
              height: 30,
              width: 30,
            ),
          )
        ],
      );
    });
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageText;
  final bool showIcon;
  const MyAppBar({
    super.key,
    required this.showIcon,
    required this.pageText
  });

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return AppBar(
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: showIcon
          ? IconButton(
            onPressed: () {
              context.pop();
            },
            icon: SvgPicture.asset(
                "assets/images/home_images/arrow_right_alt.svg",
                width: 30,
                height: 30,
                alignment: Alignment.topLeft))
        : null,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              pageText,
              style: const TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.w400,
                fontSize: 15
              ),
            ),
          )
        ],
      );
    });
  }

}
