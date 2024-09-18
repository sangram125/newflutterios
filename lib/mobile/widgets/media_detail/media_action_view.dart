import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/api/sensy_api.dart';
import '../../../data/models/constants.dart';
import '../../../data/models/models.dart';
import '../../../data/models/user_interests.dart';
import '../../../injection/injection.dart';
import '../../../sdk_action_manager.dart';
import '../../../utils.dart';
import '../../../widgets/loader.dart';

class MediaActionView extends StatefulWidget {
  const MediaActionView({
    Key? key,
    required this.mediaAction,
    // required this.listMediaAction
  }) : super(key: key);

  final MediaAction mediaAction;
  // final List<MediaAction> listMediaAction;

  @override
  State<MediaActionView> createState() => _MediaActionViewState();
}

class _MediaActionViewState extends State<MediaActionView> {
  static const actionHeight = 36.0;
  bool isLoading = false;
  bool show = false;

  @override
  Widget build(BuildContext context) {
    final actionType = widget.mediaAction.chatAction.actionType;

    if (ActionTypes.iconTypes.contains(actionType)) {
      return _getIconButton();
    } else if (ActionTypes.watchOnActionTypes.contains(actionType)) {
      return _getWatchOnButton();
    }

    return _getVanillaButton();
  }

  Widget _getIconButton() {
    return isLoading
        ? const Center(
            child: SizedBox(
              width: 300,
              height: 150,
              child: Center(child: Loader()),
            ),
          )
        : GestureDetector(
            onTap: () => executeAction(context),
            child: _getIconButtonContents(),
          );
  }

  Widget _getIconButtonContents() {
    return Consumer<UserInterestsChangeNotifier>(
      builder: (_, interests, __) => Visibility(
        visible: _getVisibility(interests),
        child: SvgPicture.asset(
          "assets/icons/${_getIconButtonAsset(interests)}",
          width: actionHeight,
          height: actionHeight,
        ),
      ),
    );
  }

  String _getIconButtonAsset(UserInterestsChangeNotifier interests) {
    String asset;
    List<String> typeAndID =
        ChatAction.getItemTypeAndItemID(widget.mediaAction.chatAction);
    String itemType = typeAndID[0];
    String itemID = typeAndID[1];
    switch (widget.mediaAction.chatAction.actionType) {
      case ActionTypes.callServer:
      case ActionTypes.setMediaItemNotInterested:
      case ActionTypes.setMediaItemSeen:
      case ActionTypes.setMediaItemWatchlist:
        asset = interests.isInWatchlist(itemType, itemID)
            ? "bookmark.svg"
            : "bookmarked.svg";
        break;
      case ActionTypes.setMediaItemFavorite:
      default:
        asset = "";
        break;
    }
    return asset;
  }

  bool _getVisibility(UserInterestsChangeNotifier interests) {
    bool asset;
    List<String> typeAndID =
        ChatAction.getItemTypeAndItemID(widget.mediaAction.chatAction);
    switch (widget.mediaAction.chatAction.actionType) {
      case ActionTypes.callServer:
        asset = false;
        break;
      case ActionTypes.setMediaItemNotInterested:
        asset = false;
        break;
      case ActionTypes.setMediaItemSeen:
        asset = false;
        break;
      case ActionTypes.setMediaItemWatchlist:
        asset = true;
        break;
      case ActionTypes.setMediaItemFavorite:
      default:
        asset = false;
        break;
    }
    return asset;
  }

  Widget _getWatchOnButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width - 32, 48),
          backgroundColor: Colors.white.withOpacity(0.05),
          textStyle:  AppTypography.fontSizeChanges,
        ),
        onPressed: () => executeAction(context),
        child: _getWatchOnButtonContent(),
      ),
    );
  }

  _getWatchOnButtonContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(
          placeholder: (context, url) => Container(
            color: Theme.of(context).highlightColor,
          ),
          imageUrl: widget.mediaAction.icon,
          fit: BoxFit.contain,
          height: 24,
          width: 24,
        ),
        // Image(
        //   height: 24,
        //   width: 24,
        //   image: AssetImage('assets/icons/play_icon.png'),
        // ),
        const SizedBox(
          width: 8,
        ),
        // Text("WATCH NOW",style: TextStyle(fontSize: 16),)
        Text(
          widget.mediaAction.title,
          style: TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: 'Raleway',
        )),
        // const Text(Constants.watchOnActionLabelPrefix),
      ],
    );
  }

  Widget _getVanillaButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border:
        Border.all(color: Colors.white.withOpacity(0.20), width: 1.0),
        borderRadius: const BorderRadius.all(
            Radius.circular(500.0) //                 <--- border radius here
        ),
      ),
      // margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: OutlinedButton(
        onPressed: () => executeAction(context),
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(
            width: 1.0,
            color: Colors.white,
          ),
          fixedSize: Size(MediaQuery.of(context).size.width - 32, 48),
          backgroundColor: Colors.transparent,
          textStyle: AppTypography.skipButtonTextRecommendationView,
        ),
        child: Text(
          widget.mediaAction.title,
          style: AppTypography.mediaHeaderTitleImageText,
          // TextStyle(
          //   fontSize: 16,
          //   color:Colors.black,
          //   fontFamily: 'Raleway',
          // ),
          maxLines: 1,
        ),
      ),
    );
  }

  executeAction(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final action = widget.mediaAction.chatAction;
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
                  style: AppTypography.submitbutton,
                ),
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      action.executeAction(context);
                      Navigator.pop(context);
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
                      forwardDeeplink(action);
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
                      const Text(
                        '2/2',
                        style: AppTypography.whiteColorText,
                      ),
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
      await widget.mediaAction.chatAction.executeAction(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  forwardDeeplink(ChatAction chatAction) {
    final sensyApi = getIt<SensyApi>();
    sensyApi.fetchTvDevices().then((devices) {
      //print(devices);
      if (devices.isEmpty) {
        showVanillaToast("No paired devices");
        return;
      }

      // Forward to first device for now.
      final deviceId = devices.first.id.toString();
      sensyApi
          .forwardToTvDevice(
              deviceId,
              ChatAction(
                  actionID: chatAction.actionID,
                  actionTitle: chatAction.actionTitle,
                  actionType: ActionTypes.viewDeeplink,
                  actionMeta: chatAction.actionMeta,
                  response: ""))
          .then((value) => context.push("/remote/$deviceId"))
          .catchError((errorObj, stackTrace) {
        switch (errorObj.runtimeType) {
          case DioException:
            final response = (errorObj as DioException).response;
            showVanillaToast(
                "Failed to forward deeplink to device: ${response?.statusCode}");
        }
      });
    }).catchError((errorObj, stackTrace) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to retrieve devices: ${response?.statusCode}");
      }
    });
  }
}
