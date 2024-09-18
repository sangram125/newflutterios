import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/widgets/add_watch_list_view.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../utils.dart';

class LibraryController extends GetxController {
  RxList<StandardPromotion> libraryBanners = <StandardPromotion>[].obs;
  RxBool isBannersError = false.obs;
  final ScrollController scrollController = ScrollController();
  RxList<MediaRow> rows = <MediaRow>[].obs;
  RxList<MediaRow> rows2 = <MediaRow>[].obs;
  RxBool isError = false.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool fabIsVisible = false.obs;
  Key? key;

  @override
  void onInit() async {
    await fetchBanners(key: const Key("games ${9}"));
    await fetchData(
      mediaDetailFuture: () =>
          getIt<SensyApi>().fetchMediaDetail("tab", "library"),
      key: const Key("games ${9}"),
    );
    listenToPaginationScroll();
    scrollController.addListener(() {
      // setState(() {
      print("----value ${scrollController.position.minScrollExtent}");

      fabIsVisible.value = scrollController.position.userScrollDirection ==
          ScrollDirection.reverse;
      if (ScrollDirection.forward ==
          scrollController.position.userScrollDirection) {
        print("down");
        fabIsVisible.value = scrollController.position.userScrollDirection ==
            ScrollDirection.forward;
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        print("up---");
        fabIsVisible.value = scrollController.position.userScrollDirection ==
            ScrollDirection.reverse;
      }
    });
    // });
    super.onInit();
  }

  listenToPaginationScroll() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        debugPrint('Current page : $currentPage, Called getUsers()');
      }
    });
  }

  fetchBanners({Key? key}) {
    // setState(() {
    isBannersError.value = false;
    libraryBanners.value = [];
    // });

    // Mobile banners
    getIt<SensyApi>()
        .fetchPromotions(getMobilePromotionsId(key))
        .then((banners) {
      if (banners.standardPromotions.isEmpty) {
        // setState(() {
        isBannersError.value = true;
        // });
        return;
      }

      // setState(() {
      libraryBanners.value = banners.standardPromotions;
      print("banners = ${libraryBanners.length}");
      isBannersError.value = false;
      // });
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print("Failed to fetch banners: ${response?.statusCode}");
          break;
        default:
          if (kDebugMode) {
            print("Encountered unknown error of type ${errorObj.runtimeType}");
          }
      }
      // setState(() {
      isBannersError.value = true;
      // });
    });
  }

  int getMobilePromotionsId(Key? key) {
    if (key.toString().contains("news")) {
      return 46;
    } else if (key.toString().contains("sports")) {
      return 47;
    } else if (key.toString().contains("games")) {
      return 74;
    } else if (getIt<UserAccount>().isRestricted == true) {
      return 54;
    } else {
      return 44;
    }
  }

  fetchData({Key? key, required FetchRows mediaDetailFuture}) async {
    print("firebase_performance");

    final Trace trace = FirebasePerformance.instance.newTrace('fetch-data');
    trace.start();

    // if (mounted) {
    //   setState(() {
    isError.value = false;
    rows.value = [];
    // _banners = [];
    //   });
    // }

    currentPage.value = 1;
    final mediaDetailFetch = mediaDetailFuture();

    return mediaDetailFetch.then((mediaDetail) {
      if (kDebugMode) {
        print("${key} received mediaDetail");
      }
      if (mediaDetail.mediaRows.isEmpty) {
        if (kDebugMode) {
          print("${key} received empty rows");
        }
        // if (mounted) {
        //   setState(() {
        isError.value = true;
        //   });
        // }
        return;
      }
      if (kDebugMode) {
        print("${key} received non-empty rows");
      }
      // if (mounted) {
      //   setState(() {
      isError.value = false;
      for (MediaRow row in mediaDetail.mediaRows) {
        if (row.mediaItems.isNotEmpty) {
          rows.add(row);
          // if (itemType == "page") {
          //   for (var mediaItem in row.mediaItems) {
          //     mediaItem.isHomeScreen = true;
          //   }
          // } else {
          //   for (var mediaItem in row.mediaItems) {
          //     mediaItem.isHomeScreen = false;
          //   }
          // }
        }
      }
      // if (widget.itemType == "page") {
      // }

      if (kDebugMode) {
        // print(
        // "${widget.key} ${mediaDetail.mediaHeader?.meta.totalPages} total pages");
      }
      totalPages.value = mediaDetail.mediaHeader?.meta.totalPages ?? 0;
      //   });
      //   trace.stop();
      // } else {
      //   if (kDebugMode) {
      //     print("${widget.key} received non-empty rows but not mounted");
      //   }
      // }
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print("Failed to fetch page: ${response?.statusCode}");
          break;
        default:
          if (kDebugMode) {
            print("Encountered unknown error of type "
                "${errorObj.runtimeType} while fetching media detail");
            print("$errorObj");
          }
      }
      // if (mounted) {
      //   setState(() {
      isError.value = true;
      //   });
      // }
    });
  }

  Future<void> addRows(Future<MediaDetail> fetchRows, MediaRow afterRow) {
    return fetchRows.then((newRows) {
      // setState(() {
      rows.insertAll(rows.indexOf(afterRow) + 1, newRows.mediaRows);
      // });
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
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
