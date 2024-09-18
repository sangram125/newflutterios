
import 'package:dio/dio.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/redesign/home_screen/widget/continue_watching_rail.dart';
import 'package:dor_companion/redesign/home_screen/widget/explore_ott_home_view.dart';
import 'package:dor_companion/redesign/home_screen/widget/filter_by_genre.dart';
import 'package:dor_companion/redesign/home_screen/widget/filter_by_moods.dart';
import 'package:dor_companion/redesign/home_screen/widget/language_filter.dart';
import 'package:dor_companion/redesign/home_screen/widget/latest_content.dart';
import 'package:dor_companion/redesign/home_screen/widget/personalised_collection_view.dart';
import 'package:dor_companion/redesign/home_screen/widget/special_collection_view.dart';
import 'package:dor_companion/redesign/home_screen/widget/top_ten_content_view.dart';
import 'package:dor_companion/redesign/live_tv/widgets/card_banners.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:dor_companion/widgets/appbar_custom.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../data/api/sensy_api.dart';
import '../../data/models/models.dart';
import '../../data/models/user_account.dart';
import '../../injection/injection.dart';
import '../../responsive.dart';
import '../../widgets/media_detail/mdp_loaders.dart';
import '../../widgets/media_detail/media_rows_view.dart';
import '../screens/no_internet.dart';
import '../search/search_controller/search_controller.dart';
import 'live_tv_view.dart';

const int _nextPageBuffer = 2;

class HomeTab extends StatefulWidget {
  HomeTab({
    Key? key,
    required this.mediaDetailFuture,
    this.itemType,
    this.itemId,
  }) : super(key: key);

  //final TrackingScrollController controller;
  final FetchRows mediaDetailFuture;
  late String? itemType;
  late String? itemId;

  int count = 0;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  List<StandardPromotion> _banners = [];
  bool _isBannersError = false;
  List<StandardPromotion> _bannersWeb = [];
  bool _isBannersWebError = false;
  final ScrollController _scrollController = ScrollController();
   final searchController =  Get.put(SearchViewController());
  List<MediaRow> rows = [];
  List<MediaRow> rows2 = [];
  bool isError = false;
  int currentPage = 1;
  int totalPages = 1;
  bool fabIsVisible = false;

  @override
  void initState() {
    super.initState();
    print(getIt<UserAccount>().profileName);
    _fetchBanners();
    _fetchData();
    //_fetchMood();
    _listenToPaginationScroll();
    searchController.fetchData("tab", "find");
    _scrollController.addListener(() {
      setState(() {
        print("----value ${_scrollController.position.minScrollExtent}");
        fabIsVisible = _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse;
        if (ScrollDirection.forward ==
            _scrollController.position.userScrollDirection) {
          print("down");
          fabIsVisible = _scrollController.position.userScrollDirection ==
              ScrollDirection.forward;
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          print("up---");
          fabIsVisible = _scrollController.position.userScrollDirection ==
              ScrollDirection.reverse;
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  fetchGenres() {
    homeState.isGenresError.value = false;
    final Trace trace = FirebasePerformance.instance.newTrace('fetch-genres');
    trace.start();
    getIt<SensyApi>().fetchGenres().then((genres) {
      if (genres.list.isEmpty) {
        homeState.isGenresError.value = true;
        return;
      }

      homeState.genres.value = genres;

      homeState.isGenresError.value = false;
      homeState.rows.notifyListeners();
      homeState.banners.notifyListeners();
      appState.genres.notifyListeners();
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print("Failed to fetch Genres: ${response?.statusCode}");
          break;
        default:
          if (kDebugMode) {
            print("Encountered unknown error of type ${errorObj.runtimeType}");
          }
      }
      homeState.isGenresError.value = true;
    });
    trace.stop();
  }
  _listenToPaginationScroll() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        debugPrint('Current page : $currentPage, Called getUsers()');
        // _fetchData(isLoadMore: true);
      }
    });
  }

  _fetchBanners() {
    setState(() {
      _isBannersError = false;
      _banners = [];
    });

    // Mobile banners
    getIt<SensyApi>().fetchPromotions(getMobilePromotionsId()).then((banners) {
      if (banners.standardPromotions.isEmpty) {
        setState(() {
          _isBannersError = true;
        });
        return;
      }

      setState(() {
        _banners = banners.standardPromotions;
        homeState.banners.value = banners.standardPromotions;
        print("banners = ${homeState.banners.value.length}");
        _isBannersError = false;
      });
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
      setState(() {
        _isBannersError = true;
      });
    });

    // Web banners
    getIt<SensyApi>().fetchPromotions(getWebPromotionsId()).then((banners) {
      if (banners.standardPromotions.isEmpty) {
        setState(() {
          _isBannersWebError = true;
        });
        return;
      }

      setState(() {
        _bannersWeb = banners.standardPromotions;
        _isBannersWebError = false;
      });
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
      setState(() {
        _isBannersWebError = true;
      });
    });
  }


  int getMobilePromotionsId() {
    if (widget.key.toString().contains("news")) {
      return 46;
    } else if (widget.key.toString().contains("sports")) {
      return 47;
    } else if (widget.key.toString().contains("games")) {
      return 74;
    } else if (getIt<UserAccount>().isRestricted == true) {
      return 54;
    } else {
      return 44;
    }
  }

  int getWebPromotionsId() {
    if (widget.key.toString().contains("news")) {
      return 48;
    } else if (widget.key.toString().contains("sports")) {
      return 49;
    }
    return 44;
  }

  _fetchData() async {
    print("firebase_performance");

    final Trace trace = FirebasePerformance.instance.newTrace('fetch-data');
    trace.start();

    if (mounted) {
      setState(() {
        isError = false;
        rows = [];
        // _banners = [];
      });
    }

    currentPage = 1;
    final mediaDetailFetch = widget.mediaDetailFuture();

    return mediaDetailFetch.then((mediaDetail) {
      if (kDebugMode) {
        print("${widget.key} received mediaDetail");
      }
      if (mediaDetail.mediaRows.isEmpty) {
        if (kDebugMode) {
          print("${widget.key} received empty rows");
        }
        if (mounted) {
          setState(() {
            isError = true;
          });
        }
        return;
      }
      if (kDebugMode) {
        print("${widget.key} received non-empty rows");
      }
      if (mounted) {
        setState(() {
          isError = false;
          for (MediaRow row in mediaDetail.mediaRows) {
            if (row.mediaItems.isNotEmpty) {
              rows.add(row);
              homeState.rows.value.add(row);
              print("value adde");
              if (widget.itemType == "page") {
                for (var mediaItem in row.mediaItems) {
                  mediaItem.isHomeScreen = true;
                }
              } else {
                for (var mediaItem in row.mediaItems) {
                  mediaItem.isHomeScreen = false;
                }
              }
              // _banners = row as List<StandardPromotion>;
            }
          }
          if (widget.itemType == "page") {
          }

          //  print("rossss  $rows");

          if (kDebugMode) {
            print(
                "${widget.key} ${mediaDetail.mediaHeader?.meta.totalPages} total pages");
          }
          totalPages = mediaDetail.mediaHeader?.meta.totalPages ?? 0;
        });
        trace.stop();
      } else {
        if (kDebugMode) {
          print("${widget.key} received non-empty rows but not mounted");
        }
      }
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
      if (mounted) {
        setState(() {
          isError = true;
        });
      }
    });
  }
  static MediaAction? getFirstWatchOnActionOrNull(List<MediaAction> actions) {
    print("wat act ${actions.isEmpty}");
    print("wat act ${actions.elementAt(0).title}");
    if (actions.isEmpty) return null;
    for (MediaAction action in actions) {
      if (ActionTypes.watchOnActionTypes
          .contains(action.chatAction.actionType)) {
        return action;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (rows.isEmpty && !isError) {
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

    if (isError) {
      if (kDebugMode) {
        print("${widget.key} is error");
      }
      return NoInternet();
    }
    //new
    List<StandardPromotion> banners = ResponsiveWidget.isLargeScreen(context)
        ? homeState.bannersWeb.value
        : homeState.banners.value;
    final isBannersError = ResponsiveWidget.isLargeScreen(context)
        ? homeState.isBannersWebError.value
        : homeState.isBannersError.value;

    return PerformanceTrackedWidget(
      widgetName: 'home-main-view',

      child: Scaffold(

        appBar: LogoAppBar(showLogo: true, pageText: '',),
          backgroundColor: Colors.black.withOpacity(0.800000011920929),
        // floatingActionButton: AnimatedOpacity(
        //   duration: const Duration(microseconds: 100),
        //   opacity: fabIsVisible ? 1 : 0,
        //   child: Container(
        //     margin: const EdgeInsets.only(bottom: 76.0),
        //     child: FloatingActionButton(
        //       onPressed: () {
        //         setState(() {
        //           fabIsVisible = false;
        //         });
        //         print(
        //             "scroll value ${_scrollController.position.minScrollExtent}");
        //         if (_scrollController.hasClients) {
        //           final position = _scrollController.position.minScrollExtent;
        //           _scrollController.animateTo(
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

        body: SafeArea(
            child: SingleChildScrollView(
                child:  Column(children: [
                  homeState.banners.value.isEmpty
                      ? const SizedBox()
                      :
                  isBannersError
                      ? SizedBox(
                      height: MediaQuery.of(context).size.width,
                      child: Center(
                          child: ElevatedButton(
                              onPressed: fetchBanners,
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                                  textStyle: AppTypography.fontSizeChanges),
                              child: const Text("Tap to retry",
                                  style: AppTypography.undefinedTextStyle))))
                      : CommonBanner(
                    isHomeScreen: true,
                      bannerList: banners,
                      isShowPlayButton: true,
                      isShowNotifyButton: false,
                      isShowPlayWithWatchListButton: false,
                      onCardPressed: (index) {
                        banners[index].action.executeAction(context);
                        //eventCall.bannerClickEvent('home_screen');
                      }),
                  Container(
                      color: Colors.black.withOpacity(0.800000011920929),
                      child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TypesOfLiveChannelGridScreen(),
                            ContinueWatchingRailView(),
                            LatestContentView(rows:homeState.rows.value,),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 0.5,
                                  decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [Color(0xFF4D0CDA),Color(0xFF4D0CDA),Color(0xFF733FE2), Color(0xFF733FE2)],
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [Color(0xFF4D0CDA), Color(0xFF733FE2)],
                                    ),
                                    shape: StarBorder(
                                      points: 4,
                                      innerRadiusRatio: 0.38,
                                      pointRounding: 0,
                                      valleyRounding: 0,
                                      rotation: 0,
                                      squash: 0,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 0.5,
                                  decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [Color(0xFF4D0CDA),Color(0xFF4D0CDA), Color(0xFF733FE2),Color(0xFF733FE2)],
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            ExploreOttHomeView(),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 0.5,
                                  decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [Color(0xFF4D0CDA), Color(0xFF733FE2)],
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [Color(0xFF4D0CDA), Color(0xFF733FE2)],
                                    ),
                                    shape: StarBorder(
                                      points: 4,
                                      innerRadiusRatio: 0.38,
                                      pointRounding: 0,
                                      valleyRounding: 0,
                                      rotation: 0,
                                      squash: 0,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 0.5,
                                  decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [Color(0xFF4D0CDA), Color(0xFF733FE2)],
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ],
                            ),
                            TopTenContentView(),
                            PersonalisedCollectionView(),
                            SpecialCollectionView(),
                            HomePageLanguageTabView(),
                            FilterByMoodTabView(crossAxisCount:1,childAspectRatio :0.9,height: 0.18),
                            FilterByGenreTabView()
                          ])),

                ])))

      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
