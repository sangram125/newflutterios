import 'dart:core';

import 'package:dio/dio.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../../data/api/sensy_api.dart';
import '../../../data/models/models.dart';
import '../../../data/models/user_account.dart';
import '../../../injection/injection.dart';
import '../../../utils.dart';

class HomeController extends GetxController {
  RxBool isBannersError = false.obs;
  RxBool isBannersWebError = false.obs;
  RxList<StandardPromotion> banners = <StandardPromotion>[].obs;
  RxList<StandardPromotion> bannersWeb = <StandardPromotion>[].obs;
  RxString key = "".obs;
  RxList<MediaRow> rows = <MediaRow>[].obs;
  RxBool isError = false.obs;
  RxInt currentPage = 1.obs;
  final ScrollController scrollController = ScrollController();
  List<MediaRow> rows2 = [];
  int totalPages = 1;
  RxBool fabIsVisible = false.obs;
  AnalyticsEvent eventCall = AnalyticsEvent();

  @override
  void onInit() {
    super.onInit();
    _listenToPaginationScroll();
    scrollController.addListener(() {
      if (kDebugMode) {
        print(
            "is visible direction ${scrollController.position.userScrollDirection}");
      }

      if (kDebugMode) {
        print(
            "is ${scrollController.position.userScrollDirection == ScrollDirection.reverse}");
      }

      if (ScrollDirection.forward ==
          scrollController.position.userScrollDirection) {
        fabIsVisible.value = scrollController.position.userScrollDirection ==
            ScrollDirection.forward;
        print('fab value 1 ${fabIsVisible.value}');
      } else {
        fabIsVisible.value = false;
      }

      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        fabIsVisible.value = scrollController.position.userScrollDirection ==
            ScrollDirection.reverse;
        print('fab value 2 ${fabIsVisible.value}');
      } else {
        fabIsVisible.value = false;
      }
    });
  }

  _listenToPaginationScroll() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        debugPrint('Current page : $currentPage, Called getUsers()');
        // _fetchData(isLoadMore: true);
      }
    });
  }

  fetchBanners() {
    isBannersError.value = false;
    banners.value = [];
    // Mobile banners
    getIt<SensyApi>().fetchPromotions(getMobilePromotionsId()).then((bannerss) {
      if (bannerss.standardPromotions.isEmpty) {
        isBannersError.value = true;
        return;
      }

      banners.value = bannerss.standardPromotions;
      print("banners = ${banners.length}");
      isBannersError.value = false;
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
      isBannersError.value = true;
    });

    // Web banners
    getIt<SensyApi>().fetchPromotions(getWebPromotionsId()).then((banners) {
      if (banners.standardPromotions.isEmpty) {
        isBannersWebError.value = true;

        return;
      }

      bannersWeb.value = banners.standardPromotions;
      isBannersWebError.value = false;
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

      isBannersWebError.value = true;
    });
  }

  int getMobilePromotionsId() {
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

  int getWebPromotionsId() {
    if (key.toString().contains("news")) {
      return 48;
    } else if (key.toString().contains("sports")) {
      return 49;
    }
    return 44;
  }

  Future<void> addRows(Future<MediaDetail> fetchRows, MediaRow afterRow) {
    return fetchRows.then((newRows) {
      rows.insertAll(rows.indexOf(afterRow) + 1, newRows.mediaRows);
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast("Failed to fetch additional rows: "
              "${response?.statusCode}");
      }
      // TODO: Separate error state for additional row fetch failure
      throw errorObj;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }
}
