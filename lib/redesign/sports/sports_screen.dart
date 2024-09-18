import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/redesign/sports/sport_news.dart';
import 'package:dor_companion/redesign/sports/sports_grid.dart';
import 'package:dor_companion/redesign/sports/sports_highlights.dart';
import 'package:dor_companion/redesign/sports/sports_platform.dart';
import 'package:dor_companion/responsive.dart';
import 'package:dor_companion/utils.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:dor_companion/widgets/media_detail/mdp_loaders.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../redesign/live_tv/widgets/card_banners.dart';
import '../../../widgets/appbar_custom.dart';
import '../live_tv/live_tv_screen.dart';

callInitSports() {
  fetchDataSports();
  fetchBannersSports();
  listenToPaginationScrollSports();
  sportsAppState.scrollController.value.addListener(() {
    debugPrint("----value ${sportsAppState.scrollController.value.position.minScrollExtent}");

    sportsAppState.fabIsVisible.value =
        sportsAppState.scrollController.value.position.userScrollDirection == ScrollDirection.reverse;
    if (ScrollDirection.forward == sportsAppState.scrollController.value.position.userScrollDirection) {
      debugPrint("down");
      sportsAppState.fabIsVisible.value =
          sportsAppState.scrollController.value.position.userScrollDirection == ScrollDirection.forward;
    }
    if (sportsAppState.scrollController.value.position.userScrollDirection == ScrollDirection.reverse) {
      debugPrint("up---");
      sportsAppState.fabIsVisible.value =
          sportsAppState.scrollController.value.position.userScrollDirection == ScrollDirection.reverse;
    }
  });
}

fetchBannersSports() {
  sportsAppState.isBannersError.value = false;
  sportsAppState.banners.value = [];

  getIt<SensyApi>().fetchPromotions(47).then((banners) {
    if (banners.standardPromotions.isEmpty) {
      sportsAppState.isBannersError.value = true;
      return;
    }

    sportsAppState.banners.value = banners.standardPromotions;
    sportsAppState.isBannersError.value = false;
  }).catchError((errorObj) {
    switch (errorObj.runtimeType) {
      case DioException:
        final response = (errorObj as DioException).response;
        showVanillaToast("Failed to fetch banners: ${response?.statusCode}");
        break;
      default:
        debugPrint("Encountered unknown error of type ${errorObj.runtimeType}");
    }
    sportsAppState.isBannersError.value = true;
  });
}

fetchDataSports({bool isLoadMore = false}) {
  sportsAppState.isError.value = false;
  final Trace trace = FirebasePerformance.instance.newTrace('fetch-channel-schedule-live-tv');
  trace.start();
  if (!isLoadMore) {
    sportsAppState.rows.value = [];
  } else {
    sportsAppState.loadingMore.value = true;
  }
  final mediaDetailFetch = getIt<SensyApi>().fetchMediaDetail("tab", "sports");

  return mediaDetailFetch.then((mediaDetail) {
    if (mediaDetail.mediaRows.isEmpty) {
      sportsAppState.isError.value = true;
      return;
    }
    sportsAppState.isError.value = false;
    sportsAppState.currentPage.value++;
    for (MediaRow row in mediaDetail.mediaRows) {
      if (row.mediaItems.isNotEmpty) {
        sportsAppState.rows.value.add(row);
        for (var mediaItem in row.mediaItems) {
          if (mediaItem.itemType == "page") {
            mediaItem.isHomeScreen = true;
          } else {
            mediaItem.isHomeScreen = false;
          }
        }
      }
      sportsAppState.rows.notifyListeners();
      sportsAppState.banners.notifyListeners();
    }
    sportsAppState.loadingMore.value = false;
    sportsAppState.rows.notifyListeners();
  }).catchError((errorObj) {
    switch (errorObj.runtimeType) {
      case DioException:
        final response = (errorObj as DioException).response;
        debugPrint("Failed to fetch media detail: ${response?.statusCode}");
        break;
      default:
        debugPrint("Encountered unknown error of type "
            "${errorObj.runtimeType} while fetching media detail");
        debugPrint("$errorObj");
    }
    sportsAppState.isError.value = true;
  });
}

listenToPaginationScrollSports() {
  sportsAppState.scrollController.value.addListener(() {
    if (sportsAppState.scrollController.value.position.pixels ==
        sportsAppState.scrollController.value.position.maxScrollExtent) {}
  });
  sportsAppState.rows.notifyListeners();
  sportsAppState.banners.notifyListeners();
}

class SportsScreen extends StatefulWidget {
  final String? itemType;
  final String? itemId;
  final int count = 0;

  const SportsScreen({Key? key, this.itemType, this.itemId}) : super(key: key);

  @override
  State<SportsScreen> createState() => _SportsTabState();
}

class _SportsTabState extends State<SportsScreen> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    callInitSports();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildBanners() {
    final banners = sportsAppState.banners;
    final isBannersError = ResponsiveWidget.isLargeScreen(context)
        ? sportsAppState.isBannersWebError
        : sportsAppState.isBannersError;
    if (banners.value.isEmpty && !isBannersError.value) {
      debugPrint("returning banner loader");
      return SizedBox(
          height: MediaQuery.of(context).size.width, width: 280, child: const Center(child: Loader()));
    }

    if (isBannersError.value) {
      return SizedBox(
          height: MediaQuery.of(context).size.width,
          child: Center(
              child: ElevatedButton(
                  onPressed: fetchBanners,
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      textStyle: AppTypography.fontSizeChanges),
                  child: const Text("Tap to retry", style: AppTypography.undefinedTextStyle))));
    }

    return Column(children: [
      if (widget.itemId == "home") _buildChips(),
      if (getIt<UserAccount>().profileName != "kids")
        CommonBanner(
          onCardPressed: (index) {
           banners.value[index].action.executeAction(context);
            //eventCall.bannerClickEvent('home_screen');
          },
        bannerList: banners.value,
        isShowPlayButton: true,
        isShowPlayWithWatchListButton: false,
        isShowNotifyButton: false,),
    ]);
  }

  _buildChips() => const Column(children: [SizedBox(height: 1)]);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (sportsAppState.isError.value) {
      debugPrint("${widget.key} is error");
      return SizedBox(
          height: 200,
          child: Center(
            child: ElevatedButton(
                onPressed: fetchDataSports,
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    textStyle: AppTypography.fontSizeChanges),
                child: const Text("Tap to retry",
                    style: AppTypography.undefinedTextStyle)),
          ));
    }

    return ValueListenableBuilder(
        valueListenable: sportsAppState.banners,
        builder: (context, value, child) {
          return ValueListenableBuilder(
              valueListenable: sportsAppState.rows,
              builder: (context, value, child) {
                if (sportsAppState.rows.value.isEmpty && !sportsAppState.isError.value) {
                  debugPrint("${widget.key} rows empty and not error");
                  return const Center(
                      child: Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: SingleChildScrollView(child: MDPBodyLoader())));
                }
                return PerformanceTrackedWidget(
                    widgetName: 'sports-view',
                    child: Scaffold(
                        backgroundColor: Colors.black,
                        appBar: const LogoAppBar(showLogo: false, pageText: "Sports"),
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildBanners(),
                              const TournamentByChannel(),
                              const SportsGrid(),
                              const SportNews(),
                              const SportHighlights(),
                            ],
                          ),
                        ),
                    ),
                );
              });
        });
  }

  Future<void> addRows(Future<MediaDetail> fetchRows, MediaRow afterRow) {
    return fetchRows.then((newRows) {
      setState(() {
        sportsAppState.rows.value
            .insertAll(sportsAppState.rows.value.indexOf(afterRow) + 1, newRows.mediaRows);
      });
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast("Failed to fetch additional rows: "
              "${response?.statusCode}");
      }
      throw errorObj;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
