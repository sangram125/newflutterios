import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/mobile/widgets/media_detail/media_item_view.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../data/api/sensy_api.dart';
import '../../data/models/models.dart';
import '../../data/models/user_account.dart';
import '../../injection/injection.dart';
import '../../mobile/widgets/media_detail/media_row_view.dart' as mob_row_view;
import '../../responsive.dart';
import '../../utils.dart';
import '../../web/widgets/media_detail/media_row_view.dart' as web_row_view;
import '../../widgets/banner_carousel.dart';
import '../../widgets/loader.dart';
import '../../widgets/media_detail/mdp_loaders.dart';
import '../../widgets/media_detail/media_rows_view.dart';
import '../screens/no_internet.dart';
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

  // final ScrollController _buttonScrollController = ScrollController();

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
    _listenToPaginationScroll();
    _scrollController.addListener(() {
      setState(() {
        // if (_scrollController.position.minScrollExtent == 0) {
        //   setState(() {
        //     fabIsVisible = false;
        //   });
        // } else {
        //   setState(() {
        //     fabIsVisible = true;
        //   });
        // }
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
    LiveTvTab liveTvTab = LiveTvTab();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        print("banners = ${_banners.length}");
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
            //        addRows(
            //   getIt<SensyApi>().fetchPaginatedMediaDetail(
            //       widget.itemType!, widget.itemId!, 0),
            //   rows.last,
            // ).catchError((errorObj) {
            //   switch (errorObj.runtimeType) {
            //     case DioException:
            //       final response = (errorObj as DioException).response;
            //       showVanillaToast("Failed to fetch next page: "
            //           "${response?.statusCode}");
            //   }
            // });
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

  Widget _buildBanners() {
    final banners =
        ResponsiveWidget.isLargeScreen(context) ? _bannersWeb : _banners;
    final isBannersError = ResponsiveWidget.isLargeScreen(context)
        ? _isBannersWebError
        : _isBannersError;
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
            onPressed: _fetchBanners,
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
            banners: banners,
          ),
      ],
    );
  }

  _buildChips() {
    return const Column(
      children: [
        // const SizedBox(
        //   height: 15,
        // ),
        // SizedBox(
        //   height: 35,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 10.0),
        //     child: ListView(
        //       scrollDirection: Axis.horizontal,
        //       children: [
        //         ChipWidget(
        //           onTap: () {
        //             context.read<HomePageProvider>().gotoPage(5);
        //           },
        //           title: "Movies",
        //           imagePath: 'assets/images/home_images/movie.png',
        //         ),
        //         ChipWidget(
        //           onTap: () {
        //             context.read<HomePageProvider>().gotoPage(6);
        //           },
        //           title: "TV Shows",
        //           imagePath: 'assets/images/home_images/popcorn.png',
        //         ),
        //         ChipWidget(
        //           onTap: () {
        //             context.read<HomePageProvider>().gotoPage(2);
        //           },
        //           title: "Live TV",
        //           imagePath: 'assets/images/home_images/television.png',
        //         ),
        //         ChipWidget(
        //           onTap: () {
        //             context.read<HomePageProvider>().gotoPage(7);
        //           },
        //           title: "Kids",
        //           imagePath: 'assets/images/home_images/kids.png',
        //         ),
        //         ChipWidget(
        //           onTap: () {
        //             context.read<HomePageProvider>().gotoPage(3);
        //           },
        //           title: "Sports",
        //           imagePath: 'assets/images/home_images/sports.png',
        //         ),
        //         ChipWidget(
        //           onTap: () {
        //             context.read<HomePageProvider>().gotoPage(1);
        //           },
        //           title: "News",
        //           imagePath: 'assets/images/home_images/newspaper.png',
        //         ),
        //         ChipWidget(
        //           onTap: () {
        //             context.read<HomePageProvider>().gotoPage(8);
        //           },
        //           title: "Games",
        //           imagePath: 'assets/images/home_images/game.png',
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // const Divider(),
        SizedBox(
          height: 1,
        ),
        // InkWell(
        //   onTap: () => context.push("/subscriptions"),
        //   child: const Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 15),
        //     child: SizedBox(
        //       height: 150,
        //       child: Image(
        //           image: AssetImage('assets/images/home_images/Card.png')),
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   height: 20,
        // ),
        // const Divider(),
      ],
    );
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

    final isLargeScreen = ResponsiveWidget.isLargeScreen(context);
    if (kDebugMode) {
      print(
          "${widget.key} rows not empty and not error. Rows length: ${rows.length}, current page: $currentPage, total pages: $totalPages");
    }
    return PerformanceTrackedWidget(
      widgetName: 'home-main-view',
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
        body: ListView.builder(
            controller: _scrollController,
            itemCount: rows.length + (currentPage < totalPages ? 3 : 2),
            itemBuilder: (context, index) {
              if (kDebugMode) {
                print("${widget.key} building row $index");
              }
              if (index == 0) {
                return _buildBanners();
              }

              if (widget.itemType != null &&
                  widget.itemId != null &&
                  currentPage < totalPages &&
                  index > rows.length - _nextPageBuffer + 1) {
                print("object");
                currentPage++;
                // addRows(
                //   getIt<SensyApi>().fetchPaginatedMediaDetail(
                //       widget.itemType!, widget.itemId!, currentPage),
                //   rows.last,
                // ).catchError((errorObj) {
                //   switch (errorObj.runtimeType) {
                //     case DioException:
                //       final response = (errorObj as DioException).response;
                //       showVanillaToast("Failed to fetch next page: "
                //           "${response?.statusCode}");
                //   }
                // });
              }

              // if (index >= rows.length + 1) {
              //   return const SizedBox(
              //     height: 75,
              //     child: Center(child: Loader()),
              //   );
              // }

              int count = currentPage < totalPages ? 3 : 2;
              if (index == rows.length + count - 1) {
                return const SizedBox(height: 0);
              }

              // To ensure small list of rows remains scrollable to show/hide appbar
              /*if (index >= rows.length + 1) {
                return const SizedBox(height: 275);
              }*/
              if (rows[index - 1].mediaItems.isEmpty) {
                return const SizedBox();
              }

              return isLargeScreen
                  ? web_row_view.MediaRowView(rows[index - 1], addRows: addRows)
                  : mob_row_view.MediaRowView(
                      rows[index - 1],
                      isTopicScreen: true,
                      addRows: addRows,
                      set: (data) {
                        rows = data;
                        MediaItemViewState.isFavoritePressed = null;
                        setState(() {});
                      },
                    );
            },
          ),
      ),
    );
    /*return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...rows
            .map((mediaRow) => isLargeScreen
                ? web_row_view.MediaRowView(mediaRow, addRows: addRows)
                : mobile_row_view.MediaRowView(mediaRow, addRows: addRows))
            .toList()
      ],
    );*/
  }

  Future<void> addRows(Future<MediaDetail> fetchRows, MediaRow afterRow) {
    return fetchRows.then((newRows) {
      // if(widget.count==0 || widget.count==1) {

      // widget.count++;
      setState(() {
        rows.insertAll(rows.indexOf(afterRow) + 1, newRows.mediaRows);
        // fabIsVisible = true;
        // print("apps ${}");
      });
      //   MediaRow appsForu = rows
      //       .where((element) => element.contentType == 116)
      //       .first;
      //
      //   // print("rowsappsForu $appsForu");
      //   rows.remove(appsForu);
      //   // print("rows $rows");
      //
      //   rows.insert(0, appsForu);
      //   setState(() {
      //
      //   });
      // }
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
