import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/home_page_provider.dart';
import 'package:dor_companion/data/models/user_interests.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../data/api/sensy_api.dart';
import '../../../data/models/models.dart';

import '../../../injection/injection.dart';
import '../../../sdk_action_manager.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/media_detail/media_rows_view.dart';

class MediaItemView extends StatefulWidget {
   MediaItemView(this.mediaItem, this.mediaRow, this.addRows, this.index,
      {Key? key, this.onAppSeriesLoaded, this.isLoading, this.unSelected, this.isEdit,this.set,
        this.isTopicScreen=false,
        // this.istoIcon=false
      })
      : super(key: key);
   final MediaItem mediaItem;
    MediaRow mediaRow;
   final AddRows? addRows;
  final int? index;
  final void Function(List<MediaItem>)? onAppSeriesLoaded;
   final void Function(List<MediaRow>)? set;
  final void Function(bool)? isLoading;
  final void Function(int)? unSelected;
  final bool isTopicScreen;
  // final bool istoIcon;
   bool? isEdit;
  @override
  State<MediaItemView> createState() => MediaItemViewState();
}

class MediaItemViewState extends State<MediaItemView> {
  bool isLoading = false;
  bool favoritedThisSession = false;
  String selectedItemid = "";
  int selectedIndex = 0;
  List<MediaRow> _rows = [];
  List<MediaItem> mediaItems = [];
  static int? isFavoritePressed ;
  double _progress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateProgress();
  }

  void _updateProgress() {
    // Assuming the show is playing, update the progress bar
    if (widget.mediaItem.isShowPlayingLive()) {
      setState(() {
        _progress = widget.mediaItem.showProgress;
      });
    }
    // Schedule the next update
    Timer.periodic(const Duration(minutes: 1), (timer) => _updateProgress());
  }
  AnalyticsEvent eventCall = AnalyticsEvent();
  @override
  Widget build(BuildContext context) {
    debugPrint('Video  : ${widget.mediaRow.contentType}');

    if (widget.mediaRow.contentType == 116 && widget.index == 2) {
      if (HomePageProvider.gesture_detector == false) {
        widget.mediaItem.selected = true;
        selectedIndex = 2;
      }
    } else {
      if (HomePageProvider.gesture_detector == false) {
        widget.mediaItem.selected = false;
        selectedIndex = widget.index!;
      }
    }

    if (widget.mediaRow.displayConfig.rowType !=
        DisplayConfig.rowTypePersonalize) {
      return GestureDetector(
        onTap: () {
          if (kDebugMode) {
            print("movie click");
          }
          eventCall.movieClickEvent('home_screen');
          HomePageProvider.gesture_detector = true;

          ///* handling live TV action
          widget.unSelected?.call(widget.index!);
          if (widget.mediaItem.selected == true) {
            widget.mediaItem.selected = false;
          } else if (widget.mediaItem.selected == false) {
            widget.mediaItem.selected = true;
          }
          debugPrint('HLS feed_hls : ${widget.mediaItem.selected}');

          /// If schedule is not null, means it is LiveTV video
          if (widget.mediaItem.schedule != null &&
              !widget.mediaItem.isShowPlayingLive() &&
              widget.mediaItem.actions.length > 1) {
            debugPrint('Video Link : ${widget.mediaItem.video}');
            widget.mediaItem.actions[1].chatAction.executeAction(
              context,
              mediaItem: widget.mediaItem,
            );
            return;
          }
          if (widget.mediaItem.actions.isNotEmpty) {
            if (kDebugMode) {
              print("seleted $selectedIndex");
            }

            if (selectedItemid == widget.mediaItem.itemID) {
              selectedItemid = "";
            }
            if (widget.mediaRow.contentType == 116) {
              eventCall.exploreOTTEvent('home_screen');
              //       if (selectedIndex.isNotEmpty) {
              //        selectedIndex = "";
              // //          setState(() {

              // //          });
              //     } else {

              //          selectedIndex = widget.index!.toString();
              //            print("seleted two $selectedIndex");
              //          setState(() {

              //          });
              //     }
              appState.buttonCarouselController.value.animateToPage(widget.index ??  appState.indexOfFetchingData.value,duration: Duration(milliseconds: 300), curve: Curves.linear);
              selectedItemid = widget.mediaItem.package;
              //fetchData("app_lite", selectedItemid).then((value) {});
            } else {
              widget.mediaItem.actions[0].chatAction.executeAction(
                context,
                mediaItem: widget.mediaItem,
              );
            }
            // selectedIndex = widget.index!;
            setState(() {});

            debugPrint('Video  : ${widget.mediaItem.itemID}');
            // widget.mediaItem.actions[0].chatAction.executeAction(
            //   context,
            //   mediaItem: widget.mediaItem,
            // );
          }
        },
        child: getMediaItemWidget(context, widget.index!),
      );
    }

    return GestureDetector(
      onTap: () async {
        if (widget.mediaItem.actions.isEmpty) {
          return;
        }

        setState(() {
          isLoading = true;
        });

        List<String> typeAndID = ChatAction.getItemTypeAndItemID(
            widget.mediaItem.actions[0].chatAction);
        String itemType = typeAndID[0];
        String itemId = typeAndID[1];

        await widget.mediaItem.actions[0].chatAction.executeAction(context);

        final AddRows? addRows = widget.addRows;
        if (addRows == null ||
            !getIt<UserInterestsChangeNotifier>()
                .isFavorite(itemType, itemId) ||
            favoritedThisSession) {
          setState(() => isLoading = false);
          return;
        }

        addRows(getIt<SensyApi>().fetchSuggestedRows(itemType, itemId),
                widget.mediaRow)
            .then((value) {
              favoritedThisSession = true;
            })
            .catchError((_) => null)
            .whenComplete(() => setState(() => isLoading = false));
      },
      child:Stack(children: [
        getMediaItemWidget(context, widget.index!),
        widget.isTopicScreen==true &&
            MediaRowContentTypes.peopleTypes.contains(widget.mediaRow.contentType)
            ?const SizedBox(): Positioned.fill(
          top: 8,
          right: 8,
          child: Consumer<UserInterestsChangeNotifier>(
            builder: ((context, interests, _) {
              return Align(
                alignment: Alignment.topRight,
                child: isLoading
                    ? const Loader()
                    : interests.isFavorite(
                        widget.mediaItem.itemType,
                        ChatAction.getActionFormattedItemId(
                          widget.mediaItem.itemType,
                          widget.mediaItem.itemID,
                        ),
                      )
                        ? widget.isTopicScreen==true?
                    SvgPicture.asset('assets/icons/selected.svg',
                      height:24,
                      width: 24,)
                    :const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 28,
                          )
                        : widget.isTopicScreen==true?
                    SvgPicture.asset('assets/icons/unselected.svg',
                      height:24 ,
                      width: 24,)
                    :Icon(
                            Icons.favorite_border,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: 28,
                          ),
              );
            }),
          ),
        ),
      ]),
    );
  }

  Widget getMediaItemWidget(BuildContext context, int index) {
    print("size :${MediaRowContentTypes.peopleTypes.contains(widget.mediaRow.contentType)}");
    final width =
        MediaRowContentTypes.peopleTypes.contains(widget.mediaRow.contentType)
            ? widget.isTopicScreen==true?100.0:widget.mediaRow.displayConfig.width
            : widget.isTopicScreen==true?widget.mediaRow.displayConfig.width:
        widget.mediaRow.contentType==116?widget.mediaRow.displayConfig.width*2.3:
        widget.mediaRow.displayConfig.width*1.5 ;
    final height =
        MediaRowContentTypes.peopleTypes.contains(widget.mediaRow.contentType)
            ? widget.isTopicScreen==true?100.0: widget.mediaRow.displayConfig.height
            : widget.isTopicScreen==true?widget.mediaRow.displayConfig.height:
        widget.mediaRow.contentType==116?widget.mediaRow.displayConfig.height*1.3:
        widget.mediaRow.displayConfig.height*1.3;
    final watchOnAction = getFirstWatchOnActionOrNull(widget.mediaItem.actions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration:widget.mediaItem.isLiveTVItem == true ? BoxDecoration(
            border: Border.all(
              color: Color(0xFF445492), // Specify your border color here
            ),
          ) : null,
          padding: EdgeInsets.symmetric(horizontal:
          widget.mediaItem.isLiveTVItem == true ?0:
          widget.isTopicScreen==true?0: 0,),
          width : widget.mediaItem.isLiveTVItem == true ? null :
          widget.mediaItem.isHomeScreen == false ? width *0.75 : width,
         // width: widget.mediaItem.isLiveTVItem == true ||
          // height: height *.75,
          // decoration: BoxDecoration(color: Colors.lightBlue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.mediaItem.isLiveTVItem == true?
              // Stack(
              //   children: [
                  // widget.mediaItem.isShowPlayingLive()
                  //     ?  Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: Container(
                  //     height: 6,
                  //     decoration: const BoxDecoration(
                  //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
                  //     ),
                  //     child: LinearProgressIndicator(
                  //      // borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5)),
                  //       value: _progress,
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  // ) :  const SizedBox.shrink(),
                  Container(

                    padding:  EdgeInsets.all(widget.mediaRow.mediaItems.first.isLiveTVItem ? 3.5: 8),

                    child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.mediaItem.title == 'Play Now'
                              ? widget.mediaItem.subtitle
                              : widget.mediaItem.title,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,),maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          if(!widget.mediaRow.mediaItems.first.isLiveTVItem)
                          Row(
                            children: [
                              Text(widget.mediaItem.subtitle,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w700,),maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(" : ${widget.mediaItem.showStatus}",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w700,),maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          if(widget.mediaRow.mediaItems.first.isLiveTVItem)
                            Text(widget.mediaItem.showStatus,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w700,),maxLines: 1,
                                overflow: TextOverflow.ellipsis),

                        ]),
                  )
                  // widget.mediaItem.isLiveTVItem == true?
                  // widget.mediaItem.isShowPlayingLive()? SizedBox(
                  //   height: 1,
                  //     child: LinearProgressIndicator(value: _progress)) : SizedBox.shrink()
                  //     :SizedBox.shrink(),
              //   ],
              // )
                  :
              Container(
                height: widget.mediaItem.isLiveTVItem==true|| widget.mediaItem.isHomeScreen == false ? height *0.75 : height,
                width: widget.mediaItem.isLiveTVItem==true || widget.mediaItem.isHomeScreen == false ? width *0.75 : width,
                // color:widget.mediaItem.selected! ? Colors.red : Colors.green,
                decoration: widget.mediaRow.contentType == 116
                    ? widget.mediaItem.selected!
                        ? null
                        : null
                    : null,

                child:ClipRRect(
                  borderRadius: widget.isTopicScreen==true?
                   const BorderRadius.all(Radius.circular(16.0)):
                   const BorderRadius.all(Radius.circular(16.0)),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: widget.mediaItem.isLiveTVItem == true
                            ? height * 0.75
                            : height,
                        width: widget.mediaItem.isLiveTVItem == true
                            ? width * 0.75
                            : width,
                        child: FittedBox(
                          fit: widget.mediaRow.contentType==116 ? BoxFit.fill :BoxFit.cover,
                          child:
                          widget.isTopicScreen==true && MediaRowContentTypes.peopleTypes
                              .contains(widget.mediaRow.contentType)? SizedBox(
                              child: Consumer<UserInterestsChangeNotifier>(
                                builder: ((context, interests, _) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: interests.isFavorite(
                                        widget.mediaItem.itemType,
                                        ChatAction.getActionFormattedItemId(
                                          widget.mediaItem.itemType,
                                          widget.mediaItem.itemID,
                                        ),
                                      )
                                          ? Border.all(color: const Color(0xffA8C7FA), width: 4.0)
                                          : null, // Conditionally apply red border
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipOval(
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            height: 110,
                                            width: 110,
                                            placeholder: (context, url) => Container(
                                              color: Colors.black45,
                                            ),
                                            errorWidget: (_, __, ___) => Container(
                                              decoration: const BoxDecoration(
                                                color:Colors.black45,
                                              ),
                                            ),
                                            imageUrl: widget.mediaItem.image,
                                          ),
                                        ),
                                        if (isLoading)
                                          const Center(
                                            child: Loader(),
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                              )
                          )
                              :Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                  ),
                                ),
                                imageUrl: widget.mediaItem.image,
                                // fit: BoxFit.cover,
                              ),
                              widget.isTopicScreen==true &&
                                  (widget.mediaRow.title=="Genres"||widget.mediaRow.title=="Top Genres" || widget.mediaRow.title=="Your favourite genres")?Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:28,
                                vertical: 28),
                                child: Text(widget.mediaItem.title,selectionColor: Colors.red, style:
                                AppTypography.activateTvTitle.copyWith(
                                  fontSize: 40,fontWeight: FontWeight.bold
                                )
                                  ,),
                              ):const SizedBox()
                            ],
                          )
                        ),
                      ),
                      (widget.mediaItem.isLiveTVItem == true &&
                              widget.mediaItem.video == "")
                          ? BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                color: Colors.black
                                    .withOpacity(0), // Adjust the opacity
                              ), // Adjust the blur intensity
                            )
                          : BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 0,
                                  sigmaY: 0), // Adjust the blur intensity
                              child: Container(
                                color: Colors.black
                                    .withOpacity(0), // Adjust the opacity
                              ),
                            ),
                      if (widget.mediaItem.schedule != null)
                        TimeInfo(mediaItem: widget.mediaItem),
                    ],
                  ),
                ),
              ),
                const SizedBox(
                  height: 8,
                ),
                if (widget.mediaItem.isLiveTVItem == false)
                  SingleChildScrollView(
                    child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        watchOnAction != null && watchOnAction.icon.isNotEmpty ?
                            // widget.isTopicScreen==true?const SizedBox.shrink():
                            CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                color: Theme.of(context).highlightColor,
                                height: 24,
                                width: 24,
                              ),
                              imageUrl: watchOnAction.icon,
                              fit: BoxFit.contain,
                              height: 15,
                              width: 15,
                            ): widget.isTopicScreen==true?Expanded(
                          child: Container(
                            padding: EdgeInsets.only(bottom: 0),
                            child: Center(
                              child: Text(MediaRowContentTypes.peopleTypes
                                  .contains(widget.mediaRow.contentType)?widget.mediaItem.title:'',
                                style:
                                AppTypography.loginText.copyWith(color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,fontFamily: "Roboto"),maxLines: 2,
                                textAlign: TextAlign.center, ),
                            ),
                          ),
                        ):watchOnAction == null  && widget.isTopicScreen== false? Text(""):
                          watchOnAction!.icon  == ''  &&  widget.mediaItem.itemType =='channel' ? Text(""):
                             widget.mediaRow.title!="Explore the OTT World"?
                        MediaRowContentTypes.peopleTypes
                                .contains(widget.mediaRow.contentType)
                            ?Expanded(
                              child: Text(widget.mediaItem.title,style:
                              AppTypography.loginText.copyWith(color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,fontFamily: "Roboto"),maxLines: 2,
                                textAlign: TextAlign.start,),
                            ):const SizedBox():const SizedBox(),
                        if (watchOnAction == null || watchOnAction.icon.isEmpty)
                          widget.isTopicScreen==true?const SizedBox():const SizedBox(height: 24,
                              width: 24),
                        if(widget.isEdit == true)
                          InkWell(
                          onTap: () async {
                            setState(() {
                              isFavoritePressed = widget.index;
                            });
                            if(widget.mediaRow.title == "Your movies watchlist"
                                ||widget.mediaRow.title == "Your shows watchlist"){
                              List<MediaAction> actionsData =
                                  widget.mediaItem.actions;
                              int index = actionsData
                                  .indexWhere((element) => element.title == "Add to Watchlist");

                              if (index != -1) {
                                await widget.mediaItem.actions[index].chatAction
                                    .executeAction(context);
                              } else {}
                            } else {
                              List<MediaAction> actionsData =
                                  widget.mediaItem.actions;
                              int sindex = actionsData.indexWhere((element) =>
                              element.title == "Add to favorites");
                              await widget.mediaItem.actions[sindex].chatAction
                                  .executeAction(context);
                            }
                            Future<MediaDetail> mediaDetail = getIt<SensyApi>().fetchMediaDetail("tab", "library");
                            //fetchData("tab", "library");
                            mediaDetail.then((value) {
                              widget.isEdit = !widget.isEdit!;
                              // setState(() {
                              widget.set!.call(value.mediaRows);
                              // });
                            });
                          },
                          child:  isFavoritePressed == widget.index
                              ? SizedBox(
                            width: 23,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          )
                              : (widget.mediaRow.title == "Your movies watchlist" ||
                              widget.mediaRow.title == "Your shows watchlist")
                              ? Icon(Icons.cancel_outlined)
                              : Icon(Icons.favorite),
                        ),
                      ],
                    )
                  )
            ],
          ),
        ),
      ],
    );
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

  Future<void> fetchData(String itemType, String itemId) async {
    widget.isLoading?.call(false);
    getIt<SensyApi>().fetchMediaDetail("app_lite", itemId).then((mediaDetail) {
      if (kDebugMode) {
        print(mediaDetail.mediaHeader);
      }
      _rows = mediaDetail.mediaRows;

      for (var element in _rows) {
        mediaItems.addAll(element.mediaItems);
      }

      widget.onAppSeriesLoaded?.call(mediaItems);
      widget.isLoading?.call(true);
      setState(() {});
      // if (!existingHeader) {
      //   header = mediaDetail.mediaHeader;
      // }
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        // case DioException:
        //   final error = (errorObj as DioException);
        //   final response = error.response;
        //   showVanillaToast("Failed to fetch page: ${response?.statusCode}");
        //   if (kDebugMode) {
        //     print("Failed to fetch page "
        //         "${widget.itemType}:${widget.itemId}: ${error.type}: ${error.response}: ${error.message}");
        //   }
      }
    });
  }
}

class TimeInfo extends StatelessWidget {
  final MediaItem mediaItem;
  const TimeInfo({
    super.key,
    required this.mediaItem,
  });

  String _getTimeInfo() {
    Schedule schedule = mediaItem.schedule!;
    final showStartTime = DateTime.parse(schedule.start).toLocal();
    final showEndTime = showStartTime.add(Duration(minutes: schedule.duration));
    return '${DateFormat.jm().format(showStartTime).replaceAll('AM', '').replaceAll('PM', '')} - ${DateFormat.jm().format(showEndTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (mediaItem.isShowPlayingLive())
              CircleAvatar(radius: 9.r, backgroundColor: Colors.red)
            else
              Icon(
                Icons.alarm,
                size: 18.r,
              ),
            SizedBox(width: 5.w),
            Text(_getTimeInfo(), style: AppTypography.undefinedTextStyle,),
          ],
        ),
      ),
    );
  }
}
