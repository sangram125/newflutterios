import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/data/models/user_interests.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/home/view/home_main_view.dart';
import 'package:dor_companion/mobile/home/view/news_view.dart';
import 'package:dor_companion/mobile/home/view/sports_view.dart';
import 'package:dor_companion/mobile/profile/profile_main_views.dart';
import 'package:dor_companion/mobile/game/game_view.dart';
import 'package:dor_companion/mobile/search/search_controller/search_controller.dart';
import 'package:dor_companion/mobile/widgets/live_tv_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../mobile/widgets/home_view.dart';
import '../../utils.dart';
import 'languages.dart';
import 'user_account.dart';

class HomePageProvider extends GetxController {
  static int count=0;
  static String action_id="";
  static String title="";
  static bool gesture_detector=false;
  late PageController pageController;
  int _incrementCount = 0;
  final RxList isHovering = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ].obs;
  final api = getIt<SensyApi>();

  List<Widget> tabs = [];
  AnalyticsEvent eventCall = AnalyticsEvent();
  RxInt page = 0.obs;
  final searchController = Get.put(SearchViewController());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pageController = PageController();
    _fetchData();
    getIt<UserAccount>().setOnHome(false);
    getIt<UserAccount>().addListener(_fetchData);
    getIt<UserInterestsChangeNotifier>().addListener(_fetchData);
    getIt<FavoriteLanguagesChangeNotifier>().addListener(_fetchData);
    searchController.fetchData("tab", "find");
    searchController.fetchData("row", "search-trending");
    // subscribedPlans = getIt<UserAccount>().customer?.activePlans;
    _checkInternetConnectionAndSpeed();
  }
  void gotoPage(int index) {
    pageController.jumpToPage(index);
    page.value = index;
  }
  Future<void> _fetchData() async {
    _incrementCount++;
    _setupTabs();
    setupHomePage();
  }
  _setupTabs() {
    tabs = [
      // HomeMainView(
      //   itemType: "page",
      //   itemId: "home",
      //   key: Key("home $_incrementCount"),
      // ),
      HomeTab(
        //controller: controller,
        mediaDetailFuture: () => fetchCombinedHomeRows(getIt<SensyApi>()),
        itemType: "page",
        itemId: "home",
        key: Key("home $_incrementCount"),
      ),
      NewsTab(
        itemType: "news",
        //controller: controller,
        // mediaDetailFuture: () =>
        //     getIt<SensyApi>().fetchMediaDetail("tab", "news"),
        key: Key("news $_incrementCount"),
      ),
      LiveTvTab(
        //controller: controller,
        // mediaDetailFuture: () =>
        //     getIt<SensyApi>().fetchChannelsSchedule('567,36'),
        key: Key("guide $_incrementCount"),
      ),
      // HomeTab(
      //   //controller: controller,
      //   mediaDetailFuture: () =>
      //       getIt<SensyApi>().fetchMediaDetail("tab", "channels"),
      //   key: Key("channels $_incrementCount"),
      // ),
      SportsTab(
        itemType: "sports",
        //controller: controller,
        // mediaDetailFuture: () =>
        //     getIt<SensyApi>().fetchMediaDetail("tab", "sports"),
        key: Key("sports $_incrementCount"),
      ),
      const ProfileMainScreen(),
      HomeTab(
        mediaDetailFuture: () =>
            getIt<SensyApi>().fetchMediaDetail("tab", "movies"),
        key: Key("movies $_incrementCount"),
      ),
      HomeTab(
        mediaDetailFuture: () =>
            getIt<SensyApi>().fetchMediaDetail("tab", "tv_shows"),
        key: Key("tv_shows $_incrementCount"),
      ),
      HomeTab(
        mediaDetailFuture: () =>
            getIt<SensyApi>().fetchMediaDetail("tab", "kids"),
        key: Key("kids $_incrementCount"),
      ),
      GameTab(
        mediaDetailFuture: () =>
            getIt<SensyApi>().fetchMediaDetail("tab", "games"),
        key: Key("games $_incrementCount"),
      ),
      HomeTab(
        mediaDetailFuture: () =>
            getIt<SensyApi>().fetchMediaDetail("tab", "library"),
        key: Key("games $_incrementCount"),
      ),
    ];
  }
  Future<MediaDetail> fetchCombinedHomeRows(SensyApi api) {
    return api
        .fetchMediaDetail("tab", "continue_watching")
        .catchError((errorObj, stackTrace) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to fetch Continue Watching rows: ${response?.statusCode}");
          break;
        default:
          if (kDebugMode) {
            print(
                "Non DioException during fetch Continue Watching rows: $errorObj");
          }
          showVanillaToast("Failed to fetch Continue Watching rows");
      }
      return Future.value(const MediaDetail());
    }).then((continueWatching) {
      return fetchDeeplinksRows(api, continueWatching);
    });
  }

  Future<MediaDetail> fetchDeeplinksRows(
      SensyApi api, MediaDetail continueWatching) {
    return api.fetchMediaDetail("page", "home").then((home) {
      List<MediaRow> rows = [];
      rows.addAll(continueWatching.mediaRows);
      rows.addAll(home.mediaRows);
      return Future.value(MediaDetail(
        mediaHeader: home.mediaHeader,
        mediaRows: rows,
      ));
    }).catchError((errorObj, stackTrace) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to fetch Home rows: ${response?.statusCode}");
          break;
        default:
          if (kDebugMode) {
            print("Non DioException during fetch Home rows: $errorObj");
          }
          showVanillaToast("Failed to fetch Home rows");
      }
      return Future.value(continueWatching);
    });
  }
  setupHomePage() async {
    page.value = 0;
    pageController.jumpToPage(0);
  }

  Future<double> _measureDownloadSpeed() async {
    const url = 'http://speedtest.tele2.net/10MB.zip'; // A 10MB file for testing
    final stopwatch = Stopwatch()..start();
    final response = await http.get(Uri.parse(url));
    stopwatch.stop();
    final elapsedMilliseconds = stopwatch.elapsedMilliseconds;
    final speedInKBps = (response.contentLength! / elapsedMilliseconds) * 1000;
    return speedInKBps;
  }

  void _showSpeedWarningDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Network Speed Warning',style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "Gilroy",
            color: Colors.white,
          ),),
          content: Text('The network speed is below 3G. Please connect to a faster network.',style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "Gilroy",
            color: Colors.white,
          ),),
          actions: <Widget>[
            TextButton(
              child: Text('OK',style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Gilroy",
                color: Colors.white,
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNoInternetConnectionDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection',style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "Gilroy",
            color: Colors.white,
          ),),
          content: Text('Please check your internet connection.',style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "Gilroy",
            color: Colors.white,
          ),),
          actions: <Widget>[
            TextButton(
              child: Text('OK',style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Gilroy",
                color: Colors.white,
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    getIt<UserAccount>().removeListener(_fetchData);
    getIt<UserInterestsChangeNotifier>().removeListener(_fetchData);
    getIt<FavoriteLanguagesChangeNotifier>().removeListener(_fetchData);
    super.dispose();
  }
  Future<void> _checkInternetConnectionAndSpeed() async {
    try {
      final response = await http.get(Uri.parse('http://google.com'));
      if (response.statusCode == 200) {
        // Internet connection is available
        final downloadSpeed = await _measureDownloadSpeed();
        if (downloadSpeed < 3000) {
          _showSpeedWarningDialog();
        }
      } else {
        _showNoInternetConnectionDialog();
      }
    } on SocketException catch (_) {
      _showNoInternetConnectionDialog();
    }
  }
}
