import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/redesign/live_tv/widgets/card_banners.dart';
import 'package:dor_companion/redesign/live_tv/widgets/category_grid.dart';
import 'package:dor_companion/redesign/live_tv/widgets/dor_top_drama_recommendation_view.dart';
import 'package:dor_companion/redesign/live_tv/widgets/favorite_recommented_channel.dart';
import 'package:dor_companion/redesign/live_tv/widgets/filter_by_language_tab_view.dart';
import 'package:dor_companion/redesign/live_tv/widgets/genre_list_helper.dart';
import 'package:dor_companion/widgets/appbar_custom.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/api/sensy_api.dart';
import '../../data/app_state.dart';
import '../../data/models/models.dart';
import '../../injection/injection.dart';
import '../../responsive.dart';
import '../../widgets/loader.dart';
import '../../widgets/media_detail/mdp_loaders.dart';

fetchFavTv() async {
  getIt<SensyApi>().fetchFav().then((value) async {
    for (var favoriteResult in value.result) {
      if (favoriteResult.itemType == 'channel') {
        for (var channelId in favoriteResult.itemIds) {
          await getIt<SensyApi>().fetchMediaDetail('channel', channelId.toString()).then((mediaDetail) {
            appState.favChannelData.value.add(mediaDetail);
            appState.favChannelData.notifyListeners();
          }).catchError((errorObj) {});
        }
      }
    }
  });
}

callInit() async {
  await fetchFavTv();
  // fetchFavChannelDetails();
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
        appState.scrollController.value.position.userScrollDirection == ScrollDirection.reverse;
  });
}

fetchBanners() {
  appState.isBannersError.value = false;
  appState.banners.value = [];

  final Trace trace = FirebasePerformance.instance.newTrace('fetch-banners-live-tv');
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
        debugPrint("Failed to fetch banners: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          debugPrint("Encountered unknown error of type ${errorObj.runtimeType}");
        }
    }
    appState.isBannersError.value = true;
  });
  trace.stop();
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
        debugPrint("Failed to fetch banners: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          debugPrint("Encountered unknown error of type ${errorObj.runtimeType}");
        }
    }
    appState.isBannersWebError.value = true;
  });
}

listenToPaginationScroll() {
  appState.scrollController.value.addListener(() {
    if (appState.scrollController.value.position.pixels ==
        appState.scrollController.value.position.maxScrollExtent) {
      debugPrint('Current page : ${appState.currentPage.value}, Called getUsers()');
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
          } else {
            mediaItem.isHomeScreen = false;
          }
        }
      }
      appState.loadingPageRows.notifyListeners();
      appState.banners.notifyListeners();
    }
    appState.loadingMore.value = false;
    appState.loadingPageRows.notifyListeners();
  }).catchError((errorObj) {
    switch (errorObj.runtimeType) {
      case DioException:
        final response = (errorObj as DioException).response;
        break;
      default:
        if (kDebugMode) {
          debugPrint("Encountered unknown error of type "
              "${errorObj.runtimeType} while fetching media detail");
          debugPrint("$errorObj");
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
    debugPrint('channels page :\n${channels},\nCalled getUsers()');

    appState.channels.value = channels;
    appState.filteredChannels.value = appState.channels.value;
    appState.totalPages.value = (appState.filteredChannels.value.length / 10).ceil();
    appState.isChannelsError.value = false;
  }).catchError((errorObj) {
    switch (errorObj.runtimeType) {
      case DioException:
        final response = (errorObj as DioException).response;
        debugPrint("Failed to fetch Channels: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          debugPrint("Encountered unknown error of type ${errorObj.runtimeType}");
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
        break;
      default:
        if (kDebugMode) {
          debugPrint("Encountered unknown error of type "
              "${errorObj} while fetching media detail");
          debugPrint("$errorObj");
        }
    }
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
    appState.languages.value.list.insert(0, Language(title: 'All', isSelected: true));
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
        debugPrint("Failed to fetch Genres: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          debugPrint("Encountered unknown error of type ${errorObj.runtimeType}");
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
     GenreListHelper.updateGenreListWithImages();
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
        debugPrint("Failed to fetch Genres: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          debugPrint("Encountered unknown error of type ${errorObj.runtimeType}");
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
  final Trace trace = FirebasePerformance.instance.newTrace('fetch-channel-schedule-live-tv');
  trace.start();
  appState.currentPage.value = 1;
  final channelIdsToFetch = appState.filteredChannels.value
      .sublist((appState.currentPage.value - 1) * appState.filteredChannels.value.length,
          appState.currentPage.value * appState.filteredChannels.value.length)
      .map((channel) => channel.id)
      .join(',');
  debugPrint('channelIdsToFetch::: $channelIdsToFetch');
  final mediaDetailFetch = getIt<SensyApi>().fetchChannelsSchedule(channelIdsToFetch);
  return mediaDetailFetch.then((mediaDetail) {
    if (mediaDetail.mediaRows.isEmpty) {
      appState.isError.value = true;
      return;
    }
    appState.isError.value = false;
    appState.currentPage.value++;
    for (MediaRow row in mediaDetail.mediaRows) {
      if (row.mediaItems.isNotEmpty) {
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
            debugPrint("----------------------------------");
            debugPrint(mediaItem.video);
            debugPrint("----------------------------------");
            mediaItem.isLiveTVItem = true;
            mediaItem.source = channel.source;
          }
          appState.rows.value.add(row);
        }
      }
      appState.rows.notifyListeners();
      appState.banners.notifyListeners();
      appState.channels.notifyListeners();
      appState.languages.notifyListeners();
      appState.filteredChannels.notifyListeners();
      appState.genres.notifyListeners();
    }
    Set<String> uniqueGenres = {}; //
    for (int i = 0; i < appState.channelListForGenre.value.length; i++) {
      uniqueGenres.add(appState.channelListForGenre.value.elementAt(i).genre);
    }
    appState.genres.value.list.clear();
    for (var genreTitle in uniqueGenres) {
      appState.genres.value.list.add(Genre(title: genreTitle));
    }
    appState.genres.value.list.insert(0, Genre(title: "All", isSelected: true));
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
        debugPrint("Failed to fetch page: ${response?.statusCode}");
        break;
      default:
        if (kDebugMode) {
          debugPrint("Encountered unknown error of type "
              "${errorObj.runtimeType} while fetching media detail");
          debugPrint("$errorObj");
        }
    }
    appState.isError.value = true;
  });
}

class LiveTvScreenTab extends StatefulWidget {
  LiveTvScreenTab({Key? key, this.itemType, this.itemId}) : super(key: key);

  late String? itemType;
  late String? itemId;

  @override
  State<LiveTvScreenTab> createState() => _LiveTvScreenTabState();
}

class _LiveTvScreenTabState extends State<LiveTvScreenTab> with AutomaticKeepAliveClientMixin {
  AnalyticsEvent eventCall = AnalyticsEvent();

  @override
  void initState() {
    debugPrint("-----------> call live tv-------");
    callInit();
    super.initState();
  }

  _applyFilters() {
    Navigator.of(context).pop();
    List<String> _selectedGenres =
        appState.genres.value.list.where((genre) => genre.isSelected).map((genre) => genre.title).toList();
    bool isAllGenreSelected = _selectedGenres.first == 'All';
    List<String> _selectedLanguages = appState.languages.value.list
        .where((language) => language.isSelected)
        .map((language) => language.title)
        .toList();
    bool isAllLanguageSelected = _selectedLanguages.first == 'All';
    appState.filteredChannels.value = appState.channels.value
        .where((channel) =>
            (isAllGenreSelected || _selectedGenres.contains(channel.genre)) &&
            (isAllLanguageSelected || _selectedLanguages.contains(channel.language)))
        .toList();

    appState.totalPages.value = (appState.filteredChannels.value.length / 10).ceil();
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
        debugPrint("returning banner loader");
      }
      return SizedBox(height: MediaQuery.of(context).size.width, child: const Center(child: Loader()));
    }

    return const Column(
      children: [],
    );
  }

  Column _buildLanguageChips({required Function() refreshCall}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
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
                isSelected: languages.isSelected);
          }).toList()),
      const SizedBox(height: 20)
    ]);
  }

  _buildGenresChips({required Function() refreshCall}) {
    return Column(children: [
      const SizedBox(height: 10),
      Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: appState.genres.value.list.map((genre) {
            return GenreChipWidget(
                onTap: () {
                  eventCall.filterEventLiveTv('live_tv_screen');
                  setState(() {
                    if (appState.genres.value.list.indexOf(genre) == 0) {
                      if (genre.isSelected) return;
                      genre.isSelected = !genre.isSelected;
                      if (genre.isSelected) {
                        appState.genres.value.list.sublist(1).forEach((genre) => genre.isSelected = false);
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
                isSelected: genre.isSelected);
          }).toList()),
      const SizedBox(height: 4)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    for (var data in appState.loadingPageRows.value) {
      log('media row response -- ${data.toJson()}');
    }
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
                          !appState.isError.value &&
                          !appState.loadingMore.value) {
                        if (kDebugMode) {
                          debugPrint("${widget.key} rows empty and not error");
                        }
                        return const PerformanceTrackedWidget(
                            widgetName: 'live-tv-view',
                            child: Center(
                                child: Padding(
                                    padding: EdgeInsets.only(top: 50.0),
                                    child: SingleChildScrollView(child: MDPBodyLoader()))));
                      }
                      if (appState.isError.value) {
                        if (kDebugMode) {
                          debugPrint("${widget.key} is error");
                        }
                        return SizedBox(
                            height: 200,
                            child: Center(
                                child: ElevatedButton(
                                    onPressed: fetchData,
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                                      textStyle: AppTypography.fontSizeChanges,
                                    ),
                                    child: const Text("Tap to retry",
                                        style: AppTypography.undefinedTextStyle))));
                      }

                      final isLargeScreen = ResponsiveWidget.isLargeScreen(context);
                      if (kDebugMode) {
                        debugPrint(
                            "${widget.key} rows not empty and not error. Rows length: ${appState.rows.value.length}, current page: ${appState.currentPage.value}, total pages: ${appState.totalPages.value}");
                      }
                      List<StandardPromotion> banners = ResponsiveWidget.isLargeScreen(context)
                          ? appState.bannersWeb.value
                          : appState.banners.value;
                      final isBannersError = ResponsiveWidget.isLargeScreen(context)
                          ? appState.isBannersWebError.value
                          : appState.isBannersError.value;

                      return Scaffold(
                          backgroundColor: Colors.black.withOpacity(0.800000011920929),
                          extendBodyBehindAppBar: true,
                          appBar: const LogoAppBar(showLogo: false, pageText: 'Live TV'),
                          body: SafeArea(
                              child: SingleChildScrollView(
                                  child: appState.banners.value.isEmpty
                                      ? const SizedBox()
                                      : Column(children: [
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
                                                  bannerList: banners,
                                                  isShowPlayButton: true,
                                                  isShowNotifyButton: false,
                                                  isShowPlayWithWatchListButton: false,
                                                  onCardPressed: (index) {
                                                    banners[index].action.executeAction(context);
                                                    eventCall.bannerClickEvent('home_screen');
                                                  }),
                                          Container(
                                              color: Colors.black.withOpacity(0.800000011920929),
                                              child: const Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TypesOfLiveChannelGridScreen(),
                                                    DorTopDramaRecommendationView(),
                                                    FilterByLanguageTabView(),
                                                    FavoriteRecommendedChannel()
                                                  ])),
                                          // Column(children: [
                                          //   Padding(
                                          //       padding: const EdgeInsets.only(
                                          //           left: 16.0, right: 10, top: 15, bottom: 15),
                                          //       child: Row(children: [
                                          //         Text('Quick Access ',
                                          //             style: AppTypography.loginText.copyWith(
                                          //                 color: Colors.white,
                                          //                 fontWeight: FontWeight.w500,
                                          //                 fontSize: 17,
                                          //                 fontFamily: "Roboto"))
                                          //       ])),
                                          //   Padding(
                                          //       padding: const EdgeInsets.only(left: 16.0, right: 10),
                                          //       child: Row(children: [
                                          //         GestureDetector(
                                          //             onTap: () => Navigator.push(
                                          //                 context,
                                          //                 MaterialPageRoute(
                                          //                     builder: (context) => const TVGuidePage())),
                                          //             child: ClipRRect(
                                          //                 borderRadius: const BorderRadius.all(
                                          //                     Radius.circular(16.0)),
                                          //                 child: Stack(children: [
                                          //                   SizedBox(
                                          //                       height:
                                          //                           MediaQuery.of(context).size.height *
                                          //                               0.12,
                                          //                       width: MediaQuery.of(context).size.width *
                                          //                           0.43,
                                          //                       child: FittedBox(
                                          //                           fit: BoxFit.cover,
                                          //                           child: Stack(
                                          //                               alignment: Alignment.bottomCenter,
                                          //                               children: [
                                          //                                 Image.asset(
                                          //                                     "assets/images/home_images/tv_guide_tab.png")
                                          //                               ])))
                                          //                 ]))),
                                          //         const SizedBox(width: 10),
                                          //         GestureDetector(
                                          //             onTap: () async {
                                          //               await fetchLiveNews();
                                          //               if (context.mounted) {
                                          //                 Navigator.push(
                                          //                   context,
                                          //                   MaterialPageRoute(
                                          //                       builder: (context) =>
                                          //                           const LiveNewsPage()),
                                          //                 );
                                          //               }
                                          //             },
                                          //             child: ClipRRect(
                                          //                 borderRadius: const BorderRadius.all(
                                          //                     Radius.circular(16.0)),
                                          //                 child: Stack(children: [
                                          //                   SizedBox(
                                          //                       height:
                                          //                           MediaQuery.of(context).size.height *
                                          //                               0.12,
                                          //                       width: MediaQuery.of(context).size.width *
                                          //                           0.43,
                                          //                       child: FittedBox(
                                          //                           fit: BoxFit.cover,
                                          //                           child: Stack(
                                          //                               alignment: Alignment.bottomCenter,
                                          //                               children: [
                                          //                                 Image.asset(
                                          //                                     "assets/images/home_images/live_news_tab.png")
                                          //                               ])))
                                          //                 ])))
                                          //       ])),
                                          //   const SizedBox(height: 8),
                                          //   appState.isTVGuideTap.value
                                          //       ? SizedBox(
                                          //           height: MediaQuery.of(context).size.height / 1.4,
                                          //           child: Column(
                                          //               mainAxisAlignment: MainAxisAlignment.start,
                                          //               children: [
                                          //                 Padding(
                                          //                     padding: const EdgeInsets.only(
                                          //                         left: 16.0, right: 10),
                                          //                     child: Row(
                                          //                         mainAxisAlignment:
                                          //                             MainAxisAlignment.spaceBetween,
                                          //                         children: [
                                          //                           Text.rich(
                                          //                               TextSpan(children: [
                                          //                                 TextSpan(
                                          //                                     text: 'Showing ',
                                          //                                     style: GoogleFonts.roboto(
                                          //                                         color: Colors.white,
                                          //                                         fontSize: 14,
                                          //                                         fontWeight:
                                          //                                             FontWeight.w500,
                                          //                                         height: 0.12,
                                          //                                         letterSpacing: 0.15)),
                                          //                                 TextSpan(
                                          //                                     text:
                                          //                                         '(${appState.rows.value.length.toString()} Channels)',
                                          //                                     style: GoogleFonts.roboto(
                                          //                                         color: const Color(
                                          //                                             0xFFC7C7C7),
                                          //                                         fontSize: 12,
                                          //                                         fontWeight:
                                          //                                             FontWeight.w400,
                                          //                                         height: 0.17,
                                          //                                         letterSpacing: 0.15))
                                          //                               ]),
                                          //                               textAlign: TextAlign.center),
                                          //                           GestureDetector(
                                          //                               onTap: () {
                                          //                                 showModalBottomSheet(
                                          //                                     context: context,
                                          //                                     builder: (context) =>
                                          //                                         StatefulBuilder(builder:
                                          //                                             (BuildContext
                                          //                                                     context,
                                          //                                                 StateSetter
                                          //                                                     setState) {
                                          //                                           return CustomBottomSheet(
                                          //                                               content: Column(
                                          //                                                   children: [
                                          //                                                 Row(
                                          //                                                     mainAxisAlignment:
                                          //                                                         MainAxisAlignment
                                          //                                                             .spaceBetween,
                                          //                                                     children: [
                                          //                                                       Text(
                                          //                                                           "Apply Filters",
                                          //                                                           style: AppTypography.loginText.copyWith(
                                          //                                                               color: Colors.white,
                                          //                                                               fontWeight: FontWeight.w500,
                                          //                                                               fontSize: 17,
                                          //                                                               fontFamily: "Roboto")),
                                          //                                                       IconButton(
                                          //                                                           onPressed: () => Navigator.of(context)
                                          //                                                               .pop(),
                                          //                                                           icon:
                                          //                                                               const Icon(Icons.close))
                                          //                                                     ]),
                                          //                                                 const SizedBox(
                                          //                                                     height: 10),
                                          //                                                 Row(
                                          //                                                     mainAxisAlignment:
                                          //                                                         MainAxisAlignment
                                          //                                                             .start,
                                          //                                                     children: [
                                          //                                                       Text(
                                          //                                                           "Content Type",
                                          //                                                           style: AppTypography.loginText.copyWith(
                                          //                                                               color: Colors.white,
                                          //                                                               fontWeight: FontWeight.w500,
                                          //                                                               fontSize: 17,
                                          //                                                               fontFamily: "Roboto"))
                                          //                                                     ]),
                                          //                                                 const SizedBox(
                                          //                                                     height: 10),
                                          //                                                 _buildGenresChips(
                                          //                                                     refreshCall: () =>
                                          //                                                         setState(
                                          //                                                             () {})),
                                          //                                                 const SizedBox(
                                          //                                                     height: 10),
                                          //                                                 Row(children: [
                                          //                                                   Text(
                                          //                                                       "Language",
                                          //                                                       style: AppTypography.loginText.copyWith(
                                          //                                                           color: Colors
                                          //                                                               .white,
                                          //                                                           fontWeight: FontWeight
                                          //                                                               .w500,
                                          //                                                           fontSize:
                                          //                                                               17,
                                          //                                                           fontFamily:
                                          //                                                               "Roboto"))
                                          //                                                 ]),
                                          //                                                 const SizedBox(
                                          //                                                   height: 10,
                                          //                                                 ),
                                          //                                                 _buildLanguageChips(
                                          //                                                     refreshCall: () =>
                                          //                                                         setState(
                                          //                                                             () {})),
                                          //                                                 const SizedBox(
                                          //                                                     height: 10),
                                          //                                                 SizedBox(
                                          //                                                     width: double
                                          //                                                         .infinity,
                                          //                                                     height: 35,
                                          //                                                     child: ElevatedButton(
                                          //                                                         onPressed:
                                          //                                                             () =>
                                          //                                                                 _applyFilters(),
                                          //                                                         style: ButtonStyle(
                                          //                                                             shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          //                                                                 borderRadius: BorderRadius.circular(
                                          //                                                                     12.0))),
                                          //                                                             backgroundColor: WidgetStateProperty.all<Color>(Colors
                                          //                                                                 .white)),
                                          //                                                         child: Text(
                                          //                                                             "Done",
                                          //                                                             style: AppTypography.loginText.copyWith(
                                          //                                                                 color: Colors.white,
                                          //                                                                 fontWeight: FontWeight.w500,
                                          //                                                                 fontSize: 17,
                                          //                                                                 fontFamily: "Roboto"))))
                                          //                                               ]));
                                          //                                         }),
                                          //                                     backgroundColor:
                                          //                                         Colors.transparent,
                                          //                                     isScrollControlled: true,
                                          //                                     barrierColor:
                                          //                                         const Color(0xff00021f)
                                          //                                             .withOpacity(.5));
                                          //                               },
                                          //                               child: SvgPicture.asset(
                                          //                                   "assets/images/home_images/filter_icon_live_tv.svg"))
                                          //                         ])),
                                          //                 const SizedBox(height: 5),
                                          //                 Expanded(
                                          //                     child: ListView.builder(
                                          //                         controller:
                                          //                             appState.scrollController.value,
                                          //                         itemCount:
                                          //                             appState.rows.value.length + 2,
                                          //                         itemBuilder: (context, index) {
                                          //                           if (kDebugMode) {
                                          //                             print(
                                          //                                 "${widget.key} building row $index");
                                          //                           }
                                          //                           if (index == 0) {
                                          //                             return _buildBanners();
                                          //                           }
                                          //
                                          //                           if (index >=
                                          //                               appState.rows.value.length + 1) {
                                          //                             return Column(
                                          //                                 mainAxisSize: MainAxisSize.min,
                                          //                                 children: [
                                          //                                   if (appState
                                          //                                       .loadingMore.value)
                                          //                                     const SizedBox(
                                          //                                         height: 75,
                                          //                                         child: Center(
                                          //                                             child: Loader())),
                                          //                                   const SizedBox(height: 75)
                                          //                                 ]);
                                          //                           }
                                          //                           return isLargeScreen
                                          //                               ? web_row_view.MediaRowView(
                                          //                                   appState
                                          //                                       .rows.value[index - 1],
                                          //                                   addRows: addRows)
                                          //                               : mob_row_view.MediaRowView(
                                          //                                   appState
                                          //                                       .rows.value[index - 1],
                                          //                                   addRows: addRows);
                                          //                         }))
                                          //               ]))
                                          //       : Column(
                                          //           children: appState.loadingPageRows.value
                                          //               .map((item) => mob_row_view.MediaRowView(item,
                                          //                       addRows: addRows, set: (data) {
                                          //                     appState.loadingPageRows.value = data;
                                          //                     MediaItemViewState.isFavoritePressed = null;
                                          //                     setState(() {});
                                          //                   }))
                                          //               .toList())
                                          // ])
                                        ]))));
                    });
              });
        });
  }

  Future<void> addRows(Future<MediaDetail> fetchRows, MediaRow afterRow) {
    return fetchRows.then((newRows) {
      setState(() {
        appState.rows.value.insertAll(appState.rows.value.indexOf(afterRow) + 1, newRows.mediaRows);
      });
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          debugPrint("Failed to fetch additional rows: "
              "${response?.statusCode}");
      }
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

  const GenreChipWidget(
      {super.key, required this.onTap, required this.title, required this.isSelected, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.only(right: 5.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
                color: isSelected ? const Color(0XFF3158CE) : Colors.white.withOpacity(0),
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                border: Border.all(color: Colors.white, width: 1)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(width: 10),
              if (imagePath != null) ...[
                Image(image: AssetImage(imagePath!), height: 24, width: 24),
                const SizedBox(width: 8)
              ],
              Text(title,
                  style: GoogleFonts.roboto(
                      color: const Color(0xFFC7C7C7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.25)),
              const SizedBox(width: 10)
            ])));
  }
}

class LanguageChipWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String? imagePath;
  final bool isSelected;

  const LanguageChipWidget(
      {super.key, required this.onTap, required this.title, required this.isSelected, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.only(right: 5.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
                color: isSelected ? const Color(0XFF3158CE) : Colors.white.withOpacity(0),
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                border: Border.all(color: Colors.white, width: 1)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(width: 10),
              Text(title,
                  style: GoogleFonts.roboto(
                      color: const Color(0xFFC7C7C7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.25)),
              const SizedBox(width: 10)
            ])));
  }
}
