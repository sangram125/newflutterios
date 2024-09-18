import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/mobile/search/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/custom_search_widget.dart' as se;
import '../data/api/sensy_api.dart';
import '../data/models/search_suggestions.dart';
import '../injection/injection.dart';
import '../mobile/notification/notification_list.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTapBack;
  final bool showSearchIcon;

  const CustomAppBar({Key? key, this.onTapBack, this.showSearchIcon = true}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    // var subscribedPlans = getIt<UserAccount>().customer?.activePlans;
    bool isHomePage = ModalRoute.of(context)?.isFirst ?? false;
    AnalyticsEvent eventCall = AnalyticsEvent();
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      double appBarHeight = MediaQuery.of(context).size.height * 0.13;
      double bottomHeight = appBarHeight * 0.2;
      return PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: GlassmorphicContainer(
          blur: 10,
          borderRadius: 0,
          height: appBarHeight,
          // Use the calculated height
          width: double.maxFinite,
          border: 1,
          linearGradient: const LinearGradient(colors: [Color(0xFF0E1466), Color(0x490B0F47)]),
          borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF040523).withOpacity(0.6), const Color(0xFF040523).withOpacity(0.6)],
              stops: const [0.1, 1]),
          child: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            elevation: 0,
            toolbarHeight: appBarHeight * 0.8,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Wrap(
                      children: [
                        isHomePage
                            ? const SizedBox.shrink()
                            : IconButton(
                                onPressed: () {
                                  context.pop();
                                  onTapBack;
                                },
                                icon: SvgPicture.asset("assets/images/home_images/arrow_right_alt.svg",
                                    width: 41.w, height: 41.h, alignment: Alignment.bottomCenter)),
                        // const SizedBox(
                        //   width: 8,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 8.0),
                        //   child: SizedBox(
                        //     width: 98.w,
                        //     height: 30.h,
                        //     child: SvgPicture.asset(
                        //       "assets/images/appbar_images/icon_dor_play.svg",
                        //       alignment: Alignment.bottomRight,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        // isHomePage
                        //     ? InkWell(
                        //   onTap: () {
                        //     Get.toNamed("/subscriptions");
                        //   },
                        //   child: SizedBox(
                        //     width: 105.w,
                        //     height: 24.h,
                        //     child: subscribedPlans!.isEmpty
                        //         ? SvgPicture.asset(
                        //       "assets/images/appbar_images/subscribe.svg",
                        //       alignment: Alignment.center,
                        //     )
                        //         : SvgPicture.asset(
                        //       "assets/images/appbar_images/upgrade.svg",
                        //       alignment: Alignment.center,
                        //     ),
                        //   ),
                        // )
                        //     : const SizedBox.shrink(),
                      ],
                    ),
                    Wrap(
                      children: [
                        // IconButton(
                        //   onPressed: () {
                        //     eventCall.movieDetailNotificationEvent('movie_detail_screen');
                        //     Get.to(const NotificationList());
                        //   },
                        //   icon: SvgPicture.asset(
                        //     "assets/images/appbar_images/appbar_bell.svg",
                        //     width: 24.w,
                        //     height: 24.h,
                        //     alignment: Alignment.center,
                        //   ),
                        // ),
                       if(showSearchIcon) IconButton(
                          onPressed: () {
                            eventCall.movieDetailSearchEvent('movie_detail_screen');
                            se.showSearch(
                              context: context,
                              delegate: CustomSearchDelegate(
                                sensyApi: getIt<SensyApi>(),
                                searchSuggestion: getIt<SearchSuggestions>(),
                              ),
                            );
                          },
                          icon: SvgPicture.asset(
                            "assets/images/appbar_images/search.svg",
                            width: 41.w,
                            height: 41.h,
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
