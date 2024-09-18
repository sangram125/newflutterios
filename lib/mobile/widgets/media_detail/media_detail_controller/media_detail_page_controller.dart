import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dor_companion/app_router.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/firebase_remote_connfig/firebase_remote_config.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/home/view/news_view.dart';
import 'package:dor_companion/mobile/home/view/sports_view.dart';
import 'package:dor_companion/mobile/widgets/live_tv_view.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:dor_companion/utils.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class MediaDetailController extends GetxController {
  MediaHeader? header;
  List<MediaRow> rows = <MediaRow>[].obs;
  RxBool isRowsError = false.obs;
  ScaffoldMessengerState? snackbar;
  //VideoPlayerController? videoPlayerController;
  RxBool isTrailerPresent = false.obs;
  bool showTrailer = false;
  RxBool isLoading = false.obs;
  Timer? timer;
  RxBool isAddedToWatchList = false.obs;
  final watchNowPeople = FirebaseRemoteConfigService().getWatchNowPeople();
  //VideoPlayerController? videoPlayerController;
  final Debouncer debouncer = Debouncer(milliseconds: 400);
  RxBool isFavourite = false.obs;
  RxBool isWatchLater = false.obs;
  //final ScrollController scrollController = ScrollController();
  //RxString? image;
  // RxString profileImage = "".obs;
  // RxInt numProfiles = 0.obs;
  // RxBool newMovies = true.obs,
  //     rewardsOffers = false.obs,
  //     parentalControl = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  Future<void> fetchData(String itemType, String itemId, MediaHeader? header1) async {
    final tempHeader = header1;
    print("widtge item tye${itemType}");
    print("widtge item id${itemId}");
    print("header 1 ${header1!.mediaItem!.description}");
    bool existingHeader = tempHeader != null;
    print("headr 2");
    //setState(() {
      isRowsError.value = false;
    print("headr 3");
      rows.clear();
    print("headr 4");
      header = existingHeader ? header1 : null;
   // });
    print("header 2 ${header!.mediaItem!.description}");
    snackbar?.removeCurrentSnackBar(reason: SnackBarClosedReason.action);
    print("fetch media detail");
    final Trace trace = FirebasePerformance.instance.newTrace('fetch-media-detail');
    trace.start();
    getIt<SensyApi>()
        .fetchMediaDetail(itemType, itemId)
        .then((mediaDetail) {
      //if (mounted) {
        //setState(() {

          isRowsError.value = mediaDetail.mediaRows.isEmpty;
          for (MediaRow row in mediaDetail.mediaRows) {
            if (row.mediaItems.isNotEmpty) {
              print("row value ${row.title}");
              rows.add(row);
              for (var mediaItem in row.mediaItems) {
                mediaItem.isHomeScreen = true;
              }
            }
          }
          print("media detai move${rows.elementAt(0).title}");
          if (!existingHeader) {
            header = mediaDetail.mediaHeader;
          }

       // });
      //}
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final error = (errorObj as DioException);
          final response = error.response;
          print("Failed to fetch page: ${response?.statusCode}");
          if (kDebugMode) {
            // print("Failed to fetch page "
            //     "${widget.itemType}:${widget.itemId}: ${error.type}: ${error.response}: ${error.message}");
          }
      }
      //if (mounted) {
        //setState(() {
          isRowsError.value = true;
          rows.clear();
          header = existingHeader ? tempHeader : null;
        });
        // showRetrySnackbar();
      //}
    //});
    trace.stop();
  }

  forwardDeeplink(ChatAction chatAction, BuildContext context) {
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

  String getFirstWatchOnActionOrNull(List<MediaAction> actions) {
    if (actions.isEmpty) {
      return '';
    }
    for (MediaAction action in actions) {
      if (ActionTypes.watchOnActionTypes
          .contains(action.chatAction.actionType)) {
        return action.icon;
      }
    }

    return '';
  }
}
