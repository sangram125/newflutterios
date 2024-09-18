import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/mobile/widgets/media_detail/media_detail_controller/media_detail_page_controller.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:dor_companion/widgets/movie_detail_description_text.dart';
import 'package:dor_companion/widgets/movie_detail_play_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:video_player/video_player.dart';

import '../../../data/models/models.dart';
import '../../../data/models/user_interests.dart';
import '../../../widgets/themed_video_player.dart';
import 'media_action_view.dart';

class MediaHeaderView extends StatefulWidget {
  const MediaHeaderView({Key? key, required this.mediaHeader, required this.row,})
      : super(key: key);
  final MediaHeader mediaHeader;
  final List<MediaRow> row;

  @override
  State<MediaHeaderView> createState() => _MediaHeaderViewState();
}

class _MediaHeaderViewState extends State<MediaHeaderView> {
  VideoPlayerController? _videoPlayerController;
  AnalyticsEvent eventCall = AnalyticsEvent();
  MediaDetailController controller = Get.put(MediaDetailController());
  @override
  void initState() {
    super.initState();
    print("header view");
    controller.showTrailer = false;
   Timer(const Duration(seconds: 2), () {
      if (controller.isTrailerPresent.value & mounted) {
          controller.showTrailer = true;
      }
    });
    controller.isTrailerPresent.value = widget.mediaHeader.mediaItem?.video.isNotEmpty ?? false;
    if (widget.mediaHeader.mediaItem?.isLiveTVItem ?? false) {
      controller.isTrailerPresent.value = false;
    }
    Timer(const Duration(seconds: 3), () {
      if (controller.isTrailerPresent.value) {
           _videoPlayerController =
               VideoPlayerController.network(
                   widget.mediaHeader.mediaItem!.video);
           _videoPlayerController?.play();
      }
    });
  }

  @override
  void dispose() {
    controller.isTrailerPresent.value = false;
    controller.showTrailer = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String image = widget.mediaHeader.mediaItem?.imageHD ?? '';
    String description = widget.mediaHeader.mediaItem!.description;
    if (image.isEmpty) {
      image = widget.mediaHeader.mediaItem!.image;
    }
    if (description.isEmpty) {
      description = widget.mediaHeader.description;
    }
    final List<Widget> watchOnActions = [];
    for (MediaAction action in widget.mediaHeader.mediaItem?.actions ?? []) {
      final actionWidget = MediaActionView(
        mediaAction: action,
        // listMediaAction: widget.mediaHeader.mediaItem.actions,
      );
      if (ActionTypes.watchOnActionTypes
          .contains(action.chatAction.actionType)) {
        watchOnActions.add(actionWidget);
      } else if (ActionTypes.iconTypes.contains(action.chatAction.actionType)) {
        // iconActions.add(actionWidget);
      } else {
        // otherActions.add(actionWidget);
      }
    }
    var lengthOfactions = watchOnActions.length;
    final Widget bannerWidget;
    if (image.isNotEmpty) {
      bannerWidget = CachedNetworkImage(
        placeholder: (context, url) {
          return Container();
        },
        errorWidget: (context, url, error) => Container(),
        width: MediaQuery.of(context).size.width,
        imageUrl: image,
        fit: BoxFit.cover,
      );
    } else {
      bannerWidget = Container();
    }

    final videoPlayerController = _videoPlayerController;
    final Widget trailerWidget;
    if (videoPlayerController != null) {
      trailerWidget =
          ThemedVideoPlayer(videoPlayerController: videoPlayerController,allowFullscreen: true,);
      videoPlayerController.addListener(() {
        if (videoPlayerController.value.position ==
            videoPlayerController.value.duration) {
          if (mounted) {
              controller.showTrailer = false;
          }
        }
        if (videoPlayerController.value.hasError) {
          if (kDebugMode) {
            print("Error from videoPlayerController: "
                "${videoPlayerController.value.errorDescription}");
          }
          if (mounted) {
              controller.showTrailer = false;
          }
        }
      });
    } else {
      trailerWidget = Container();
    }
    final animatedTrailer = Container(
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.background,
            Theme.of(context).colorScheme.background.withOpacity(0.0),
          ],
          stops: const [
            0,
            0.35,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: AnimatedCrossFade(
          firstChild: bannerWidget,
          secondChild: trailerWidget,
          crossFadeState:
          controller.showTrailer ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(seconds: 1),
        ),
    );

    Widget tagItem(String title,) {
      debugPrint("####title = $title");
      if (title == '') return const SizedBox();
      return Text(
        "$title • ",
        style: AppTypography.rowViewTitle,
      );
    }

    List<String?> stringData =
        widget.mediaHeader.mediaItem?.subtitle.toString().split("·") ?? [];
    String watchOnAction = controller.getFirstWatchOnActionOrNull(widget.mediaHeader.mediaItem!.actions);
    print("action is  empty or not ${widget.mediaHeader.mediaItem?.itemType}");
    return MultiSliver(
      children: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: MediaQuery.of(context).size.width / 16 * 9,
          flexibleSpace: FlexibleSpaceBar(
            background: animatedTrailer,
          ),
        ),
        if (widget.mediaHeader.mediaItem?.title != '')
           Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  widget.mediaHeader.mediaItem!.itemType =="facet"||widget.mediaHeader.mediaItem!.itemType =="pr_app"  ? AutoSizeText(
                    widget.mediaHeader.mediaItem?.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.mediaHeaderTitle,
                  ):Expanded(
                    child: ListTile(
                      leading: watchOnAction.isEmpty? null:CachedNetworkImage(
                        fit: BoxFit.contain,
                        height: 80,
                        width: 80,
                        placeholder: (context, url) => Container(
                          color: Colors.black45,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          decoration: const BoxDecoration(
                            color:Colors.black45,
                          ),
                        ),
                        imageUrl: watchOnAction,
                      ) ,
                      title:  AutoSizeText(
                        widget.mediaHeader.mediaItem?.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.mediaHeaderTitle,
                      ),
                      subtitle:(widget.mediaHeader.mediaItem?.isLiveTVItem == false && widget.mediaHeader.mediaItem?.isAppForYou == false) && widget.mediaHeader.mediaItem!.itemType == "facet" ? Container():
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          // runSpacing: 8,
                          // spacing: 2,
                          children: [
                           tagItem(
                             stringData.length > 1 ? stringData[1] ?? "" : "",
                           ),
                            tagItem(
                              stringData.length > 4 ? stringData[4] ?? "" : "",
                            ),
                            Flexible(
                              child: Text(
                                stringData.length > 3 ? stringData[0] ?? "" : "",
                                style: AppTypography.rowViewTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        if(description.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpandableText(text: description, trimLines: 2, rows:widget.row),
            ],
          ),
        ),
        description.isNotEmpty ? const SizedBox(height: 10,) :const SizedBox.shrink(),
        if (widget.mediaHeader.mediaItem?.isAppForYou == false)
          widget.mediaHeader.mediaItem!.itemType == "facet"
              ? const SizedBox.shrink()
              : widget.mediaHeader.mediaItem?.itemType!=controller.watchNowPeople?Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                lengthOfactions == 0?
                const SizedBox.shrink():
                widget.mediaHeader.mediaItem!.actions.isNotEmpty && widget.mediaHeader.mediaItem!.actions[0].title!="Install" ?
                  PlayScreenButton(
                    title: "Play",
                    imageWidget:  SvgPicture.asset('assets/icons/Play_icon_2.svg'),
                    onPressed: showWatchNowDialog,
                  ):const SizedBox.shrink(),
              ],
            ),
          ):const SizedBox.shrink(),
        widget.mediaHeader.mediaItem!.itemType =="facet" ||(widget.mediaHeader.mediaItem!.itemType =="vct"&&lengthOfactions!=0) || (widget.mediaHeader.mediaItem!.itemType !="pr_app"&&lengthOfactions==0)
            ?const SizedBox.shrink(): Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                children: [
                  if (widget.mediaHeader.mediaItem?.isLiveTVItem == false &&
                      widget.mediaHeader.mediaItem?.isAppForYou == false)
                    widget.mediaHeader.mediaItem!.itemType == "facet"
                        ? const SizedBox.shrink()
                        :  widget.mediaHeader.mediaItem!.actions.isNotEmpty ? widget.mediaHeader.mediaItem!.actions[0].title!="Install"?
                    Consumer<UserInterestsChangeNotifier>(
                        builder: (_, interests, __) {
                          List<MediaAction> actionsData =
                              widget.mediaHeader.mediaItem!.actions;
                          int index = actionsData.indexWhere((element) =>
                          element.title == "Add to favorites");
                          List<String> typeAndID =
                          ChatAction.getItemTypeAndItemID(widget
                              .mediaHeader
                              .mediaItem!
                              .actions[index]
                              .chatAction);
                          String itemType = typeAndID[0];
                          String itemID = typeAndID[1];
                          return InkWell(
                            onTap: () async {
                              eventCall.addToFavoriteEvent('movie_detail_screen');
                              if (index != -1) {
                                await widget.mediaHeader.mediaItem!
                                    .actions[index].chatAction
                                    .executeAction(context);
                              }
                            },
                            child:  widget.mediaHeader.mediaItem!.itemType =="vct" ?const SizedBox.shrink():actionButton(interests.isFavorite(itemType, itemID) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                                "Favourite",
                                    () async {
                              eventCall.addToFavoriteEvent('movie_detail_screen');
                              if (index != -1) {
                                await widget.mediaHeader.mediaItem!
                                    .actions[index].chatAction
                                    .executeAction(context);
                              }
                            }),
                          );
                        }): const SizedBox.shrink() : const SizedBox.shrink(),
                ],
              ),
              const SizedBox(width: 5,),
              ..._getActions2(),
              const SizedBox(width: 5,),
              widget.mediaHeader.mediaItem!.itemType =="pr_app"  ? SizedBox.shrink():
              actionButton(const Icon(Icons.file_upload_outlined), "Recommended", ()
              async {
                eventCall.shareEvent('movie_detail_screen');
                String title = widget.mediaHeader.mediaItem?.title ?? "Untitled";
                String actionID = widget.mediaHeader.mediaItem?.actions.first.chatAction.actionID ?? "";
                String link = "Watch on Dor - $title\n"
                    "Watch the latest Movies, Web Series, TV shows and Live sports from 25+ OTT apps - all in one app, one subscription!\n"
                    "$actionID";
                controller.debouncer.run(() {
                  Share.share(link);
                });
              })
            ],
          ),
        )
      ],
    );
  }

  Widget actionButton(Icon icon, String title, Function() onTap){
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.3;
    return Column(
      children: [
        IconButton(onPressed:onTap, icon: icon),
        Container(
          width: buttonWidth,
          child: Center(
            child: AutoSizeText(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTypography.mediaHeaderActionButtonText,
            ),
          ),
        ),
      ],
    );
  }
  executeAction(BuildContext context, MediaAction mediaAction) async {
    setState(() {
      controller.isLoading.value = true;
    });

    final action = mediaAction.chatAction;
    print("actuin typ ${action.actionType}");
    if (action.actionType == ActionTypes.viewDeeplink) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(
                // Customize the dialog's background color
                dialogBackgroundColor: const Color(0XFF040523),
              ),
              child: SimpleDialog(
                title: const Text(
                  "WATCH ON",
                  style: AppTypography.profileMainViewsTitle,
                ),
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      action.executeAction(context);
                      // Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 36,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 260,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.phone_android_sharp,
                              size: 24,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Continue with mobile",
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      eventCall.watchNowEvent('movie_detail_screen');
                      controller.forwardDeeplink(action,context);
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 36,
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 260,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                            border: Border.all(
                              color: Colors.white, // Border color
                              width: 2, // Border width
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.tv,
                                size: 24,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Watch on TV",
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Back',
                            style: AppTypography.whiteColorText,
                          )),
                    ],
                  ),
                ],
              ),
            );
          });
    } else {
      await mediaAction.chatAction.executeAction(context);
    }
    setState(() {
      controller.isLoading.value = false;
    });
  }

  void showWatchNowDialog() {
    final List<Widget> watchOnActions = [];
    for (MediaAction action in widget.mediaHeader.mediaItem?.actions ?? []) {
      final actionWidget = MediaActionView(
        mediaAction: action,
      );
      if (ActionTypes.watchOnActionTypes
          .contains(action.chatAction.actionType)) {
        watchOnActions.add(actionWidget);
      } else if (ActionTypes.iconTypes.contains(action.chatAction.actionType)) {
        // iconActions.add(actionWidget);
      } else {
        // otherActions.add(actionWidget);
      }
    }
    var lengthOfactions = watchOnActions.length;
    if (lengthOfactions == 1) {
      List<MediaAction> actionsData = widget.mediaHeader.mediaItem!.actions;
      int index = actionsData
          .indexWhere((element) => element.title.contains("Watch on"));

      executeAction(context, widget.mediaHeader.mediaItem!.actions[index]);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Material(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: const Color(0xFF040523),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: Navigator.of(context).pop,
                          ),
                        ),
                        const Text('WATCH ON', style: AppTypography.undefinedTextStyle,),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: const Text(
                            'This movie is available on multiple platforms, which one would you prefer ?',
                            style: AppTypography.whiteColorText,
                          ),
                        ),
                        ..._getActions(),
                        const Text('1/2', style: AppTypography.undefinedTextStyle,),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    }
  }

  List<Widget> _getActions() {
    final List<Widget> watchOnActions = [];
    final List<Widget> otherActions = [];
    int i = 0;
    widget.mediaHeader.mediaItem;
    for (MediaAction action in widget.mediaHeader.mediaItem?.actions ?? []) {
      final actionWidget = MediaActionView(
        mediaAction: action,

        // listMediaAction: widget.mediaHeader.mediaItem.actions,
      );
      if (ActionTypes.watchOnActionTypes
          .contains(action.chatAction.actionType)) {
        watchOnActions.add(actionWidget);
        i++;
      } else if (ActionTypes.iconTypes.contains(action.chatAction.actionType)) {
        // iconActions.add(actionWidget);
      } else {
        // otherActions.add(actionWidget);
      }
    }
    return [
      ...watchOnActions,
      ...otherActions,
      const SizedBox(
        height: 16,
      ),
      // iconActionsRow
    ];
  }

  List<Widget> _getActions2() {
    final List<Widget> watchOnActions = [];
    final List<Widget> iconActions = [];
    final List<Widget> otherActions = [];

    for (MediaAction action in widget.mediaHeader.mediaItem!.actions) {
      final actionWidget = MediaActionView(mediaAction: action);
      if (ActionTypes.watchOnActionTypes.contains(action.chatAction.actionType)) {
        // watchOnActions.add(actionWidget);
      } else if (ActionTypes.iconTypes.contains(action.chatAction.actionType)) {
        iconActions.add(actionWidget);
      } else {
        otherActions.add(actionWidget);
      }
    }
    Widget? watchLaterButton; // Make watchLaterButton nullable
    if (widget.mediaHeader.mediaItem!.actions.length > 2 &&
        widget.mediaHeader.mediaItem!.actions[0].title != "Install") {
      watchLaterButton = Consumer<UserInterestsChangeNotifier>(builder: (_, interests, __) {
        List<String> typeAndID = ChatAction.getItemTypeAndItemID(widget.mediaHeader.mediaItem!.actions[2].chatAction);
        String itemType = typeAndID[0];
        String itemID = typeAndID[1];
        bool isWatchLater = interests.isInWatchlist(itemType, itemID);

        return actionButton(!isWatchLater ? const Icon(Icons.add) : const Icon(Icons.cancel_outlined),
            "Watch Later",
                () async {
          eventCall.watchLaterEvent('movie_detail_screen');
          List<MediaAction> actionsData = widget.mediaHeader.mediaItem!.actions;
          int index = actionsData.indexWhere((element) => element.title == "Add to Watchlist");

          if (index != -1) {
            await widget.mediaHeader.mediaItem!.actions[index].chatAction.executeAction(context);
            setState(() {
              isWatchLater = interests.isInWatchlist(itemType, itemID);
            });
          }
        });
      });
    }
    final List<Widget> result = [
      ...watchOnActions,
      ...otherActions,
      const SizedBox(height: 16),
    ];
    // Add watchLaterButton to the result list if it's not null
    if (watchLaterButton != null) {
      result.add(watchLaterButton);
    }
    return result;
  }
}
