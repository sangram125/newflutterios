import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/mobile/home/controller/homeController.dart';
import 'package:dor_companion/mobile/widgets/media_detail/media_item_view.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/api/sensy_api.dart';
import '../../../data/models/models.dart';
import '../../../data/models/user_account.dart';
import '../../../injection/injection.dart';
import '../../widgets/live_tv_view.dart';
import '../../widgets/media_detail/media_row_view.dart' as mob_row_view;
import '../../../responsive.dart';
import '../../../utils.dart';
import '../../../web/widgets/media_detail/media_row_view.dart' as web_row_view;
import '../../../widgets/banner_carousel.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/media_detail/mdp_loaders.dart';
import '../../../widgets/media_detail/media_rows_view.dart';

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
  final homeCtrl = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    homeCtrl.key.value = widget.key.toString();
    if (kDebugMode) {
      print(getIt<UserAccount>().profileName);
    }
    homeCtrl.fetchBanners();
    _fetchData();
  }

  _fetchData() {
    if (mounted) {
      setState(() {
        homeCtrl.isError.value = false;
        homeCtrl.rows.value = [];
        // _banners = [];
      });
    }

    homeCtrl.currentPage.value = 1;
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
            homeCtrl.isError.value = true;
          });
        }
        return;
      }
      if (kDebugMode) {
        print("${widget.key} received non-empty rows");
      }
      if (mounted) {
        // setState(() {
        homeCtrl.isError.value = false;
        for (MediaRow row in mediaDetail.mediaRows) {
          if (row.mediaItems.isNotEmpty) {
            homeCtrl.rows.add(row);
            if (widget.itemType == "page") {
              for (var mediaItem in row.mediaItems) {
                mediaItem.isHomeScreen = true;
              }
            } else {
              for (var mediaItem in row.mediaItems) {
                mediaItem.isHomeScreen = false;
              }
            }
          }
        }
        if (widget.itemType == "page") {}

        if (kDebugMode) {
          print(
              "${widget.key} ${mediaDetail.mediaHeader?.meta.totalPages} total pages");
        }
        homeCtrl.totalPages = mediaDetail.mediaHeader?.meta.totalPages ?? 0;

        homeCtrl.currentPage.value++;
        addRows(
          getIt<SensyApi>().fetchPaginatedMediaDetail(
              widget.itemType!, widget.itemId!, homeCtrl.currentPage.value),
          homeCtrl.rows.last,
        ).catchError((errorObj) {
          switch (errorObj.runtimeType) {
            case DioException:
              final response = (errorObj as DioException).response;
              showVanillaToast("Failed to fetch next page: "
                  "${response?.statusCode}");
          }
        });
        homeCtrl.currentPage.value++;
        addRows(
          getIt<SensyApi>().fetchPaginatedMediaDetail(
              widget.itemType!, widget.itemId!, homeCtrl.currentPage.value),
          homeCtrl.rows.last,
        ).catchError((errorObj) {
          switch (errorObj.runtimeType) {
            case DioException:
              final response = (errorObj as DioException).response;
              showVanillaToast("Failed to fetch next page: "
                  "${response?.statusCode}");
          }
        });
        homeCtrl.currentPage.value++;
        addRows(
          getIt<SensyApi>().fetchPaginatedMediaDetail(
              widget.itemType!, widget.itemId!, homeCtrl.currentPage.value),
          homeCtrl.rows.last,
        ).catchError((errorObj) {
          switch (errorObj.runtimeType) {
            case DioException:
              final response = (errorObj as DioException).response;
              showVanillaToast("Failed to fetch next page: "
                  "${response?.statusCode}");
          }
        });
        // });
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
          homeCtrl.isError.value = true;
        });
      }
    });
  }

  Widget _buildBanners() {
    final banners = ResponsiveWidget.isLargeScreen(context)
        ? homeCtrl.bannersWeb
        : homeCtrl.banners;
    final isBannersError = ResponsiveWidget.isLargeScreen(context)
        ? homeCtrl.isBannersWebError
        : homeCtrl.isBannersError;
    if (banners.isEmpty && !isBannersError.value) {
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

        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ElevatedButton(
            onPressed: homeCtrl.fetchBanners(),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: Text(
              "Tap to retry",
                style: AppTypography.loginText.copyWith(color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,fontFamily: "Roboto"),
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
        SizedBox(
          height: 1,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (homeCtrl.rows.isEmpty && !homeCtrl.isError.value) {
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

    if (homeCtrl.isError.value) {
      if (kDebugMode) {
        print("${widget.key} is error");
      }
      return SizedBox(
        height: 200,
        child: Center(
          child: ElevatedButton(
            onPressed: _fetchData,
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text("Tap to retry"),
          ),
        ),
      );
    }

    final isLargeScreen = ResponsiveWidget.isLargeScreen(context);
    if (kDebugMode) {
      print(
          "${widget.key} rows not empty and not error. Rows length: ${homeCtrl.rows.length}, current page: ${homeCtrl.currentPage}, total pages: ${homeCtrl.totalPages}");
    }
    final Trace trace =
        FirebasePerformance.instance.newTrace('fetch-paginated-media-detail');
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Obx(
        () => AnimatedOpacity(
          duration: const Duration(microseconds: 100),
          opacity: homeCtrl.fabIsVisible.value ? 1 : 0,
          child: Container(
            margin: const EdgeInsets.only(bottom: 76.0),
            child: FloatingActionButton(
              onPressed: () {
                if (kDebugMode) {
                  print("event call");
                }
                homeCtrl.eventCall.scrollEvent('home_screen');
                homeCtrl.fabIsVisible.value = false;
                if (homeCtrl.scrollController.hasClients) {
                  final position =
                      homeCtrl.scrollController.position.minScrollExtent;
                  homeCtrl.scrollController.animateTo(
                    position,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOut,
                  );
                }
              },
              isExtended: true,
              tooltip: "Scroll to Top",
              child: const Icon(Icons.arrow_upward),
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: ListView.builder(
          controller: homeCtrl.scrollController,
          itemCount: homeCtrl.rows.length +
              (homeCtrl.currentPage < homeCtrl.totalPages ? 3 : 2),
          itemBuilder: (context, index) {
            if (kDebugMode) {
              print("${widget.key} building row $index");
            }
            if (index == 0) {
              return _buildBanners();
            }

            if (widget.itemType != null &&
                widget.itemId != null &&
                homeCtrl.currentPage < homeCtrl.totalPages &&
                index > homeCtrl.rows.length - _nextPageBuffer + 1) {
              if (kDebugMode) {
                print("object");
              }
              homeCtrl.currentPage++;
              trace.start();
              // addRows(
              //   getIt<SensyApi>().fetchPaginatedMediaDetail(
              //       widget.itemType!, widget.itemId!, homeCtrl.currentPage.value),
              //   homeCtrl.rows.last,
              // ).catchError((errorObj) {
              //   switch (errorObj.runtimeType) {
              //     case DioException:
              //       final response = (errorObj as DioException).response;
              //       showVanillaToast("Failed to fetch next page: "
              //           "${response?.statusCode}");
              //   }
              // });
              trace.stop();
            }

            if (index >= homeCtrl.rows.length + 1) {
              return const SizedBox(
                height: 75,
                child: Center(child: Text("")),
              );
            }

            int count = homeCtrl.currentPage < homeCtrl.totalPages ? 3 : 2;
            if (index == homeCtrl.rows.length + count - 1) {
              return const SizedBox(height: 75);
            }

            // To ensure small list of rows remains scrollable to show/hide appbar
            /*if (index >= rows.length + 1) {
              return const SizedBox(height: 275);
            }*/
            if (homeCtrl.rows[index - 1].mediaItems.isEmpty) {
              return const SizedBox();
            }

            return isLargeScreen
                ? web_row_view.MediaRowView(homeCtrl.rows[index - 1],
                    addRows: homeCtrl.addRows)
                : mob_row_view.MediaRowView(
                    homeCtrl.rows[index - 1],
                    addRows: homeCtrl.addRows,
                    set: (data) {
                      homeCtrl.rows.value = data;
                      if (kDebugMode) {
                        print("index--- $index");
                      }
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

  @override
  bool get wantKeepAlive => true;

  Future<void> addRows(Future<MediaDetail> fetchRows, MediaRow afterRow) {
    return fetchRows.then((newRows) {
      homeCtrl.rows
          .insertAll(homeCtrl.rows.indexOf(afterRow) + 1, newRows.mediaRows);
      setState(() {});
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
}
