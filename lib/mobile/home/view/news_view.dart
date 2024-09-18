import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/widgets/media_detail/media_item_view.dart';
import 'package:dor_companion/mobile/widgets/media_detail/media_row_view.dart' as mob_row_view;
import 'package:dor_companion/mobile/widgets/media_detail/media_row_view.dart' as web_row_view;
import 'package:dor_companion/responsive.dart';
import 'package:dor_companion/utils.dart';
import 'package:dor_companion/widgets/banner_carousel.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:dor_companion/widgets/media_detail/mdp_loaders.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../widgets/live_tv_view.dart';

const int _nextPageBuffer = 2;

callInitNews() {
  fetchDataNews();
  fetchBannersNews();
  listenToPaginationScrollNews();
  newsAppState.scrollController.value.addListener(() {
    debugPrint("----value ${newsAppState.scrollController.value.position.minScrollExtent}");

    newsAppState.fabIsVisible.value =
        newsAppState.scrollController.value.position.userScrollDirection == ScrollDirection.reverse;
    if (ScrollDirection.forward == newsAppState.scrollController.value.position.userScrollDirection) {
      debugPrint("down");
      newsAppState.fabIsVisible.value =
          newsAppState.scrollController.value.position.userScrollDirection == ScrollDirection.forward;
    }
    if (newsAppState.scrollController.value.position.userScrollDirection == ScrollDirection.reverse) {
      debugPrint("up---");
      newsAppState.fabIsVisible.value =
          newsAppState.scrollController.value.position.userScrollDirection == ScrollDirection.reverse;
    }
  });
}

fetchBannersNews() {
  newsAppState.isBannersError.value = false;
  newsAppState.banners.value = [];

  final Trace trace = FirebasePerformance.instance.newTrace('fetch-banners-live-tv');
  trace.start();
  getIt<SensyApi>().fetchPromotions(46).then((banners) {
    if (banners.standardPromotions.isEmpty) {
      newsAppState.isBannersError.value = true;
      return;
    }
    newsAppState.banners.value = banners.standardPromotions;
    newsAppState.isBannersError.value = false;
  }).catchError((errorObj) {
    switch (errorObj.runtimeType) {
      case DioException:
        final response = (errorObj as DioException).response;
        showVanillaToast("Failed to fetch banners: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          debugPrint("Encountered unknown error of type ${errorObj.runtimeType}");
        }
    }
    newsAppState.isBannersError.value = true;
  });
  trace.stop();
}

fetchDataNews({bool isLoadMore = false}) {
  newsAppState.isError.value = false;
  final Trace trace = FirebasePerformance.instance.newTrace('fetch-banner-news');
  trace.start();
  if (!isLoadMore) {
    newsAppState.rows.value = [];
  } else {
    newsAppState.loadingMore.value = true;
  }
  final mediaDetailFetch = getIt<SensyApi>().fetchMediaDetail("tab", "news");

  return mediaDetailFetch.then((mediaDetail) {
    if (mediaDetail.mediaRows.isEmpty) {
      newsAppState.isError.value = true;
      return;
    }
    newsAppState.isError.value = false;
    newsAppState.currentPage.value++;
    for (MediaRow row in mediaDetail.mediaRows) {
      if (row.mediaItems.isNotEmpty) {
        newsAppState.rows.value.add(row);
        for (var mediaItem in row.mediaItems) {
          if (mediaItem.itemType == "page") {
            mediaItem.isHomeScreen = true;
          } else {
            mediaItem.isHomeScreen = false;
          }
        }
      }
      newsAppState.rows.notifyListeners();
      newsAppState.banners.notifyListeners();
    }
    newsAppState.loadingMore.value = false;
    newsAppState.rows.notifyListeners();
  }).catchError((errorObj) {
    switch (errorObj.runtimeType) {
      case DioException:
        final response = (errorObj as DioException).response;
        debugPrint("Failed to fetch media detail: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          debugPrint("Encountered unknown error of type "
              "${errorObj.runtimeType} while fetching media detail");
          debugPrint("$errorObj");
        }
    }
    newsAppState.isError.value = true;
  });
}

listenToPaginationScrollNews() {
  newsAppState.scrollController.value.addListener(() {
    if (newsAppState.scrollController.value.position.pixels ==
        newsAppState.scrollController.value.position.maxScrollExtent) {}
  });
  newsAppState.rows.notifyListeners();
  newsAppState.banners.notifyListeners();
}

class NewsTab extends StatefulWidget {
  final String? itemType;
  final String? itemId;

  final int count = 0;

  const NewsTab({Key? key, this.itemType, this.itemId}) : super(key: key);

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    print("----------- call news pageeeee--------");
    callInitNews();
    super.initState();
  }

  @override
  void dispose() {
    //newsAppState.scrollController.value.dispose();
    super.dispose();
  }

  Widget _buildBanners() {
    final banners = ResponsiveWidget.isLargeScreen(context) ? newsAppState.bannersWeb : newsAppState.banners;
    final isBannersError = ResponsiveWidget.isLargeScreen(context)
        ? newsAppState.isBannersWebError
        : newsAppState.isBannersError;
    if (banners.value.isEmpty && !isBannersError.value) {
      if (kDebugMode) {
        debugPrint("returning banner loader");
      }
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
      if (getIt<UserAccount>().profileName != "kids") BannersCarousel(banners: banners.value)
    ]);
  }

  _buildChips() => const Column(children: [SizedBox(height: 1)]);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (newsAppState.isError.value) {
      if (kDebugMode) {
        debugPrint("${widget.key} is error");
      }
      return SizedBox(
          height: 200,
          child: Center(
              child: ElevatedButton(
                  onPressed: fetchDataNews,
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      textStyle: AppTypography.fontSizeChanges),
                  child: const Text("Tap to retry", style: AppTypography.undefinedTextStyle))));
    }

    final isLargeScreen = ResponsiveWidget.isLargeScreen(context);
    if (kDebugMode) {}
    return ValueListenableBuilder(
        valueListenable: newsAppState.banners,
        builder: (context, value, child) {
          return ValueListenableBuilder(
              valueListenable: newsAppState.rows,
              builder: (context, value, child) {
                if (newsAppState.rows.value.isEmpty && !newsAppState.isError.value) {
                  if (kDebugMode) {
                    debugPrint("${widget.key} rows empty and not error");
                  }
                  return const Center(
                      child: Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: SingleChildScrollView(child: MDPBodyLoader())));
                }
                return PerformanceTrackedWidget(
                    widgetName: 'News-view',
                    child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: ListView.builder(
                            controller: newsAppState.scrollController.value,
                            itemCount: newsAppState.rows.value.length +
                                (newsAppState.currentPage.value < newsAppState.totalPages.value ? 3 : 2),
                            itemBuilder: (context, index) {
                              if (kDebugMode) {
                                debugPrint("${widget.key} building row $index");
                              }
                              if (index == 0) {
                                return _buildBanners();
                              }
                              if (widget.itemType != null &&
                                  widget.itemId != null &&
                                  newsAppState.currentPage.value < newsAppState.totalPages.value &&
                                  index > newsAppState.rows.value.length - _nextPageBuffer + 1) {
                                debugPrint("object");
                                newsAppState.currentPage.value++;
                              }
                              int count =
                                  newsAppState.currentPage.value < newsAppState.totalPages.value ? 3 : 2;
                              if (index == newsAppState.rows.value.length + count - 1) {
                                return const SizedBox(height: 0);
                              }
                              if (newsAppState.rows.value[index - 1].mediaItems.isEmpty) {
                                return const SizedBox();
                              }
                              return isLargeScreen
                                  ? web_row_view.MediaRowView(newsAppState.rows.value[index - 1],
                                      addRows: addRows)
                                  : mob_row_view.MediaRowView(newsAppState.rows.value[index - 1],
                                      addRows: addRows, set: (data) {
                                      newsAppState.rows.value = data;
                                      MediaItemViewState.isFavoritePressed = null;
                                      setState(() {});
                                    });
                            })));
              });
        });
  }

  Future<void> addRows(Future<MediaDetail> fetchRows, MediaRow afterRow) {
    return fetchRows.then((newRows) {
      setState(() {
        newsAppState.rows.value.insertAll(newsAppState.rows.value.indexOf(afterRow) + 1, newRows.mediaRows);
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
