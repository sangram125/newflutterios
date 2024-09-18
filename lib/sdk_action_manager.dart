import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dor_companion/app_router.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/amazon_prime_video_cx_journey/amazon_prime_activation_initial_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/api/sensy_api.dart';
import 'data/models/constants.dart';
import 'data/models/models.dart';
import 'data/models/user_interests.dart';
import 'main.dart';
import 'utils.dart';

class ActionTypes {
  static const switchChannel = "SWITCH_CHANNEL";
  static const switchLCN = "SWITCH_LCN";
  static const switchSource = "SWITCH_SOURCE";
  static const setTV = "SET_TV";
  static const setOperator = "SET_OPERATOR";
  static const setOperatorSubRemote = "SET_OPERATOR_SUB_REMOTE";
  static const sendRemoteKey = "SEND_REMOTE_KEY";
  static const systemInfo = "LOOKUP_SYSTEM_INFO";
  static const setLanguages = "SET_LANGUAGES";
  static const displayEPG = "DISPLAY_EPG";
  static const displayMediaDetail = "DISPLAY_MEDIA_DETAIL";
  static const chatbotHelp = "CHATBOT_HELP";
  static const setTVSourceInput = "SET_TV_SOURCE_INPUT";
  static const launchYoutubeDeeplink = "LAUNCH_YOUTUBE_DEEPLINK";
  static const viewDeeplink = "VIEW_DEEPLINK";
  static const forwardDeeplink = "FORWARD_DEEPLINK";
  static const viewURL = "VIEW_URL";
  static const viewDetail = "VIEW_DETAIL";
  static const launchVideo = "LAUNCH_VIDEO";
  static const viewVideo = "VIEW_VIDEO";
  static const sendACCode = "SEND_AC_CODE";
  static const launchScreen = "LAUNCH_SCREEN";
  static const launchSearch = "LAUNCH_SEARCH";
  static const launchApp = "LAUNCH_APP";
  static const installApp = "INSTALL_APP";
  static const sendNotification = "SEND_NOTIFICATION";
  static const doNothing = "DO_NOTHING";
  static const setMediaItemFavorite = "SET_MEDIA_ITEM_FAVORITE";
  static const setMediaItemSeen = "SET_MEDIA_ITEM_SEEN";
  static const setMediaItemWatchlist = "SET_MEDIA_ITEM_WATCHLIST";
  static const setMediaItemNotInterested = "SET_MEDIA_ITEM_NOT_INTERESTED";
  static const addFavoriteChannel = "ADD_FAVORITE_CHANNEL";
  static const addFavoriteShow = "ADD_FAVORITE_SHOW";
  static const addFavoriteFacet = "ADD_FAVORITE_FACET";
  static const startMonkey = "START_MONKEY";
  static const stopMonkey = "STOP_MONKEY";
  static const sendKeycode = "SEND_KEYCODE";
  static const alexaPowerController = "ALEXA_POWER_CONTROLLER";
  static const rebootTV = "REBOOT_TV";
  static const systemInfoIP = "Network:IP";
  static const systemInfoSSID = "Network:SSID";
  static const engagement = "START_ENGAGEMENT";
  static const tvToPhone = "TV_TO_PHONE";
  static const phoneToTv = "PHONE_TO_TV";
  static const show360Image = "SHOW_360_IMAGE";
  static const showPanorama = "SHOW_PANORAMA";
  static const callServer = "CALL_SERVER";

  static final iconTypes = [
    setMediaItemFavorite,
    setMediaItemNotInterested,
    setMediaItemSeen,
    setMediaItemWatchlist,
    callServer,
  ];

  static final watchOnActionTypes = [
    viewDeeplink,
    viewVideo,
    launchVideo,
  ];
}

class SDKActionsManager {
  static final SDKActionsManager _instance = SDKActionsManager._internal();

  factory SDKActionsManager() {
    return _instance;
  }

  SDKActionsManager._internal();

  executeLiveTV(BuildContext context, ChatAction action,{MediaItem? mediaItem}){
    launchVideo(context, action,mediaItem);
  }

  Future<void> executeAction(BuildContext context, ChatAction action,{MediaItem? mediaItem}) {
    if (kDebugMode) {
      print("Executing ${action.actionType}");
    }

    String platform = "android";
    if (kIsWeb) {
      platform = "web";
    } else if (Platform.isIOS) {
      platform = "ios";
    }

    return authorizeDeeplink(platform, action,context)
        .then((authorizedAction) =>
        _executeAuthorizedAction(context, authorizedAction!,mediaItem: mediaItem))
        .catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast("Failed to fetch authorized action: "
              "${response?.statusCode}");
          break;
        default:
          print("Unknown error fetching or executing authorized deeplink");
      }
    });
  }

  Future _executeAuthorizedAction(BuildContext context, ChatAction action,{MediaItem? mediaItem}) async {
    try {
      if (kDebugMode) {
        print("Executing2 ${action.actionType}");

      }
      switch (action.actionType) {
        case ActionTypes.switchChannel:
          switchToChannel(action.actionID, action.actionTitle, action.response);
          break;
        case ActionTypes.switchLCN:
          sendSTBRemoteKey(action.actionID);
          break;
        case ActionTypes.setLanguages:
          setPreferredLanguages(action.actionID.split(","));
          break;
        case ActionTypes.viewDeeplink:
          viewDeeplink(context,action);
          break;
        case ActionTypes.displayMediaDetail:
          final mediaDetail = action.actionMeta.mediaDetail;
          viewMediaDetail(mediaDetail);
          break;
        case ActionTypes.viewDetail:
          List<String> typeAndID = ChatAction.getItemTypeAndItemID(action);
          viewDetail(context, typeAndID[0], typeAndID[1]);
          break;
        case ActionTypes.launchVideo:
          launchVideo(context, action,mediaItem);
          break;
        case ActionTypes.installApp:
          viewDeeplink(context,action);
          break;  
        case ActionTypes.viewURL:
          openURL(context, action.actionID);
          break;
        case ActionTypes.setMediaItemSeen:
          List<String> typeAndID = ChatAction.getItemTypeAndItemID(action);
          await toggleSeenState(
              context, action.response, typeAndID[0], typeAndID[1]);
          break;
        case ActionTypes.setMediaItemFavorite:
          List<String> typeAndID = ChatAction.getItemTypeAndItemID(action);
          await toggleFavoriteState(
              context, action.response, typeAndID[0], typeAndID[1]);
          break;
        case ActionTypes.setMediaItemWatchlist:
          List<String> typeAndID = ChatAction.getItemTypeAndItemID(action);
          await toggleWatchListState(
              context, action.response, typeAndID[0], typeAndID[1]);
          break;
        case ActionTypes.setMediaItemNotInterested:
          List<String> typeAndID = ChatAction.getItemTypeAndItemID(action);
          await toggleInterestState(
              context, action.response, typeAndID[0], typeAndID[1]);
          break;
        case ActionTypes.show360Image:
          show360Image(action.actionID);
          break;
        case ActionTypes.showPanorama:
          showPanorama(action.actionID);
          break;
        case ActionTypes.callServer:
          if (action.response.isNotEmpty) {
            showVannillaToast(context, action.response);
          }

          try {
            final responseAction = await getIt<SensyApi>()
                .performCallServer(action.actionID, action.actionTitle);
            if (responseAction != null) {
              // ignore: use_build_context_synchronously
              executeAction(context, responseAction);
            }
          } catch (e) {
            showVannillaToast(context, Constants.defaultErrorMessage);
          }

          break;
        case ActionTypes.launchScreen:
          if(action.actionID  == "PRIME_ACTIVATION") {
            getIt<AppRouter>().push(
                "/amazonSubscription", extra: action.actionMeta);
          }
          break;

        default:
      }
    }
    catch(e){
      print(e);
    }
  }

  switchToChannel(String channelID, String channelName, String speakText) {}

  sendSTBRemoteKey(String actionID) {}

  setPreferredLanguages(List<String> languages) {}

  viewDeeplink(BuildContext context, ChatAction chatAction) async {
    if (kIsWeb) {
      await _viewWebDeeplink(chatAction);
    } else if (Platform.isAndroid) {
      await _viewAndroidDeeplink(chatAction);
    } else if (Platform.isIOS) {
      await _viewIosDeeplink(chatAction);
    }
  }

  Future<ChatAction?> authorizeDeeplink(
      String platform, ChatAction chatAction, BuildContext context) async {
    if (!chatAction.requiresAuthorization()) return chatAction;

    final ChatAction authorizedAction;
    try {
      authorizedAction =
          await getIt<SensyApi>().authorizeAction(platform, chatAction);
    } catch (e) {
      switch (e.runtimeType) {
        case DioException:
          final response = (e as DioException).response;
          showVanillaToast(
              "Failed to authorize action: ${response?.statusCode}");
          return null;
        default:
          showVanillaToast("Failed to authorize action");
          return null;
      }
    }

    if (authorizedAction.requiresAuthorization()) {
      showVanillaToast("Failed to authorize action: Recursing");
      return null;
    }

    return authorizedAction;
  }

  _viewAndroidDeeplink(ChatAction chatAction) async {
    final String deeplink;
    if (chatAction.actionMeta.androidDeeplink.isNotEmpty) {
      deeplink = chatAction.actionMeta.androidDeeplink;
    } else {
      deeplink = chatAction.actionID;
    }

    const channel = MethodChannel("tv.dorplay.companion/deeplinks");

    try {
      await channel.invokeMethod('viewDeeplink', <String, String>{
        "deeplink": deeplink,
        "packageName": chatAction.actionMeta.packageNamePhone,
      });
    } on PlatformException catch (e) {
      showVanillaToast(e.message ?? "Error launching deeplink");
      return;
    } on MissingPluginException catch (e) {
      showVanillaToast(e.message ?? "Error launching deeplink");
      return;
    }
  }

  _viewIosDeeplink(ChatAction chatAction) async {
    final String deeplink;
    if (chatAction.actionMeta.iosDeeplink.isNotEmpty) {
      deeplink = chatAction.actionMeta.iosDeeplink;
    } else {
      deeplink = chatAction.actionID;
    }

    final Uri uri = Uri.parse(deeplink);

    var mode = deeplink.contains("http") && !deeplink.contains("shemaroo")
        ? LaunchMode.externalNonBrowserApplication
        : LaunchMode.externalApplication;
    if (!await launchUrl(uri, mode: mode)) {
      String appStoreId = chatAction.actionMeta.appStoreId;
      String appStoreDeeplink = "https://apps.apple.com/app/id$appStoreId";
      final Uri appStoreUri = Uri.parse(appStoreDeeplink);
      launchUrl(appStoreUri);
    }
  }

  _viewWebDeeplink(ChatAction chatAction) async {
    final String deeplink;

    deeplink = chatAction.actionID;
    final Uri uri = Uri.parse(deeplink);
    await launchUrl(uri);
  }

  viewMediaDetail(MediaDetail mediaDetail) {}

  viewDetail(BuildContext context, String itemType, String itemID) {
    context.push("/detail/$itemType/${MediaItem.getURLSafeItemID(itemID)}");
  }

  launchVideo(BuildContext context, ChatAction action, MediaItem? mediaItem) {
    print("action id is empty or not ${action.actionID.isEmpty}");
    if (action.actionID.isEmpty) return;
    Map data = {"action" : action,'mediaItem' : mediaItem};
    context.push('/video', extra: data);
  }

  openURL(BuildContext context, String url) async {
    final Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (e) {
      showVanillaToast('Could not launch URL!');
      return;
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      showVanillaToast('Could not launch URL!');
    }
  }

  show360Image(String image360) {}

  showPanorama(String panorama) {}

  toggleFavoriteState(BuildContext context, String response, String itemType,
      String itemID) async {
    await getIt<UserInterestsChangeNotifier>().toggleFavorite(itemType, itemID);
  }

  toggleWatchListState(BuildContext context, String response, String itemType,
      String itemID) async {
    await getIt<UserInterestsChangeNotifier>()
        .toggleWatchlist(itemType, itemID);
  }

  toggleSeenState(BuildContext context, String response, String itemType,
      String itemID) async {
    await getIt<UserInterestsChangeNotifier>().toggleSeen(itemType, itemID);
  }

  toggleInterestState(BuildContext context, String response, String itemType,
      String itemID) async {
    await getIt<UserInterestsChangeNotifier>()
        .toggleNotInterested(itemType, itemID);
  }
}
