import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/mobile/widgets/library_controller.dart';
import 'package:dor_companion/mobile/widgets/media_detail/media_item_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../data/api/sensy_api.dart';
import '../../data/models/search_suggestions.dart';
import '../../data/models/user_account.dart';
import '../../injection/injection.dart';
import '../../mobile/widgets/media_detail/media_row_view.dart' as mob_row_view;
import '../../widgets/appbar.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/loader.dart';
import '../../widgets/media_detail/mdp_loaders.dart';
import '../../widgets/media_detail/media_rows_view.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/custom_search_widget.dart' as se;
import 'package:dor_companion/data/models/home_page_provider.dart';

import '../notification/notification_list.dart';
import '../search/search_view.dart';

class LibraryView extends StatelessWidget{
  LibraryView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(
     decoration:
     BoxDecoration(
       gradient: LinearGradient(
         begin: Alignment.centerLeft,
         end: Alignment.centerRight,
         colors: [
           const Color(0xFF0F1566),
           const Color(0x0B0F474A).withOpacity(0.29),
         ],
       ),
     ),
     child:LibraryTab(
       mediaDetailFuture: () =>
           getIt<SensyApi>().fetchMediaDetail("tab", "library"),
       key: const Key("games ${9}"),
     ),
   );
  }
}


class LibraryTab extends StatelessWidget {
  LibraryTab({
    Key? key,
    required this.mediaDetailFuture,
  }) : super(key: key);


  //final TrackingScrollController controller;
  final FetchRows mediaDetailFuture;


  int count = 0;

  final controller =Get.put(LibraryController());
  final HomePageProvider homePageProvider = Get.put(HomePageProvider());

  Widget _buildBanners(BuildContext context) {
    final banners = controller.libraryBanners;
    final isBannersError =controller.isBannersError.value;
    if (banners.isEmpty && !isBannersError) {
      if (kDebugMode) {
        print("returning banner loader");
      }
      return SizedBox(
          height: MediaQuery.of(context).size.width,
          width: 280,
          child: const Center(child: Loader()));
    }

    if (isBannersError) {
      return SizedBox(
        height: MediaQuery.of(context).size.width,
        child: Center(
          child: ElevatedButton(
            onPressed: controller.fetchBanners(key:const Key("games ${9}") ),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              textStyle: AppTypography.fontSizeChanges,
            ),
            child: const Text("Tap to retry", style: AppTypography.undefinedTextStyle,),
          ),
        ),
      );
    }

    return Column(
      children: [
        if (getIt<UserAccount>().profileName != "kids")
          BannersCarousel(
            banners: banners,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PerformanceTrackedWidget(
      widgetName: 'library-view',
      child: Obx(() {
        if (controller.rows.isEmpty && !controller.isError.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: SingleChildScrollView(child: MDPBodyLoader()),
            ),
          );
        }

        if (controller.isError.value) {

          return SizedBox(
            height: 200,
            child: Center(
              child: ElevatedButton(
                onPressed: () => controller.fetchData,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  textStyle: AppTypography.fontSizeChanges,
                ),
                child: const Text("Tap to retry", style: AppTypography.undefinedTextStyle,),
              ),
            ),
          );
        }
       return Scaffold(
         appBar: const CustomAppBar(),
          backgroundColor: Colors.transparent,
          // floatingActionButton: AnimatedOpacity(
          //   duration: const Duration(microseconds: 100),
          //   opacity: controller.fabIsVisible.value  ? 1 : 0,
          //   child: Container(
          //     margin: const EdgeInsets.only(bottom: 76.0),
          //     child: FloatingActionButton(
          //       onPressed: () {
          //         // setState(() {
          //         controller.fabIsVisible.value = false;
          //         // });
          //         print("scroll value ${controller.scrollController.position.minScrollExtent}");
          //         if (controller.scrollController.hasClients) {
          //           final position = controller.scrollController.position.minScrollExtent;
          //           controller.scrollController.animateTo(
          //             position,
          //             duration: const Duration(seconds: 1),
          //             curve: Curves.easeOut,
          //           );
          //           print("scroll value $position");
          //         }
          //       },
          //       isExtended: true,
          //       tooltip: "Scroll to Top",
          //       child: const Icon(Icons.arrow_upward),
          //     ),
          //   ),
          // ),
          body: Obx(() {
           return Container(
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
              margin: const EdgeInsets.only(bottom: 0),
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.rows.length + (controller.currentPage.value < controller.totalPages.value ? 2 : 1),
                itemBuilder: (context, index) {
                  if (kDebugMode) {
                    print("building row $index");
                  }

                  if (index == 0) {
                    return _buildBanners(context);
                  }

                  // The index for rows will start from 1 because 0 is reserved for banners.
                  int rowIndex = index - 1;

                  if (rowIndex < controller.rows.length) {
                    if (controller.rows[rowIndex].mediaItems.isEmpty) {
                      return const SizedBox();
                    }

                    return mob_row_view.MediaRowView(
                      controller.rows[rowIndex],
                      isTopicScreen: true,
                      addRows: controller.addRows,
                      set: (data) {
                        controller.rows.value = data;
                        MediaItemViewState.isFavoritePressed = null;
                      },
                    );
                  }

                  // Display loader if more pages are available and we are at the end of the list
                  if (controller.currentPage.value < controller.totalPages.value) {
                    return const SizedBox(
                      height: 75,
                      child: Center(child: Loader()),
                    );
                  }

                  // Optionally, you can return some placeholder or empty space if no more items are available
                  return const SizedBox(height: 75);
                },
              ),
            );
          }
          ),
        );
      }
      ),
    );
  }

  _buildAppBar(BuildContext context) => PreferredSize(
    preferredSize: const Size.fromHeight(100.0),
    child: GlassmorphicContainer(
      blur: 10,
      borderRadius: 0,
      height: 120.0,
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(34.0),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    "assets/images/home_images/arrow_right_alt.svg",
                    width: 41.w,
                    height: 41.h,
                    alignment: Alignment.center,
                  ),
                ),
                // const SizedBox(width: 45),
                Wrap(
                  children: [
                    // IconButton(
                    //   onPressed: () {
                    //     homePageProvider.eventCall
                    //         .notificationEvent('app_bar');
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const NotificationList(),
                    //       ),
                    //     );
                    //   },
                    //   icon: SvgPicture.asset(
                    //     "assets/images/appbar_images/appbar_bell.svg",
                    //     width: 24.w,
                    //     height: 24.h,
                    //     alignment: Alignment.center,
                    //   ),
                    // ),
                    IconButton(
                      onPressed: () {
                        homePageProvider.eventCall.searchEvent('app_bar');
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


  bool get wantKeepAlive => true;
}
