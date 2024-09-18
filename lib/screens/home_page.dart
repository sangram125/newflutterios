import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/home_page_provider.dart';
import 'package:dor_companion/mobile/search/search_controller/search_controller.dart';
import 'package:dor_companion/mobile/search/search_view.dart';
import 'package:dor_companion/screens/nav_bar_item_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import '../data/api/distro_api.dart';
import '../data/api/sensy_api.dart';
import '../data/models/search_suggestions.dart';
import '../data/models/user_account.dart';
import '../injection/injection.dart';
import '../../../widgets/custom_search_widget.dart' as se;
import '../responsive.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomePageProvider homePageProvider = Get.put(HomePageProvider());
  @override
  Widget build(BuildContext context) {
    return _buildMobileHome(context);
  }

  Widget _buildMobileHome(BuildContext context) => SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(context),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFF0F1566),
                  const Color(0x0B0F474A).withOpacity(0.29),
                ],
              ),
            ),
            child: _buildBody(),
          ),
          bottomNavigationBar: _buildBottomNav(context),
        ),
      );

  _buildAppBar(BuildContext context) => PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: GlassmorphicContainer(
          blur: 10,
          borderRadius: 0,
          height: 50.0,
          width: double.maxFinite,
          border: 1,
          linearGradient: const LinearGradient(
            colors: [Color(0xFF0E1466), Color(0x490B0F47)],
          ),
          borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF040523).withOpacity(0.6),
                const Color(0xFF040523).withOpacity(0.6),
              ],
              stops: const [
                0.1,
                1,
              ]),
          child: AppBar(
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(38.0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/appbar_images/icon_dor_play.svg",
                      alignment: Alignment.center,
                      width: 98.w,
                      height: 30.h,
                    ),
                    Wrap(
                      children: [
                        InkWell(
                          onTap: () {
                            final searchController =
                                Get.put(SearchViewController());
                            homePageProvider.eventCall.searchEvent('app_bar');
                            se.showSearch(
                              context: context,
                              delegate: CustomSearchDelegate(
                                sensyApi: getIt<SensyApi>(),
                                searchSuggestion: getIt<SearchSuggestions>(),
                              ),
                            );
                            searchController.fetchData("tab", "find");
                            searchController.fetchData(
                                "row", "search-trending");
                          },
                          child: SvgPicture.asset(
                            "assets/images/appbar_images/search.svg",
                            width: 40.w,
                            height: 40.h,
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

  _buildBody() => homePageProvider.tabs.length > homePageProvider.page.value
      ? PageView(
          controller: homePageProvider.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: homePageProvider.tabs,
        )
      : const SizedBox(
          height: 100,
        );

  Widget _buildBottomNav(BuildContext context) {
    return Obx(
      () => Container(
        color: Color(0xFF040523),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NavBarItem(
              isSelected: homePageProvider.page == 0,
              title: 'Home',
              selectedImage: "assets/images/home_images/selected_home.svg",
              unSelectedImage: "assets/images/home_images/unselected_home.svg",
              index: 0,
              onTap: (int selectedIndex) {
                var eventProps = {
                  'Latitude': Constants.lat,
                  'Longitude': Constants.long,
                  'Mobile number': Constants.mobile,
                  'Login Method': 'Mobile Number login',
                  'Network Type': Constants.networkType,
                  'Time of Login':
                      CleverTapPlugin.getCleverTapDate(DateTime.now()),
                  'Category Clicked': 'Home',
                };

                CleverTapPlugin.recordEvent("Category clicked", eventProps);
                if (selectedIndex != homePageProvider.page.value) {
                  homePageProvider.page.value = selectedIndex;
                  homePageProvider.pageController.jumpToPage(selectedIndex);
                }
              },
            ),
            getIt<UserAccount>().isRestricted != true
                ? NavBarItem(
                    isSelected: homePageProvider.page == 2,
                    title: 'Live TV',
                    selectedImage:
                        "assets/images/home_images/selected_live.svg",
                    unSelectedImage:
                        "assets/images/home_images/unselected_live.svg",
                    index: 2,
                    onTap: (int selectedIndex) {
                      var eventProps = {
                        'Latitude': Constants.lat,
                        'Longitude': Constants.long,
                        'Mobile number': Constants.mobile,
                        'Login Method': 'Mobile Number login',
                        'Network Type': Constants.networkType,
                        'Time of Login':
                            CleverTapPlugin.getCleverTapDate(DateTime.now()),
                        'Category Clicked': 'Live TV',
                      };

                      CleverTapPlugin.recordEvent(
                          "Category clicked", eventProps);

                      DistroApiProvider apiProvider = DistroApiProvider();
                      apiProvider.trackingPixel(eventName: 'ff');
                      if (selectedIndex != homePageProvider.page.value) {
                        homePageProvider.page.value = selectedIndex;
                        homePageProvider.pageController
                            .jumpToPage(selectedIndex);
                      }
                    },
                  )
                : NavBarItem(
                    isSelected: homePageProvider.page == 3,
                    title: 'Sports',
                    selectedImage:
                        "assets/images/home_images/selected_sport.svg",
                    unSelectedImage:
                        "assets/images/home_images/unselected_sport.svg",
                    index: 3,
                    onTap: (int selectedIndex) {
                      var eventProps = {
                        'Latitude': Constants.lat,
                        'Longitude': Constants.long,
                        'Mobile number': Constants.mobile,
                        'Login Method': 'Mobile Number login',
                        'Network Type': Constants.networkType,
                        'Time of Login':
                            CleverTapPlugin.getCleverTapDate(DateTime.now()),
                        'Category Clicked': 'Live TV',
                      };

                      CleverTapPlugin.recordEvent(
                          "Category clicked", eventProps);
                      if (selectedIndex != homePageProvider.page.value) {
                        homePageProvider.page.value = selectedIndex;
                        homePageProvider.pageController
                            .jumpToPage(selectedIndex);
                      }
                    },
                  ),
            // NavBarItem(
            //   isSelected: getIt<UserAccount>().isRestricted==true? homePageProvider.page == 8 : homePageProvider.page == 1,
            //   title: getIt<UserAccount>().isRestricted==true?'GAMES':'NEWS',
            //   selectedImage: getIt<UserAccount>().isRestricted==true?"assets/images/home_images/selected_game.svg":"assets/images/home_images/selected_news.svg",
            //   unSelectedImage: getIt<UserAccount>().isRestricted==true?"assets/images/home_images/unselected_game.svg":"assets/images/home_images/unselected_news.svg",
            //   index: getIt<UserAccount>().isRestricted==true?8:1,
            //   onTap: (int selectedIndex) {
            //     if (selectedIndex != homePageProvider.page.value) {
            //       homePageProvider.page.value  = selectedIndex;
            //       homePageProvider.pageController.jumpToPage(selectedIndex);
            //     }
            //   },
            // ),
            if (getIt<UserAccount>().isRestricted != true)
              NavBarItem(
                isSelected: homePageProvider.page == 1,
                title: 'News',
                selectedImage: "assets/images/home_images/selected_news.svg",
                unSelectedImage:
                    "assets/images/home_images/unselected_news.svg",
                index: 1,
                onTap: (int selectedIndex) {
                  var eventProps = {
                    'Latitude': Constants.lat,
                    'Longitude': Constants.long,
                    'Mobile number': Constants.mobile,
                    'Login Method': 'Mobile Number login',
                    'Network Type': Constants.networkType,
                    'Time of Login':
                        CleverTapPlugin.getCleverTapDate(DateTime.now()),
                    'Category Clicked': 'News',
                  };

                  CleverTapPlugin.recordEvent("Category clicked", eventProps);
                  if (selectedIndex != homePageProvider.page.value) {
                    homePageProvider.page.value = selectedIndex;
                    homePageProvider.pageController.jumpToPage(selectedIndex);
                  }
                },
              ),
            if (getIt<UserAccount>().isRestricted != true)
              NavBarItem(
                isSelected: homePageProvider.page == 3,
                title: 'Sports',
                selectedImage: "assets/images/home_images/selected_sport.svg",
                unSelectedImage:
                    "assets/images/home_images/unselected_sport.svg",
                index: 3,
                onTap: (int selectedIndex) {
                  var eventProps = {
                    'Latitude': Constants.lat,
                    'Longitude': Constants.long,
                    'Mobile number': Constants.mobile,
                    'Login Method': 'Mobile Number login',
                    'Network Type': Constants.networkType,
                    'Time of Login':
                        CleverTapPlugin.getCleverTapDate(DateTime.now()),
                    'Category Clicked': 'Sports',
                  };

                  CleverTapPlugin.recordEvent("Category clicked", eventProps);
                  if (selectedIndex != homePageProvider.page.value) {
                    homePageProvider.page.value = selectedIndex;
                    homePageProvider.pageController.jumpToPage(selectedIndex);
                  }
                },
              ),
            NavBarItem(
              isSelected: homePageProvider.page == 4,
              title: 'Profile',
              selectedImage: "assets/images/home_images/selected_profile.svg",
              unSelectedImage:
                  "assets/images/home_images/unselected_profile.svg",
              index: 4,
              onTap: (int selectedIndex) {
                var eventProps = {
                  'Latitude': Constants.lat,
                  'Longitude': Constants.long,
                  'Mobile number': Constants.mobile,
                  'Login Method': 'Mobile Number login',
                  'Network Type': Constants.networkType,
                  'Time of Login':
                      CleverTapPlugin.getCleverTapDate(DateTime.now()),
                  'Category Clicked': 'Profile',
                };

                CleverTapPlugin.recordEvent("Category clicked", eventProps);
                if (selectedIndex != homePageProvider.page.value) {
                  homePageProvider.page.value = selectedIndex;
                  homePageProvider.pageController.jumpToPage(selectedIndex);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
