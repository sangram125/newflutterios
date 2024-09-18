import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/user_interests.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/custom_bottom_sheet.dart';
import 'package:dor_companion/mobile/widgets/live_news_page.dart';
import 'package:dor_companion/mobile/widgets/tv_guide_page.dart';
import 'package:dor_companion/mobile/widgets/media_detail/media_item_view.dart';
import 'package:dor_companion/widgets/banner_carousel.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/api/sensy_api.dart';
import '../../data/app_state.dart';
import '../../data/models/models.dart';
import '../../injection/injection.dart';
import '../../mobile/widgets/media_detail/media_row_view.dart' as mob_row_view;
import '../../responsive.dart';
import '../../web/widgets/media_detail/media_row_view.dart' as web_row_view;
import '../../widgets/loader.dart';
import '../../widgets/media_detail/mdp_loaders.dart';

callInit() {
  fetchChannels().then((_) {
    fetchData();
  });
  fetchDatLive();
  fetchBanners();
  fetchGenres();
  fetchLanguages();
  listenToPaginationScroll();
  appState.scrollController.value.addListener(() {
    appState.fabIsVisible.value =
        appState.scrollController.value.position.userScrollDirection ==
            ScrollDirection.reverse;
  });

}


fetchBanners() {
  appState.isBannersError.value = false;
  appState.banners.value = [];

  final Trace trace =
      FirebasePerformance.instance.newTrace('fetch-banners-live-tv');
  trace.start();
  getIt<SensyApi>().fetchPromotions(82).then((banners) {
    if (banners.standardPromotions.isEmpty) {
      appState.isBannersError.value = true;
      return;
    }
    appState.banners.value = banners.standardPromotions;
    appState.isBannersError.value = false;
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
    appState.isBannersError.value = true;
  });
  trace.stop();
  // getIt<SensyApi>().fetchPromotions(44).then((banners) {
  //   if (banners.standardPromotions.isEmpty) {
  //     setState(() {
  //       _isBannersError = true;
  //     });
  //     return;
  //   }
  //
  //   setState(() {
  //     _banners = banners.;
  //     _isBannersError = false;
  //   });
  // }).catchError((errorObj) {
  //   switch (errorObj.runtimeType) {
  //     case DioException:
  //       final response = (errorObj as DioException).response;
  //       print(object)("Failed to fetch banners: ${response?.statusCode}");
  //       break;
  //     default:
  //       if (kDebugMode) {
  //         print("Encountered unknown error of type ${errorObj.runtimeType}");
  //       }
  //   }
  //   if (mounted) {
  //     setState(() {
  //       _isBannersError = true;
  //     });
  //   }
  // });

  // Web banners
  getIt<SensyApi>().fetchPromotions(82).then((banners) {
    if (banners.standardPromotions.isEmpty) {
      appState.isBannersWebError.value = true;
      return;
    }

    appState.bannersWeb.value = banners.standardPromotions;
    appState.isBannersWebError.value = false;
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
    appState.isBannersWebError.value = true;
  });

  // getIt<SensyApi>().fetchPromotions(38).then((banners) {
  //   if (banners.standardPromotions.isEmpty) {
  //     setState(() {
  //       _isBannersWebError = true;
  //     });
  //     return;
  //   }
  //
  //   setState(() {
  //     _bannersWeb = banners.standardPromotions;
  //     _isBannersWebError = false;
  //   });
  // }).catchError((errorObj) {
  //   switch (errorObj.runtimeType) {
  //     case DioException:
  //       final response = (errorObj as DioException).response;
  //       print(object)("Failed to fetch banners: ${response?.statusCode}");
  //       break;
  //     default:
  //       if (kDebugMode) {
  //         print("Encountered unknown error of type ${errorObj.runtimeType}");
  //       }
  //   }
  //   if (mounted) {
  //     setState(() {
  //       _isBannersWebError = true;
  //     });
  //   }
  // });
}

listenToPaginationScroll() {
  appState.scrollController.value.addListener(() {
    if (appState.scrollController.value.position.pixels ==
        appState.scrollController.value.position.maxScrollExtent) {
      debugPrint(
          'Current page : ${appState.currentPage.value}, Called getUsers()');
      fetchData(isLoadMore: true);
    }
  });
  appState.rows.notifyListeners();
  appState.banners.notifyListeners();
  appState.channels.notifyListeners();
  appState.languages.notifyListeners();
  appState.filteredChannels.notifyListeners();
  appState.genres.notifyListeners();
}
fetchDatLive({bool isLoadMore = false}) {
  appState.isError.value = false;
  // final Trace trace = FirebasePerformance.instance.newTrace('fetch-banner-news');
  // trace.start();
  if (!isLoadMore) {
    appState.loadingPageRows.value = [];
  } else {
    appState.loadingMore.value = true;
  }
  final mediaDetailFetch = getIt<SensyApi>().fetchMediaDetail("tab", "channels");

  return mediaDetailFetch.then((mediaDetail) {
    if (mediaDetail.mediaRows.isEmpty) {
      appState.isError.value = true;
      return;
    }
    appState.isError.value = false;
    appState.currentPage.value++;
    for (MediaRow row in mediaDetail.mediaRows) {
      if (row.mediaItems.isNotEmpty) {
        appState.loadingPageRows.value.add(row);
        for (var mediaItem in row.mediaItems) {
          if (mediaItem.itemType == "page") {
            mediaItem.isHomeScreen = true;
          }else {
            mediaItem.isHomeScreen = false;
          }
        }
        // _banners = row as List<StandardPromotion>;
      }
      appState.loadingPageRows.notifyListeners();
      appState.banners.notifyListeners();
    }
    // totalPages = mediaDetail.mediaHeader.meta.totalPages;
    appState.loadingMore.value = false;
    appState.loadingPageRows.notifyListeners();

  }).catchError((errorObj) {
    switch (errorObj.runtimeType) {
      case DioException:
        final response = (errorObj as DioException).response;
       // showVanillaToast("Failed to fetch page: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          print("Encountered unknown error of type "
              "${errorObj.runtimeType} while fetching media detail");
          print("$errorObj");
        }
    }
    appState.isError.value = true;
  });
}
Future<void> fetchChannels() async {
  appState.isChannelsError.value = false;
  appState.channels.value = [];
  await getIt<SensyApi>().fetchChannels().then((channels) {
    if (channels.isEmpty) {
      appState.isChannelsError.value = true;
      return;
    }
    //print("channels list ${channels.elementAt(0).id}");
    appState.channels.value = channels;
    appState.filteredChannels.value = appState.channels.value;
   // print("channels list ${appState.filteredChannels.value.elementAt(0).id}");
    ///* Sorting the channel by keys as per given documentation
   // appState.filteredChannels.value.sort((p, n) => p.key.compareTo(n.key));
    appState.totalPages.value =
        (appState.filteredChannels.value.length / 10).ceil();
    appState.isChannelsError.value = false;
  }).catchError((errorObj) {
    switch (errorObj.runtimeType) {
      case DioException:
        final response = (errorObj as DioException).response;
        print("Failed to fetch Channels: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          print("Encountered unknown error of type ${errorObj.runtimeType}");
        }
    }
    appState.isChannelsError.value = true;
  });
}

fetchLiveNews({bool isLoadMore = false}) async {
  appState.isError.value = false;
  final mediaDetailFetch = getIt<SensyApi>().fetchLiveNews();
  return mediaDetailFetch.then((mediaDetail) {
    appState.liveNewsRow.value = mediaDetail;
  }).catchError((errorObj) {
    switch (errorObj.runtimeType) {
      case DioException:
        final response = (errorObj as DioException).response;
       // showVanillaToast("Failed to fetch page: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          print("Encountered unknown error of type "
              "${errorObj} while fetching media detail");
          print("$errorObj");
        }
    }
    //appState.isError.value = true;
  });
}

fetchLanguages() {
  appState.isLanguagesError.value = false;
  final Trace trace = FirebasePerformance.instance.newTrace('fetch-languages');
  trace.start();
  getIt<SensyApi>().fetchLanguages().then((languages) {
    if (languages.list.isEmpty) {
      appState.isLanguagesError.value = true;
      return;
    }

    appState.languages.value = languages;
    appState.languages.value.list
        .insert(0, Language(title: 'All', isSelected: true));
    appState.isLanguagesError.value = false;
    appState.rows.notifyListeners();
    appState.banners.notifyListeners();
    appState.channels.notifyListeners();
    appState.languages.notifyListeners();
    appState.filteredChannels.notifyListeners();
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
    appState.isLanguagesError.value = true;
  });
  trace.stop();
}

fetchGenres() {
  appState.isGenresError.value = false;
  final Trace trace = FirebasePerformance.instance.newTrace('fetch-genres');
  trace.start();
  getIt<SensyApi>().fetchGenres().then((genres) {
    if (genres.list.isEmpty) {
      appState.isGenresError.value = true;
      return;
    }

    appState.genres.value = genres;

    ///* Inserting the 'All' as the first element in the Genre List
    appState.genres.value.list.insert(0, Genre(title: 'All', isSelected: true));

    appState.isGenresError.value = false;
    appState.rows.notifyListeners();
    appState.banners.notifyListeners();
    appState.channels.notifyListeners();
    appState.languages.notifyListeners();
    appState.filteredChannels.notifyListeners();
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
    appState.isGenresError.value = true;
  });
  trace.stop();
}

fetchData({bool isLoadMore = false}) {
  appState.isError.value = false;
  if (!isLoadMore) {
    appState.rows.value = [];
  } else {
    appState.loadingMore.value = true;
  }
  final Trace trace =
      FirebasePerformance.instance.newTrace('fetch-channel-schedule-live-tv');
  trace.start();
  appState.currentPage.value = 1;
  final channelIdsToFetch = appState.filteredChannels.value
      .sublist((appState.currentPage.value - 1) * appState.filteredChannels.value.length,
      appState.currentPage.value * appState.filteredChannels.value.length)
      .map((channel) => channel.id)
      .join(',');
    final mediaDetailFetch =
    getIt<SensyApi>().fetchChannelsSchedule(channelIdsToFetch);
    return mediaDetailFetch.then((mediaDetail) {
      if (mediaDetail.mediaRows.isEmpty) {
        appState.isError.value = true;
        return;
      }
      appState.isError.value = false;
      appState.currentPage.value++;
      for (MediaRow row in mediaDetail.mediaRows) {
        if (row.mediaItems.isNotEmpty) {
          ///* Changing the title of [MediaRow], because it is representing the channel's key.
          ///* So, based on channel key, replacing the title with corresponding channel name
          Channel? channel;

          for (int i = 0; i < appState.filteredChannels.value.length; i++) {
            if (appState.filteredChannels.value[i].key == row.title) {
              channel = appState.filteredChannels.value[i];
              break;
            }
            appState.channelListForGenre.value.add(appState.filteredChannels.value[i]);
          }

          if (channel != null) {
            row.title = channel.name;
            row.rowImage = channel.image;
            for (var mediaItem in row.mediaItems) {
              mediaItem.video = channel.feedHLS;
              print("----------------------------------");
              print(mediaItem.video);
              print("----------------------------------");
              mediaItem.isLiveTVItem = true;
              mediaItem.source = channel.source;
            }
            appState.rows.value.add(row);
          }
          // _banners = row as List<StandardPromotion>;
        }
        appState.rows.notifyListeners();
        appState.banners.notifyListeners();
        appState.channels.notifyListeners();
        appState.languages.notifyListeners();
        appState.filteredChannels.notifyListeners();
        appState.genres.notifyListeners();
      }
      Set<String> uniqueGenres = {}; //
      for(int i= 0;i<appState.channelListForGenre.value.length;i++){

        uniqueGenres.add(appState.channelListForGenre.value.elementAt(i).genre);
        //ppState.genres.value.list.add(Genre(title:appState.filteredChannels.value[i].genre));
        //print("list of genre${appState.genres.value.list.elementAt(i).title}");
      }
      appState.genres.value.list.clear();
      uniqueGenres.forEach((genreTitle) {
        appState.genres.value.list.add(Genre(title: genreTitle));

      });
      appState.genres.value.list.insert(0,Genre(title: "All",isSelected: true));
      // totalPages = mediaDetail.mediaHeader.meta.totalPages;
      appState.loadingMore.value = false;
      appState.rows.notifyListeners();
      appState.banners.notifyListeners();
      appState.channels.notifyListeners();
      appState.languages.notifyListeners();
      appState.filteredChannels.notifyListeners();
      appState.genres.notifyListeners();
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
      appState.isError.value = true;
    });
    trace.stop();

}

class LiveTvTab extends StatefulWidget {
  LiveTvTab({
    Key? key,
    this.itemType,
    this.itemId,
  }) : super(key: key);

  late String? itemType;
  late String? itemId;

  @override
  State<LiveTvTab> createState() => _LiveTvTabState();
}

class _LiveTvTabState extends State<LiveTvTab>
    with AutomaticKeepAliveClientMixin {
  AnalyticsEvent eventCall = AnalyticsEvent();

  @override
  void initState() {
    print("-----------> call livetv-------");
    callInit();
    super.initState();
  }

  @override
  void dispose() {
    //appState.scrollController.value.dispose();
    //appState.isTVGuideTap.dispose();
    super.dispose();
  }



  _applyFilters() {
    Navigator.of(context).pop();
    List<String> _selectedGenres = appState.genres.value.list
        .where((genre) => genre.isSelected)
        .map((genre) => genre.title)
        .toList();
    bool isAllGenreSelected = _selectedGenres.first == 'All';
    List<String> _selectedLanguages = appState.languages.value.list
        .where((language) => language.isSelected)
        .map((language) => language.title)
        .toList();
    bool isAllLanguageSelected = _selectedLanguages.first == 'All';
    appState.filteredChannels.value = appState.channels.value
        .where((channel) =>
            (isAllGenreSelected || _selectedGenres.contains(channel.genre)) &&
            (isAllLanguageSelected ||
                _selectedLanguages.contains(channel.language)))
        .toList();

    appState.totalPages.value =
        (appState.filteredChannels.value.length / 10).ceil();
    appState.currentPage.value = 1;
    appState.rows.value = [];
    fetchData(isLoadMore: true);
  }

  Widget _buildBanners() {
    final banners =
        ResponsiveWidget.isLargeScreen(context) ? appState.bannersWeb.value : appState.banners.value;
    final isBannersError = ResponsiveWidget.isLargeScreen(context)
        ? appState.isBannersWebError.value
        : appState.isBannersError.value;
    if (banners.isEmpty && !isBannersError) {
      if (kDebugMode) {
        print("returning banner loader");
      }
      return SizedBox(
          height: MediaQuery.of(context).size.width,
          child: const Center(child: Loader()));
    }

    // if (isBannersError) {
    //   return SizedBox(
    //     height: MediaQuery.of(context).size.width,
    //     child: Center(
    //       child: ElevatedButton(
    //         onPressed: fetchBanners,
    //         style: ElevatedButton.styleFrom(
    //           shape: const StadiumBorder(),
    //           backgroundColor: Theme.of(context).colorScheme.tertiary,
    //           textStyle: AppTypography.fontSizeChanges,
    //         ),
    //         child: const Text("Tap to retry", style: AppTypography.undefinedTextStyle,),
    //       ),
    //     ),
    //   );
    // }

    return  Column(
      children: [
        // if (widget.itemId == "home")
       // _buildGenresChips(),
       //  BannersCarousel(
       //    banners: banners,
       //  ),
        //_buildLanguageChips(),
      ],
    );
  }

  Column _buildLanguageChips({required  Function() refreshCall}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 8.0, // Space between chips horizontally
          runSpacing: 4.0, // Space between chips vertically
          children: appState.languages.value.list.map((languages) {
            return LanguageChipWidget(
              onTap: () {
                eventCall.filterEventLiveTv('live_tv_screen');
                setState(() {
                  if (appState.languages.value.list.indexOf(languages) == 0) {
                    if (languages.isSelected) return;
                    languages.isSelected = !languages.isSelected;
                    if (languages.isSelected) {
                      appState.languages.value.list
                          .sublist(1)
                          .forEach((languages) => languages.isSelected = false);
                    }
                  } else {
                    languages.isSelected = !languages.isSelected;
                    if (appState.languages.value.list
                        .sublist(1)
                        .where((languages) => languages.isSelected)
                        .isNotEmpty) {
                      appState.languages.value.list.first.isSelected = false;
                    } else {
                      appState.languages.value.list.first.isSelected = true;
                    }
                  }
                  refreshCall();
                });
              },
              title: languages.title,
              isSelected: languages.isSelected,
            );
          }).toList(),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  _buildGenresChips( {required  Function() refreshCall}) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 8.0, // Space between chips horizontally
          runSpacing: 4.0, // Space between chips vertically
          children: appState.genres.value.list.map((genre) {
            return GenreChipWidget(
              onTap: () {
                eventCall.filterEventLiveTv('live_tv_screen');
                setState(() {
                  if (appState.genres.value.list.indexOf(genre) == 0) {
                    if (genre.isSelected) return;
                    genre.isSelected = !genre.isSelected;
                    if (genre.isSelected) {
                      appState.genres.value.list
                          .sublist(1)
                          .forEach((genre) => genre.isSelected = false);
                    }
                  } else {
                    genre.isSelected = !genre.isSelected;
                    if (appState.genres.value.list
                        .sublist(1)
                        .where((genre) => genre.isSelected)
                        .isNotEmpty) {
                      appState.genres.value.list.first.isSelected = false;
                    } else {
                      appState.genres.value.list.first.isSelected = true;
                    }
                  }
                });
              refreshCall();
              },
              title: genre.title,
              isSelected: genre.isSelected,
            );
          }).toList(),
        ),
        const SizedBox(
          height: 4,
        ),
        // const Divider(),
        // const SizedBox(
        //   height: 20,
        // ),
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
    return ValueListenableBuilder(
        valueListenable: appState.channels,
        builder: (context, value, child) {
          return ValueListenableBuilder(
              valueListenable: appState.banners,
              builder: (context, value, child) {
                return ValueListenableBuilder(
                  valueListenable: appState.rows,
                  builder: (context, value, child) {
                    if (appState.rows.value.isEmpty &&
                        !appState.isError.value && !appState.loadingMore.value) {
                      if (kDebugMode) {
                        print("${widget.key} rows empty and not error");
                      }
                      return const PerformanceTrackedWidget(
                        widgetName: 'live-tv-view',
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child:
                                SingleChildScrollView(child: MDPBodyLoader()),
                          ),
                        ),
                      );
                    }

                    if (appState.isError.value) {
                      if (kDebugMode) {
                        print("${widget.key} is error");
                      }
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: fetchData,
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
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

                    final isLargeScreen =
                        ResponsiveWidget.isLargeScreen(context);
                    if (kDebugMode) {
                      print(
                          "${widget.key} rows not empty and not error. Rows length: ${appState.rows.value.length}, current page: ${appState.currentPage.value}, total pages: ${appState.totalPages.value}");
                    }
                    final banners =
                    ResponsiveWidget.isLargeScreen(context) ? appState.bannersWeb.value : appState.banners.value;
                    final isBannersError = ResponsiveWidget.isLargeScreen(context)
                        ? appState.isBannersWebError.value
                        : appState.isBannersError.value;

                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      floatingActionButton: AnimatedOpacity(
                        duration: const Duration(microseconds: 100),
                        opacity: appState.fabIsVisible.value ? 1 : 0,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 76.0),
                          child: FloatingActionButton(
                            onPressed: () {
                              if (appState.scrollController.value.hasClients) {
                                final position = appState.scrollController.value
                                    .position.minScrollExtent;
                                appState.scrollController.value.animateTo(
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
                      body: SafeArea(
                        child: SingleChildScrollView(
                          child: appState.banners.value.isEmpty
                              ? SizedBox()
                              : Column(
                            children: [
                              isBannersError ?
                         SizedBox(
                            height: MediaQuery.of(context).size.width,
                            child: Center(
                              child: ElevatedButton(
                                onPressed: fetchBanners,
                                style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                              textStyle: AppTypography.fontSizeChanges,
                                ),
                                child: const Text("Tap to retry", style: AppTypography.undefinedTextStyle,),
                              ),
                            ),
                          ): BannersCarousel(
                                banners: banners,
                              ) ,
                        Column(
                          children: [
                             Padding(
                              padding: const EdgeInsets.only(left: 16.0,right: 10,top: 15,bottom: 15),
                              child: Row(
                                children: [
                                   Text('Quick Access ',
                                    style: AppTypography.loginText.copyWith(color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,fontFamily: "Roboto"),
                                  )
                                ],
                              ),
                            ) ,
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0,right: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const TVGuidePage()),
                                          );
                                    },
                                    child: ClipRRect(
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(16.0)),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.12,
                                            width: MediaQuery.of(context).size.width * 0.43,
                                            child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: Stack(
                                                  alignment: Alignment.bottomCenter,
                                                  children: [
                                                    Image.asset("assets/images/home_images/tv_guide_tab.png"),
                                                  ],
                                                )
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  // height: MediaQuery.of(context).size.height * 0.2,
                                  // width: MediaQuery.of(context).size.height * 0.15,
                                  GestureDetector(
                                    onTap: () async {
                                      await fetchLiveNews();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const LiveNewsPage(

                                            )),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(16.0)),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.12,
                                            width: MediaQuery.of(context).size.width * 0.43,
                                            child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: Stack(
                                                  alignment: Alignment.bottomCenter,
                                                  children: [
                                                    Image.asset("assets/images/home_images/live_news_tab.png"),
                                                  ],
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8,),

                            appState.isTVGuideTap.value ?
                            Container(
                              height: MediaQuery.of(context).size.height / 1.4,
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0,right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                               TextSpan(
                                                text: 'Showing ',
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  height: 0.12,
                                                  letterSpacing: 0.15,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '(${appState.rows.value.length.toString()} Channels)',
                                                style: GoogleFonts.roboto(
                                                  color: Color(0xFFC7C7C7),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  height: 0.17,
                                                  letterSpacing: 0.15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        GestureDetector(
                                            onTap:(){
                                              showModalBottomSheet(context: context, builder:
                                                  (context) =>  StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState) {
                                                    return CustomBottomSheet(
                                                      content: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("Apply Filters",style: AppTypography.loginText.copyWith(color: Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 17,fontFamily: "Roboto"),),
                                                              IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.close)),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text("Content Type",style: AppTypography.loginText.copyWith(color: Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 17,fontFamily: "Roboto"),),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          _buildGenresChips(refreshCall:(){
                                                            setState(() {});
                                                          }),
                                                          const SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              Text("Language",style: AppTypography.loginText.copyWith(color: Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 17,fontFamily: "Roboto"),),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          _buildLanguageChips(refreshCall: (){setState((){});}),
                                                          const SizedBox(height: 10,),
                                                          Container(
                                                            width: double.infinity,
                                                            height: 35,
                                                            child: ElevatedButton(
                                                              onPressed: (){_applyFilters();
                                                              },
                                                              style: ButtonStyle(
                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12.0), // Set your desired border radius here
                                                                  ),),
                                                                backgroundColor: MaterialStateProperty
                                                                    .all<Color>(Colors.white,), // Set desired color
                                                              ),
                                                              child:  Text("Done",style: AppTypography.loginText.copyWith(color: Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 17,fontFamily: "Roboto"),),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                              ),
                                                  backgroundColor: Colors.transparent,
                                                  isScrollControlled: true,
                                                  barrierColor:const Color(0xff00021f).withOpacity(.5) );

                                            },
                                            child: SvgPicture.asset("assets/images/home_images/filter_icon_live_tv.svg")
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Expanded(
                                    child: ListView.builder(
                                      controller: appState.scrollController.value,
                                      itemCount: appState.rows.value.length + 2,
                                      itemBuilder: (context, index) {
                                        if (kDebugMode) {
                                          print("${widget.key} building row $index");
                                        }
                                        if (index == 0) {
                                          return _buildBanners();
                                        }

                                        // if (index >= rows.length + 1) {
                                        //   return const SizedBox(
                                        //     height: 75,
                                        //     child: Center(child: Loader()),
                                        //   );
                                        // }

                                        if (index >= appState.rows.value.length + 1) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (appState.loadingMore.value)
                                                const SizedBox(
                                                  height: 75,
                                                  child: Center(child: Loader()),
                                                ),
                                              const SizedBox(height: 75),
                                            ],
                                          );
                                        }
                                        // return MediaRowViewLiveTV(
                                        //   appState.rows.value[index - 1],
                                        //            addRows: addRows
                                        // );
                                        return isLargeScreen
                                            ? web_row_view.MediaRowView(
                                            appState.rows.value[index - 1],
                                            addRows: addRows)
                                            : mob_row_view.MediaRowView(
                                            appState.rows.value[index - 1],
                                            addRows: addRows);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ) :
                            Column(
                              children: appState.loadingPageRows.value.map((item) =>
                                  mob_row_view.MediaRowView(
                                    item,
                                    addRows: addRows,
                                    set: (data) {
                                      appState.loadingPageRows.value = data;
                                      MediaItemViewState.isFavoritePressed = null;
                                      setState(() {});
                                    },
                                  ),
                              ).toList(),
                            ),
                            //SizedBox(height:100),
                          ],
                        ),


                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              });
        });
  }

  Future<void> addRows(Future<MediaDetail> fetchRows, MediaRow afterRow) {
    return fetchRows.then((newRows) {
      setState(() {
        appState.rows.value.insertAll(
            appState.rows.value.indexOf(afterRow) + 1, newRows.mediaRows);
      });
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print("Failed to fetch additional rows: "
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

class GenreChipWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String? imagePath;
  final bool isSelected;

  const GenreChipWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.isSelected,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          // left: 5.0,
          right: 5.0,
          top: 5.0,
          bottom: 5.0,
        ),
    decoration: BoxDecoration(
          color: isSelected
              ? const Color(0XFF3158CE)
              : Colors.white.withOpacity(0),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          border: Border.all(
            color: Colors.white, // Border color
            width: 1, // Border width
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          const SizedBox(
                    width: 10,
                  ),
                  if (imagePath != null) ...[
                    Image(
                      image: AssetImage(imagePath!),
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      color: Color(0xFFC7C7C7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.25,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
          ],
        ),
      ),
    );
  }
}

class LanguageChipWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String? imagePath;
  final bool isSelected;

  const LanguageChipWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.isSelected,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        //margin: const EdgeInsets.all(5),
        padding: const  EdgeInsets.only(
        // left: 5.0,
        right: 5.0,
        top: 5.0,
        bottom: 5.0,
      ),
       // alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0XFF3158CE)
              : Colors.white.withOpacity(0),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          border: Border.all(
            color: Colors.white, // Border colors
            width: 1, // Border width
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: GoogleFonts.roboto(
                color: Color(0xFFC7C7C7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),

        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const SizedBox(
        //       width: 10,
        //     ),
        //     if (imagePath != null) ...[
        //       Image(
        //         image: AssetImage(imagePath!),
        //         height: 24,
        //         width: 24,
        //       ),
        //       const SizedBox(
        //         width: 8,
        //       ),
        //     ],
        //     Text(
        //       title,
        //       style: const TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w500,
        //           fontFamily: "Gilroy"),
        //     ),
        //     SizedBox(
        //       width: 10,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
