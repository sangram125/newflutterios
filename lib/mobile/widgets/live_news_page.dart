import 'dart:async';

import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/search_suggestions.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/search/search_controller/search_controller.dart';
import 'package:dor_companion/mobile/search/search_view.dart';
import 'package:dor_companion/mobile/widgets/live_news_row_view.dart';
import 'package:dor_companion/utils.dart';
import 'package:dor_companion/widgets/appbar.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:dor_companion/widgets/themed_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../../../widgets/custom_search_widget.dart' as se;
import '../../data/models/constants.dart';

class LiveNewsPage extends StatefulWidget {
  const LiveNewsPage({
    super.key,
  });

  @override
  State<LiveNewsPage> createState() => LiveNewsPageState();
}

late VideoPlayerController _videoPlayerController;

class LiveNewsPageState extends State<LiveNewsPage> {
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
     _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    appState.isLiveNewsTileTapped.value = false;
    appState.lastSelectedChannel.value = 0;
    appState.lastSelected.value = 0;
    super.dispose();
  }
  Timer? _timer;
  void _initializeVideoPlayer() async {
    _timer = await Timer(const Duration(seconds: 2), () {
      _videoPlayerController = VideoPlayerController.network(
        appState
            .liveNewsRow.value.cluster
            .elementAt(appState.lastSelected.value)
            .channels
            .elementAt(appState.lastSelectedChannel.value)
            .process_stream,
      );
      _videoPlayerController.addListener(() {
        appState.isLiveNewsTileTapped
            .value =
            _videoPlayerController.value.isPlaying;
        _isVideoPlaying = _videoPlayerController.value.isPlaying;
      });
      // _videoPlayerController.initialize().then((_) {
      //
      //   appState.isLiveNewsTileTapped
      //       .value =
      //       _videoPlayerController.value.isPlaying;
      //  // setState(() {
      //     // Update the UI to reflect the video is initialized
      //     _isVideoPlaying = _videoPlayerController.value.isPlaying;
      //  // });
      //
      //
      // });
      setState(() {
      });
      _videoPlayerController.play();
    });
  }

   _changeVideo(String newUrl) {
   _videoPlayerController.pause();
   _timer = Timer(const Duration(seconds: 2), () {
     _videoPlayerController = VideoPlayerController.network(newUrl);
     _videoPlayerController.addListener(() {
       // setState(() {
       appState.isLiveNewsTileTapped
           .value =
           _videoPlayerController.value.isPlaying;
       _isVideoPlaying = _videoPlayerController.value.isPlaying;
       //});
     });
     // _videoPlayerController.initialize().then((_) {
     //   // setState(() {
     //   appState.isLiveNewsTileTapped
     //       .value =
     //       _videoPlayerController.value.isPlaying;
     //   _isVideoPlaying = _videoPlayerController.value.isPlaying;
     //   //  });
     //   setState(() {});
     //   _videoPlayerController.play();
     //  // setState(() {});
     // }).onError((error, stackTrace) {
     //   print("erro video player ${error.toString()}");
     //   showVanillaToast(error.toString());
     // });
     _videoPlayerController.play();
      setState(() {});
   });

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: appState.liveNewsRow.value.cluster.isEmpty
            ? Text("Not Available")
            : PerformanceTrackedWidget(
                widgetName: 'live-news-view',
                child: GradientBackground(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: [
                              appState.isLiveNewsTileTapped.value == false
                                  ? GestureDetector(
                                      onTap: () {
                                        // appState.isLiveNewsTileTapped
                                        //         .value =
                                        //     true;
                                        _changeVideo(appState
                                            .liveNewsRow.value.cluster
                                            .elementAt(appState.lastSelected.value)
                                            .channels
                                            .elementAt(appState.lastSelectedChannel.value)
                                            .process_stream);
                                        print("value of is playing in image ${appState
                                            .liveNewsRow.value.cluster
                                            .elementAt(appState.lastSelected.value)
                                            .channels
                                            .elementAt(appState.lastSelectedChannel.value)
                                            .process_stream}");
                                        // _videoPlayerController = VideoPlayerController.network(appState
                                        //     .liveNewsRow.value.cluster
                                        //     .elementAt(appState.lastSelected.value)
                                        //     .channels
                                        //     .elementAt(appState.lastSelectedChannel.value)
                                        //     .process_stream);
                                        //setState(() {});
                                      },
                                      child: Image.network(
                                        appState.liveNewsRow.value.cluster
                                            .elementAt(
                                                appState.lastSelected.value)
                                            .channels
                                            .elementAt(appState
                                                .lastSelectedChannel.value)
                                            .channel_logo,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        fit: BoxFit.fill,
                                      ))
                                  : appState.isLiveNewsTileTapped.value == true ? ThemedVideoPlayer(
                                      videoPlayerController:
                                          _videoPlayerController,
                                      showControlsOnInitialize: true,
                                      allowFullscreen: true,
                                    ) : Loader(),
                              appState.isLiveNewsTileTapped.value == false ? Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.8,
                                child: ListTile(
                                  leading: Image.network(appState
                                      .liveNewsRow.value.cluster
                                      .elementAt(
                                          appState.lastSelected.value)
                                      .channels
                                      .elementAt(appState
                                          .lastSelectedChannel.value)
                                      .channel_logo),
                                  title: SizedBox(
                                      width: MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.2,
                                      child: Text(
                                        appState.liveNewsRow.value.cluster
                                            .elementAt(
                                                appState.lastSelected.value)
                                            .channels
                                            .elementAt(appState
                                                .lastSelectedChannel.value)
                                            .topic,
                                        style: AppTypography.loginText.copyWith(color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,fontFamily: "Roboto"),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  subtitle: Text(
                                      "${appState.liveNewsRow.value.cluster.elementAt(appState.lastSelected.value).channels.elementAt(appState.lastSelectedChannel.value).channel_name} • ${appState.liveNewsRow.value.cluster.elementAt(appState.lastSelected.value).channels.elementAt(appState.lastSelectedChannel.value).language}",
                                      style: GoogleFonts.roboto(
                                          color: Colors.black)),
                                ),
                              ) : SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: appState.liveNewsRow.value.cluster.map((e) {
                              final index =
                                  appState.liveNewsRow.value.cluster.indexOf(e);
                              return LiveNewsRowView(
                                  channel: appState.liveNewsRow.value.cluster
                                      .elementAt(index),
                                  clusterIndex: index,
                                  channelSelectedCall: () async {
                                    print("change url ${appState
                                        .liveNewsRow.value.cluster
                                        .elementAt(appState.lastSelected.value)
                                        .channels
                                        .elementAt(appState.lastSelectedChannel.value)
                                        .process_stream}");
                                    await _changeVideo(appState
                                        .liveNewsRow.value.cluster
                                        .elementAt(appState.lastSelected.value)
                                        .channels
                                        .elementAt(appState.lastSelectedChannel.value)
                                        .process_stream);
                                   setState(() {});
                              },);
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _buildAppBar(BuildContext context) => PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
          child: Container(
            height: 50.0,
            width: double.maxFinite,

            decoration:BoxDecoration(gradient:const LinearGradient(
              colors: [Color(0xFF0E1466), Color(0x490B0F47)],
            ),),
            child: AppBar(
              centerTitle: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: SvgPicture.asset(
                  "assets/images/home_images/arrow_right_alt.svg",
                  width: 41.w,
                  height: 41.h,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {
                      final searchController =
                      Get.put(SearchViewController());
                      appState.eventCall.searchEvent('app_bar');
                      se.showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(
                          sensyApi: getIt<SensyApi>(),
                          searchSuggestion: getIt<SearchSuggestions>(),
                        ),
                      );
                      searchController.fetchData("tab", "find");
                      searchController.fetchData(
                          "row", "search-trending");
                    },
                    icon: SvgPicture.asset(
                      "assets/images/appbar_images/search.svg",
                      width: 41.w,
                      height: 41.h,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ],
              // bottom: PreferredSize(
              //   preferredSize: const Size.fromHeight(35.0),
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         IconButton(
              //           onPressed: () {
              //             context.pop();
              //           },
              //           icon: SvgPicture.asset(
              //             "assets/images/home_images/arrow_right_alt.svg",
              //             width: 41.w,
              //             height: 41.h,
              //             alignment: Alignment.bottomCenter,
              //           ),
              //         ),
              //         IconButton(
              //           onPressed: () {
              //             final searchController =
              //             Get.put(SearchViewController());
              //             appState.eventCall.searchEvent('app_bar');
              //             se.showSearch(
              //               context: context,
              //               delegate: CustomSearchDelegate(
              //                 sensyApi: getIt<SensyApi>(),
              //                 searchSuggestion: getIt<SearchSuggestions>(),
              //               ),
              //             );
              //             searchController.fetchData("tab", "find");
              //             searchController.fetchData(
              //                 "row", "search-trending");
              //           },
              //           icon: SvgPicture.asset(
              //             "assets/images/appbar_images/search.svg",
              //             width: 41.w,
              //             height: 41.h,
              //             alignment: Alignment.center,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ),
          ),

      );
  // @override
  // void dispose() {
  //   appState.isLiveNewsTileTapped.value = false;
  //   _videoPlayerController.dispose();
  //   appState.lastSelectedChannel.value = 0;
  //   appState.lastSelected.value = 0;
  // }
}
