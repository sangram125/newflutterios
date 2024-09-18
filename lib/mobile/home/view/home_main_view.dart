import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/home/controller/homeController.dart';
import 'package:dor_companion/mobile/widgets/media_detail/media_item_view.dart';
import 'package:dor_companion/responsive.dart';
import 'package:dor_companion/utils.dart';
import 'package:dor_companion/mobile/widgets/media_detail/media_row_view.dart' as mob_row_view;
import 'package:dor_companion/mobile/widgets/media_detail/media_row_view.dart' as web_row_view;
import 'package:dor_companion/widgets/banner_carousel.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:dor_companion/widgets/media_detail/mdp_loaders.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../widgets/live_tv_view.dart';

const int _nextPageBuffer = 2;
callHomeInit(){
  fetchDataHome();
  fetchBannersHome();
  listenToPaginationScrollNews();
  homeState.scrollController.value.addListener(() {

    print("----value ${homeState.scrollController.value.position.minScrollExtent}");

    homeState.fabIsVisible.value = homeState.scrollController.value.position.userScrollDirection ==
        ScrollDirection.reverse;
    if (ScrollDirection.forward ==
        homeState.scrollController.value.position.userScrollDirection) {
      print("down");
      homeState.fabIsVisible.value = homeState.scrollController.value.position.userScrollDirection ==
          ScrollDirection.forward;
    }
    if (homeState.scrollController.value.position.userScrollDirection ==
        ScrollDirection.reverse) {
      print("up---");
      homeState.fabIsVisible.value = homeState.scrollController.value.position.userScrollDirection ==
          ScrollDirection.reverse;
    }
  });
}

fetchBannersHome() {
  homeState.isBannersError.value = false;
  homeState.banners.value = [];

  final Trace trace = FirebasePerformance.instance.newTrace('fetch-banners-live-tv');
  trace.start();
  final homeController = Get.put(HomeController());
  final id = homeController.getMobilePromotionsId();
  getIt<SensyApi>().fetchPromotions(id).then((banners) {
    if (banners.standardPromotions.isEmpty) {
      homeState.isBannersError.value = true;
      return;
    }
    homeState.banners.value = banners.standardPromotions;
    homeState.isBannersError.value = false;
  }).catchError((errorObj) {
    switch (errorObj.runtimeType) {
      case DioException:
        final response = (errorObj as DioException).response;
        if (kDebugMode) {
       //   showVanillaToast("Failed to fetch page: ${response?.statusCode}");
        }
        break;
      default:
        if (kDebugMode) {
          print("Encountered unknown error of type ${errorObj.runtimeType}");
        }
    }
    homeState.isBannersError.value = true;
  });
  trace.stop();
}

fetchDataHome({bool isLoadMore = false}) {
  homeState.isError.value = false;
  final Trace trace = FirebasePerformance.instance.newTrace('fetch-banner-news');
  trace.start();
  if (!isLoadMore) {
    homeState.rows.value = [];
  } else {
    homeState.loadingMore.value = true;
  }
  var mediaDetailFetch = getIt<SensyApi>().fetchMediaDetail("page", "home");

  return mediaDetailFetch.then((mediaDetail) {
    if (mediaDetail.mediaRows.isEmpty) {
      homeState.isError.value = true;
      return;
    }
    homeState.isError.value = false;
    homeState.currentPage.value++;
    for (MediaRow row in mediaDetail.mediaRows) {
      if (row.mediaItems.isNotEmpty) {
        homeState.rows.value.add(row);
        for (var mediaItem in row.mediaItems) {
          if (mediaItem.itemType == "page") {
            mediaItem.isHomeScreen = true;
          }else {
            mediaItem.isHomeScreen = false;
          }
        }
        // _banners = row as List<StandardPromotion>;
      }
      homeState.rows.notifyListeners();
      homeState.banners.notifyListeners();
    }
    // totalPages = mediaDetail.mediaHeader.meta.totalPages;
    homeState.loadingMore.value = false;
    homeState.rows.notifyListeners();

  }).catchError((errorObj) {
    switch (errorObj.runtimeType) {
      case DioException:
        final response = (errorObj as DioException).response;
      //  showVanillaToast("Failed to fetch page: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          print("Encountered unknown error of type "
              "${errorObj.runtimeType} while fetching media detail");
          print("$errorObj");
        }
    }
    homeState.isError.value = true;
  });
}
listenToPaginationScrollNews() {
  homeState.scrollController.value.addListener(() {
    if (homeState.scrollController.value.position.pixels ==
        homeState.scrollController.value.position.maxScrollExtent) {
    }
  });
  homeState.rows.notifyListeners();
  homeState.banners.notifyListeners();
}


class HomeMainView extends StatefulWidget {
  HomeMainView({
    Key? key,
    this.itemType,
    this.itemId,
  }) : super(key: key);

  //final TrackingScrollController controller;
  late String? itemType;
  late String? itemId;

  int count = 0;

  @override
  State<HomeMainView> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeMainView> with AutomaticKeepAliveClientMixin {

  @override
  void dispose() {
    homeState.scrollController.value.dispose();
    super.dispose();
  }
  Widget _buildBanners() {
    final banners =
    ResponsiveWidget.isLargeScreen(context) ? homeState.bannersWeb : homeState.banners;
    final isBannersError = ResponsiveWidget.isLargeScreen(context)
        ? homeState.isBannersWebError
        : homeState.isBannersError;
    if (banners.value.isEmpty && !isBannersError.value) {
      if (kDebugMode) {
        print("returning banner loader");
      }
      return SizedBox(
          height: MediaQuery.of(context).size.width,
          width: 280,
          child: const Center(child: Loader()));
    }

    if (isBannersError.value) {
      return SizedBox(
        height: MediaQuery.of(context).size.width,
        child: Center(
          child: ElevatedButton(
            onPressed:fetchBanners,
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              textStyle: AppTypography.fontSizeChanges,
            ),
            child: const Text(
              "Tap to retry",
              style: AppTypography.undefinedTextStyle,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        if (widget.itemId == "home") _buildChips(),
        if (getIt<UserAccount>().profileName != "kids")
          BannersCarousel(
            banners: banners.value,
          ),
      ],
    );
  }

  _buildChips() {
    return const Column(
      children: [
        SizedBox(
          height: 1,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (homeState.isError.value) {
      if (kDebugMode) {
        print("${widget.key} is error");
      }
      return SizedBox(
        height: 200,
        child: Center(
          child: ElevatedButton(
            onPressed: fetchDataHome,
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              textStyle: AppTypography.fontSizeChanges,
            ),
            child: const Text(
              "Tap to retry",
              style: AppTypography.undefinedTextStyle,
            ),
          ),
        ),
      );
    }

    final isLargeScreen = ResponsiveWidget.isLargeScreen(context);
    if (kDebugMode) {
    }
    return ValueListenableBuilder(
      valueListenable: homeState.banners,
      builder: (context, value, child) {
        return ValueListenableBuilder(
          valueListenable: homeState.rows,
          builder: (context, value, child) {
            if (homeState.rows.value.isEmpty && !homeState.isError.value) {
              if (kDebugMode) {
                print("${widget.key} rows empty and not error");
              }
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: SingleChildScrollView(child: MDPBodyLoader()),
                ),
              );
            }
            return PerformanceTrackedWidget(
              widgetName: 'News-view',
              child: Scaffold(
                backgroundColor: Colors.transparent,
                floatingActionButton: AnimatedOpacity(
                  duration: const Duration(microseconds: 100),
                  opacity: homeState.fabIsVisible.value ? 1 : 0,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 76.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          homeState.fabIsVisible.value = false;
                        });
                        print(
                            "scroll value ${homeState.scrollController.value.position.minScrollExtent}");
                        if (homeState.scrollController.value.hasClients) {
                          final position = homeState.scrollController.value.position.minScrollExtent;
                          homeState.scrollController.value.animateTo(
                            position,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOut,
                          );
                          print("scroll value $position");
                        }
                      },
                      isExtended: true,
                      tooltip: "Scroll to Top",
                      child: const Icon(Icons.arrow_upward),
                    ),
                  ),
                ),
                body: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ListView.builder(
                    controller: homeState.scrollController.value,
                    itemCount: homeState.rows.value.length +
                        (homeState.currentPage.value < homeState.totalPages.value? 3 : 2),
                    itemBuilder: (context, index) {
                      if (kDebugMode) {
                        print("${widget.key} building row $index");
                      }
                      if (index == 0) {
                        return _buildBanners();
                      }

                      if (widget.itemType != null &&
                          widget.itemId != null &&
                          homeState.currentPage.value < homeState.totalPages.value &&
                          index > homeState.rows.value.length - _nextPageBuffer + 1) {
                        print("object");
                        homeState.currentPage.value++;
                      }

                      if (index >=homeState.rows.value.length + 1) {
                        return const SizedBox(
                          height: 75,
                          child: Center(child: Loader()),
                        );
                      }

                      int count = homeState.currentPage.value < homeState.totalPages.value ? 3 : 2;
                      if (index ==homeState.rows.value.length + count - 1) {
                        return const SizedBox(height: 75);
                      }
                      if (homeState.rows.value[index - 1].mediaItems.isEmpty) {
                        return const SizedBox();
                      }

                      return isLargeScreen
                          ? web_row_view.MediaRowView(homeState.rows.value[index - 1], addRows: addRows)
                          : mob_row_view.MediaRowView(
                        homeState.rows.value[index - 1],
                        addRows: addRows,
                        set: (data) {
                          homeState.rows.value = data;
                          MediaItemViewState.isFavoritePressed = null;
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          }
        );
      }

    );
  }
  Future<void> addRows(Future<MediaDetail> fetchRows, MediaRow afterRow) {
    return fetchRows.then((newRows) {
      setState(() {
        homeState.rows.value.insertAll( homeState.rows.value.indexOf(afterRow) + 1, newRows.mediaRows);
      });
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast("Failed to fetch additional rows: "
              "${response?.statusCode}");
      }
      // TODO: Separate error state for additional row fetch failure
      /*setState(() {
        isError = true;
      });*/
      throw errorObj;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
