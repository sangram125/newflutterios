import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:video_player/video_player.dart';
import '../../../widgets/custom_search_widget.dart' as se;
import '../../../data/api/sensy_api.dart';
import '../../../data/models/models.dart';
import '../../../data/models/search_suggestions.dart';
import '../../../injection/injection.dart';
import '../../../widgets/themed_video_player.dart';
import '../../../mobile/search/search_view.dart';
import 'media_action_view.dart';

class MediaHeaderView extends StatefulWidget {
  const MediaHeaderView({Key? key, required this.mediaHeader})
      : super(key: key);
  final MediaHeader mediaHeader;

  @override
  State<MediaHeaderView> createState() => _MediaHeaderViewState();
}

class _MediaHeaderViewState extends State<MediaHeaderView> {
  bool isTrailerPresent = false;
  bool _showTrailer = false;
  Timer? timer;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 2), () {
      if (isTrailerPresent & mounted) {
        setState(() {
          _showTrailer = true;
        });
      }
    });
    isTrailerPresent = widget.mediaHeader.mediaItem?.video.isNotEmpty??false;
    if (isTrailerPresent) {
      _videoPlayerController =
          VideoPlayerController.network(widget.mediaHeader.mediaItem!.video);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String image = widget.mediaHeader.mediaItem?.imageHD??'';
    String potrait = widget.mediaHeader.mediaItem!.image;
    String description = widget.mediaHeader.mediaItem?.description??'';
    double width = MediaQuery.of(context).size.width;

    if (image.isEmpty) {
      image = widget.mediaHeader.mediaItem!.image;
    }

    if (description.isEmpty) {
      description = widget.mediaHeader.description;
    }

    final Widget bannerWidget;
    if (image.isNotEmpty) {
      bannerWidget = CachedNetworkImage(
        height: width / 3.2,
        width: width / 1.8,
        placeholder: (context, url) {
          return Container();
        },
        errorWidget: (context, url, error) => Container(),
        imageUrl: image,
        fit: BoxFit.cover,
      );
    } else {
      bannerWidget = Container();
    }

    final videoPlayerController = _videoPlayerController;
    final Widget trailerWidget;
    if (videoPlayerController != null) {
      trailerWidget = SizedBox(
        height: width / 3.2,
        width: width / 1.8,
        child: ThemedVideoPlayer(videoPlayerController: videoPlayerController),
      );
      videoPlayerController.setVolume(0.0);
      videoPlayerController.addListener(() {
        if (videoPlayerController.value.position ==
            videoPlayerController.value.duration) {
          if (mounted) {
            setState(() {
              _showTrailer = false;
            });
          }
        }
        if (videoPlayerController.value.hasError) {
          if (kDebugMode) {
            print("Error from videoPlayerController: "
                "${videoPlayerController.value.errorDescription}");
          }
          if (mounted) {
            setState(() {
              _showTrailer = false;
            });
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
      child: Container(
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
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: isTrailerPresent
            ? AnimatedCrossFade(
                firstChild: bannerWidget,
                secondChild: trailerWidget,
                crossFadeState: _showTrailer
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(seconds: 1),
              )
            : bannerWidget,
      ),
    );

    return MultiSliver(
      children: [
        Stack(children: [
          Align(
            alignment: Alignment.topRight,
            child: animatedTrailer,
          ),
          Padding(
              padding: EdgeInsets.only(left: 20, top: width / 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      placeholder: (context, url) {
                        return Container();
                      },
                      errorWidget: (context, url, error) => Container(),
                      imageUrl: potrait,
                      height: 210,
                      width: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.mediaHeader.mediaItem?.title??'',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      fontSize: 36.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      widget.mediaHeader.mediaItem?.subtitle??'',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.1,
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16.0,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  _getActions(),
                ],
              )),
          Container(
            margin: const EdgeInsets.only(left: 10, top: 30),
            child: Row(children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {
                    context.push("/");
                  },
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {
                    se.showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(
                        searchSuggestion: getIt<SearchSuggestions>(),
                        sensyApi: getIt<SensyApi>(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ))
            ]),
          )
        ]),
      ],
    );
  }

  Widget _getActions() {
    final List<Widget> watchOnActions = [];
    final List<Widget> iconActions = [];
    final List<Widget> otherActions = [];
    for (MediaAction action in widget.mediaHeader.mediaItem?.actions??[]) {
      final actionWidget = MediaActionView(mediaAction: action);
      if (ActionTypes.watchOnActionTypes
          .contains(action.chatAction.actionType)) {
        watchOnActions.add(actionWidget);
      } else if (ActionTypes.iconTypes.contains(action.chatAction.actionType)) {
        iconActions.add(actionWidget);
      } else {
        otherActions.add(actionWidget);
      }
    }

    final watchActionsRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: watchOnActions,
    );

    final otherActionsRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: otherActions,
    );

    final iconActionsRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: iconActions,
    );

    return Row(
      children: [watchActionsRow, iconActionsRow, otherActionsRow],
    );
  }
}
