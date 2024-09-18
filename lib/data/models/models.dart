// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dor_companion/data/models/user_account.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../injection/injection.dart';
import '../../sdk_action_manager.dart' as sdk;
import '../../sdk_action_manager.dart';

part 'models.g.dart';

@JsonSerializable()
class MobileNumber {
  @JsonKey(name: 'phone_country_code', defaultValue: "")
  final String countryCode;
  @JsonKey(name: 'phone_number', defaultValue: "")
  final String number;
  final String otp;
  final String name;

  const MobileNumber({
    required this.countryCode,
    required this.number,
    this.name = "",
    this.otp = "",
  });

  Map<String, dynamic> toJson() => _$MobileNumberToJson(this);


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MobileNumber &&
        other.countryCode == countryCode &&
        other.number == number &&
        other.otp == otp &&
        other.name == name;
  }
  @override
  int get hashCode {
    return countryCode.hashCode ^
    number.hashCode ^
    otp.hashCode ^
    name.hashCode;
  }

}

Map<String, dynamic> serializeMobileNumber(MobileNumber object) =>
    object.toJson();

@JsonSerializable()
class AccessToken {
  @JsonKey(name: 'access', defaultValue: "")
  final String token;
  @JsonKey(name: 'token_type', defaultValue: "")
  final String tokenType;
  @JsonKey(name: 'qr_url', defaultValue: "")
  final String qrUrl;
  @JsonKey(name: 'profiles_exist', defaultValue: true)
  final bool profilesExist;

  const AccessToken({
    required this.token,
    required this.tokenType,
    required this.qrUrl,
    required this.profilesExist,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenFromJson(json);

  @override
  String toString() {
    return "$tokenType $token";
  }
}

AccessToken deserializeAccessToken(Map<String, dynamic> json) =>
    AccessToken.fromJson(json);

@JsonSerializable()
class Profile {
  final int id;
  @JsonKey(name: "customer_id", defaultValue: -1)
  final int customerId;
  @JsonKey(name: "facade_id", defaultValue: -1)
  final int facadeId;
  @JsonKey(name: "facade_token", defaultValue: "")
  final String token;
  @JsonKey(defaultValue: "")
  String name;
  @JsonKey(name: "is_personalized", defaultValue: false)
  final bool isPersonalized;
  @JsonKey(name: "is_restricted", defaultValue: true)
  bool isRestricted;
  @JsonKey(name: "parent_facade_id")
  final int? parentFacadeId;
  @JsonKey(defaultValue: "")
  final String label;

  Profile({
    required this.id,
    required this.customerId,
    required this.facadeId,
    required this.token,
    required this.name,
    required this.isPersonalized,
    required this.isRestricted,
    required this.parentFacadeId,
    required this.label,
  });

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  @override
  String toString() {
    return "Profile ID $id, Customer ID $customerId, FacadeID $facadeId,"
        " Is Personalized $isPersonalized, Is Restricted $isRestricted";
  }
}

Profile deserializeProfile(Map<String, dynamic> json) => Profile.fromJson(json);

List<Profile> deserializeProfileList(List<Map<String, dynamic>> json) =>
    json.map((e) => Profile.fromJson(e)).toList();

// @JsonSerializable()
// class SubscriptionPrice {
//   @JsonKey(name: "id_slug")
//   final String idSlug;
//   final double price;
//   @JsonKey(name: "id")
//   final int id;
//   @JsonKey(name: "currency_code")
//   final String currencyCode;
//   @JsonKey(name: "display_currency")
//   final String displayCurrency;
//   @JsonKey(name: "validity_mode")
//   final int validityMode;
//   @JsonKey(name: "validity_value")
//   final int validityValue;
//   @JsonKey(name: "validity_unit")
//   final int validityUnit;
//   @JsonKey(name: "display_validity")
//   final String displayValidity;
//   @JsonKey(name: "validity_devices_tv")
//   final int tvDevicesLimit;
//   @JsonKey(name: "validity_devices_mobile")
//   final int mobileDevicesLimit;
//
//   const SubscriptionPrice({
//     this.idSlug = "",
//     this.id = 0,
//     this.price = 0,
//     this.currencyCode = "",
//     this.displayCurrency = "",
//     this.validityMode = 0,
//     this.validityValue = 0,
//     this.validityUnit = 0,
//     this.displayValidity = "",
//     this.tvDevicesLimit = 0,
//     this.mobileDevicesLimit = 0,
//   });
//
//   factory SubscriptionPrice.fromJson(Map<String, dynamic> json) =>
//       _$SubscriptionPriceFromJson(json);
// }
//
// SubscriptionPrice deserializeSubscriptionPrice(Map<String, dynamic> json) =>
//     SubscriptionPrice.fromJson(json);

// @JsonSerializable()
// class SubscriptionPlan {
//   final int id;
//   @JsonKey(name: "admin_title", defaultValue: "")
//   final String adminTitle;
//   @JsonKey(name: "apps", defaultValue: [])
//   final List<Apps>? apps;
//   @JsonKey(name: "id_slug", defaultValue: "")
//   final String idSlug;
//   @JsonKey(name: "default_currency_code", defaultValue: "")
//   final String defaultCurrencyCode;
//   final List<SubscriptionPrice> price_points;
//   final SubscriptionPrice price;
//   @JsonKey(name: "display_title", defaultValue: "")
//   final String displayTitle;
//   @JsonKey(name: "display_description", defaultValue: "")
//   final String displayDescription;
//   @JsonKey(name: "app_tags", defaultValue: [])
//   final List<String> appTags;
//   @JsonKey(name: "media_detail")
//   final MediaDetail mediaDetail;
//   @JsonKey(name: "image_url", defaultValue: "")
//   final String planImage;
//
//   const SubscriptionPlan(
//       {required this.id,
//       required this.adminTitle,
//       required this.apps,
//       required this.idSlug,
//       required this.defaultCurrencyCode,
//       this.price = const SubscriptionPrice(),
//       required this.displayTitle,
//       required this.displayDescription,
//       required this.appTags,
//       required this.price_points,
//       this.mediaDetail = const MediaDetail(),
//       required this.planImage});
//
//   factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
//       _$SubscriptionPlanFromJson(json);
// }

// SubscriptionPlan deserializeSubscriptionPlan(Map<String, dynamic> json) =>
//     SubscriptionPlan.fromJson(json);
//
// List<SubscriptionPlan> deserializeSubscriptionPlanList(
//         List<Map<String, dynamic>> json) =>
//     json.map((e) => SubscriptionPlan.fromJson(e)).toList();

@JsonSerializable()
class Apps {
  @JsonKey(name: "image_url", defaultValue: "")
  String imageUrl;
  @JsonKey(name: "id_slug", defaultValue: "")
  String idSlug;
  int id;

  Apps({required this.imageUrl, required this.idSlug, required this.id});

  Map<String, dynamic> toJson() => _$AppsToJson(this);

  factory Apps.fromJson(Map<String, dynamic> json) => _$AppsFromJson(json);
}

// @JsonSerializable()
// class SubscribedPlan extends Equatable {
//   final int id;
//   @JsonKey(name: "plan_id")
//   final int planId;
//   @JsonKey(name: "starts_at", defaultValue: "")
//   final String startsAt;
//   @JsonKey(name: "ends_at", defaultValue: "")
//   final String endsAt;
//   @JsonKey(name: "message", defaultValue: "")
//   final String message;
//
//   const SubscribedPlan(
//       {required this.id,
//       required this.planId,
//       required this.startsAt,
//       required this.endsAt,
//       required this.message});
//
//   factory SubscribedPlan.fromJson(Map<String, dynamic> json) =>
//       _$SubscribedPlanFromJson(json);
//
//   @override
//   List<Object?> get props => [id, planId, startsAt, endsAt, message];
//
//   @override
//   bool get stringify => true;
// }
//
// SubscribedPlan deserializeSubscribedPlan(Map<String, dynamic> json) =>
//     SubscribedPlan.fromJson(json);
//
// List<SubscribedPlan> deserializeSubscribedPlanList(
//         List<Map<String, dynamic>> json) =>
//     json.map((e) => SubscribedPlan.fromJson(e)).toList();

@JsonSerializable()
class CustomerName {
  @JsonKey(name: "first_name", defaultValue: "")
  final String firstName;
  @JsonKey(name: "last_name", defaultValue: "")
  final String lastName;

  CustomerName({
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => _$CustomerNameToJson(this);
}

Map<String, dynamic> serializeCustomerName(CustomerName object) =>
    object.toJson();

@JsonSerializable()
class Customer {
  @JsonKey(name: "phone_country_code", defaultValue: "")
  final String phoneCountryCode;
  @JsonKey(name: "phone_number", defaultValue: "")
  final String phoneNumber;
  @JsonKey(name: "mobile_number", defaultValue: "")
  final String mobileNumber;
  @JsonKey(defaultValue: [])
  final List<Profile> profiles;
  // @JsonKey(name: "active_plans", defaultValue: [])
  // final List<SubscribedPlan> activePlans;
  @JsonKey(name: "crm_url", defaultValue: "")
  final String crmUrl;
  @JsonKey(name: "sms_contact_id", defaultValue: "")
  final String sms_contact_id;
  @JsonKey(name: "sms_access_token", defaultValue: "")
  final String sms_access_token;

  Customer({
    required this.phoneCountryCode,
    required this.phoneNumber,
    required this.mobileNumber,
    required this.profiles,
    // required this.activePlans,
    required this.crmUrl,
    required this.sms_contact_id,
    required this.sms_access_token,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  //
  // @override
  // String toString() {
  //   return "Customer mobile number $mobileNumber with "
  //       "${profiles.length} profiles and ${activePlans.length} active plans";
  // }
}

Customer deserializeCustomer(Map<String, dynamic> json) =>
    Customer.fromJson(json);

@JsonSerializable()
class ClientToken {
  @JsonKey(name: "client_token")
  final String clientToken;

  ClientToken({
    required this.clientToken,
  });
  Map<String, dynamic> toJson() => _$ClientTokenToJson(this);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClientToken &&
        other.clientToken == clientToken;
  }

  @override
  int get hashCode {
    return clientToken.hashCode;
  }
  factory ClientToken.fromJson(Map<String, dynamic> json) =>
      _$ClientTokenFromJson(json);
}

ClientToken deserializeClientToken(Map<String, dynamic> json) =>
    ClientToken.fromJson(json);

@JsonSerializable()
class DisplayConfig {
  static const int rowTypeRegular = 1;
  static const int rowTypePersonalize = 2;

  @JsonKey(defaultValue: 160)
  final double height;
  @JsonKey(defaultValue: 90)
  final double width;
  @JsonKey(name: "row_type")
  final int rowType;

  const DisplayConfig({
    required this.height,
    required this.width,
    this.rowType = DisplayConfig.rowTypeRegular,
  });

  Map<String, dynamic> toJson() => _$DisplayConfigToJson(this);

  factory DisplayConfig.fromJson(Map<String, dynamic> json) =>
      _$DisplayConfigFromJson(json);
}

Map<String, dynamic> serializeDisplayConfig(DisplayConfig object) =>
    object.toJson();

DisplayConfig deserializeDisplayConfig(Map<String, dynamic> json) =>
    DisplayConfig.fromJson(json);

@JsonSerializable()
class ChatActionMeta {
  static const String authRequired = "required";

  @JsonKey(name: 'media_detail')
  final MediaDetail mediaDetail;
  @JsonKey(name: 'package_name')
  final String packageName;
  @JsonKey(name: 'package_name_phone')
  final String packageNamePhone;
  @JsonKey(name: 'app_store_id')
  final String appStoreId;
  final String authorization;
  @JsonKey(name: 'deeplink_android')
  final String androidDeeplink;
  @JsonKey(name: 'deeplink_ios')
  final String iosDeeplink;
  @JsonKey(name: 'deeplink_contentid')
  final String deeplinkContentId;
  @JsonKey(name: 'activation_url')
  final String activationUrl;
  bool get isAuthorizationRequired => authorization == authRequired;

  const ChatActionMeta({
    this.mediaDetail = const MediaDetail(),
    this.packageName = "",
    this.packageNamePhone = "",
    this.appStoreId = "",
    this.authorization = "",
    this.androidDeeplink = "",
    this.iosDeeplink = "",
    this.deeplinkContentId = "",
    this.activationUrl = "",
  });

  Map<String, dynamic> toJson() => _$ChatActionMetaToJson(this);

  factory ChatActionMeta.fromJson(Map<String, dynamic> json) =>
      _$ChatActionMetaFromJson(json);
}

Map<String, dynamic> serializeChatActionMeta(ChatActionMeta object) =>
    object.toJson();

ChatActionMeta deserializeChatActionMeta(Map<String, dynamic> json) =>
    ChatActionMeta.fromJson(json);

@JsonSerializable()
class ChatAction {
  @JsonKey(name: 'action_id')
  final String actionID;
  @JsonKey(name: 'action_title')
  final String actionTitle;
  @JsonKey(name: 'action_type')
  final String actionType;
  final String response;
  @JsonKey(name: 'action_meta')
  final ChatActionMeta actionMeta;

  const ChatAction({
    this.actionID = "",
    this.actionTitle = "",
    this.actionType = "",
    this.response = "",
    this.actionMeta = const ChatActionMeta(),
  });

  Map<String, dynamic> toJson() => _$ChatActionToJson(this);

  factory ChatAction.fromJson(Map<String, dynamic> json) =>
      _$ChatActionFromJson(json);

  static String getActionFormattedItemId(String itemType, String itemId) {
    String cleanId = itemId;
    if (itemType == "ott" && itemId.contains("-") || itemId.contains(":")) {
      cleanId = itemId.replaceFirst("-", ":");
      if (!cleanId.startsWith("#")) {
        cleanId = "#$cleanId";
      }
    }
    return cleanId;
  }

  static List<String> getItemTypeAndItemID(ChatAction action) {
    int idx = action.actionID.indexOf(":");
    String itemType = action.actionID.substring(0, idx).trim();
    String itemID = action.actionID.substring(idx + 1).trim();
    if (itemType == "ott" && itemID.contains("-") || itemID.contains(":")) {
      itemID = itemID.replaceFirst("-", ":");
      if (!itemID.startsWith("#")) {
        itemID = "#$itemID";
      }
    }
    return [itemType, itemID];
  }

  bool requiresAuthorization() {
    return actionMeta.isAuthorizationRequired;
  }

  executeAction(BuildContext context, {MediaItem? mediaItem}) async {
    if (kDebugMode) {
      print("action type $actionType");
    }
    if (mediaItem != null &&
        (actionType == ActionTypes.viewDetail && mediaItem.source != "Distro")) {
            // (mediaItem.isLiveTVItem && !mediaItem.isShowPlayingLive()))) {
      // getIt<UserAccount>().setOnHome(true);
      List<String> typeAndID = getItemTypeAndItemID(this);
      final tempMediaItem = MediaItem.forExecute(mediaItem);
      final header = MediaHeader(mediaItem: tempMediaItem);
      debugPrint(
          'Checking route: ${"/detail/${typeAndID[0]}/${MediaItem.getURLSafeItemID(typeAndID[1])}"}');
      context.push(
          "/detail/${typeAndID[0]}/${MediaItem.getURLSafeItemID(typeAndID[1])}",
         extra: header);
      return;
    }

    //context.push("/subscriptions");
    if(mediaItem != null && mediaItem.isLiveTVItem && mediaItem.source == "Distro"){
      await sdk.SDKActionsManager().executeLiveTV(context, this,mediaItem: mediaItem);
    }else{
      await sdk.SDKActionsManager().executeAction(context, this,mediaItem: mediaItem);
    }
  }
}

Map<String, dynamic> serializeChatAction(ChatAction object) => object.toJson();

ChatAction deserializeChatAction(Map<String, dynamic> json) =>
    ChatAction.fromJson(json);

@JsonSerializable()
class MediaAction {
  @JsonKey(defaultValue: "")
  final String title;
  @JsonKey(defaultValue: "")
  final String image;
  @JsonKey(defaultValue: "")
  final String icon;
  @JsonKey(name: 'chat_action')
  final ChatAction chatAction;

  const MediaAction({
    required this.title,
    required this.image,
    required this.icon,
    this.chatAction = const ChatAction(),
  });

  Map<String, dynamic> toJson() => _$MediaActionToJson(this);

  factory MediaAction.fromJson(Map<String, dynamic> json) =>
      _$MediaActionFromJson(json);
}

Map<String, dynamic> serializeMediaAction(MediaAction object) =>
    object.toJson();

List<Map<String, dynamic>> serializeMediaActionList(
        List<MediaAction> objects) =>
    objects.map((e) => e.toJson()).toList();

MediaAction deserializeMediaAction(Map<String, dynamic> json) =>
    MediaAction.fromJson(json);

List<MediaAction> deserializeMediaActionList(List<Map<String, dynamic>> json) =>
    json.map((e) => MediaAction.fromJson(e)).toList();

@JsonSerializable()
class Schedule {
  @JsonKey(defaultValue: 0)
  final int channelId;
  @JsonKey(defaultValue: '')
  final String start;

  @JsonKey(defaultValue: 0)
  final int duration;

  Schedule({required this.start, required this.duration, required this.channelId});

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}

Schedule deserializeSchedule(Map<String, dynamic> json) =>
    Schedule.fromJson(json);

@JsonSerializable()
class MediaItem {
  final List<MediaAction> actions;
  final String description;
  @JsonKey(name: 'icon_ids')
  final List<int> iconIDs;
  final String image;
  @JsonKey(name: 'image_hd')
  final String imageHD;
  @JsonKey(name: 'item_id')
  final String itemID;
  @JsonKey(name: 'item_type')
  final String itemType;
  final String package;
  final String subtitle;
  final String title;
  String video;
  String source;
  bool isLiveTVItem = false;
  bool isHomeScreen = true;
  bool isAppForYou = false;
  bool? selected = false;
  @JsonKey(name: 'schedule')
  final Schedule? schedule;

  MediaItem({this.actions = const [],
    this.description = "",
    this.iconIDs = const [],
    this.image = "",
    this.imageHD = "",
    this.itemID = "",
    this.itemType = "",
    this.package = "",
    this.subtitle = "",
    this.title = "",
    this.video = "",
    this.source = "",
    this.schedule,
    this.isLiveTVItem = false,
    this.isAppForYou = false,
    this.selected = false});

  MediaItem.forExecute(MediaItem oldItem)
      : this(
    actions: oldItem.actions.length > 1 ? oldItem.actions.sublist(1) : [],
    description: oldItem.description,
    iconIDs: oldItem.iconIDs,
    image: oldItem.image,
    imageHD: oldItem.imageHD,
    itemID: oldItem.itemID,
    itemType: oldItem.itemType,
    package: oldItem.package,
    subtitle: oldItem.subtitle,
    title: oldItem.title,
    video: oldItem.video,
    source: oldItem.source,
    isLiveTVItem: oldItem.isLiveTVItem,
    isAppForYou: oldItem.isAppForYou,
  );

  bool isShowPlayingLive() {
    if (schedule == null) return false;
    final showStartTime = DateTime.parse(schedule!.start).toLocal();
    final showEndTime =
    showStartTime.add(Duration(minutes: schedule!.duration));
    final now = DateTime.now();
    debugPrint('showStartTime : $showStartTime, showEndTime : $showEndTime');
    return now.isAfter(showStartTime) && now.isBefore(showEndTime);
  }

  String get showStatus {
    return showDuration() == "Playing Now" ? "Playing Now" : showDuration();
  }

  String isShowPlayingLiveTime() {
    if (schedule == null) return "";
    final showStartTime = DateTime.parse(schedule!.start).toLocal();
    final showEndTime =
    showStartTime.add(Duration(minutes: schedule!.duration));
    final now = DateTime.now();
    debugPrint('showStartTime : $showStartTime, showEndTime : $showEndTime');
    return showStartTime.toString();
  }

  String showDuration() {
    if (schedule == null) return "";
    final showStartTime = DateTime.parse(schedule!.start).toLocal();
    final showEndTime = showStartTime.add(Duration(minutes: schedule!.duration));
    final now = DateTime.now();

    final timeUntilShowStart = showStartTime.difference(now);

    return "${liveTvTimeFormat(showStartTime)} - ${liveTvTimeFormat(showEndTime)}";

    if (now.isAfter(showEndTime)) {
      final timeLeft = showEndTime.difference(now);

      if (timeLeft.isNegative || timeLeft.inMinutes == 0) {
        return "Playing Now";
      } else {

        return formatTime(timeLeft);
      }
    } else {

      return formatTime(timeUntilShowStart);
    }
  }

  String liveTvTimeFormat(DateTime time){
    if(time.minute == 0){
      return DateFormat('hh a').format(time).toLowerCase();
    }
    return DateFormat('hh:mm a').format(time).toLowerCase();
  }


  String formatTime(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    String hoursString = hours > 0? "$hours${"h"}" : "";

    String minutesString = "$minutes${"m"}";
    return "$hoursString$minutesString";
  }

  double get showProgress {
    if (schedule == null ||!isShowPlayingLive()) return 0.0;
    final now = DateTime.now();
    final showEndTime = DateTime.parse(schedule!.start).toLocal().add(Duration(minutes: schedule!.duration));
    final progress = now.difference(DateTime.parse(schedule!.start).toLocal()).inMinutes / schedule!.duration;
    return progress > 1? 1.0 : progress;
  }


  Map<String, dynamic> toJson() => _$MediaItemToJson(this);

  factory MediaItem.fromJson(Map<String, dynamic> json) {

    if (!json.containsKey('title')) {
      throw const FormatException("Missing 'title' key in JSON");
    }
  return _$MediaItemFromJson(json);
}


  static getURLSafeItemID(String itemID) {
    return itemID.replaceAll("#", "").replaceFirst(":", "-");
  }

  static String getItemIDFromURLParam(String urlParamItemID) {
    if (urlParamItemID.contains(":")) {
      return ("#$urlParamItemID").replaceFirst("-", ":");
    }
    return urlParamItemID;
  }
}

Map<String, dynamic> serializeMediaItem(MediaItem object) => object.toJson();

List<Map<String, dynamic>> serializeMediaItemList(List<MediaItem> objects) =>
    objects.map((e) => e.toJson()).toList();

MediaItem deserializeMediaItem(Map<String, dynamic> json) =>
    MediaItem.fromJson(json);

List<MediaItem> deserializeMediaItemList(List<Map<String, dynamic>> json) =>
    json.map((e) => MediaItem.fromJson(e)).toList();

@JsonSerializable()
class MediaItemIcon {
  final int id;
  @JsonKey(defaultValue: "")
  final String title;
  @JsonKey(defaultValue: "")
  final String url;

  const MediaItemIcon({
    required this.id,
    required this.title,
    required this.url,
  });

  Map<String, dynamic> toJson() => _$MediaItemIconToJson(this);

  factory MediaItemIcon.fromJson(Map<String, dynamic> json) =>
      _$MediaItemIconFromJson(json);
}

Map<String, dynamic> serializeMediaItemIcon(MediaItemIcon object) =>
    object.toJson();

List<Map<String, dynamic>> serializeMediaItemIconList(
        List<MediaItemIcon> objects) =>
    objects.map((e) => e.toJson()).toList();

MediaItemIcon deserializeMediaItemIcon(Map<String, dynamic> json) =>
    MediaItemIcon.fromJson(json);

List<MediaItemIcon> deserializeMediaItemIconList(
        List<Map<String, dynamic>> json) =>
    json.map((e) => MediaItemIcon.fromJson(e)).toList();

@JsonSerializable()
class MediaRow {
  @JsonKey(name: 'content_type', defaultValue: -1)
  final int contentType;
  @JsonKey(name: 'display_config')
  final DisplayConfig displayConfig;
  @JsonKey(name: 'media_item_groups', defaultValue: [])
  final List<Map> mediaItemGroups;
  @JsonKey(name: 'media_item_icons', defaultValue: [])
  final List<MediaItemIcon> mediaItemIcons;
  @JsonKey(name: 'media_items', defaultValue: [])
  final List<MediaItem> mediaItems;
  @JsonKey(defaultValue: "")
  String title;

  String? rowImage;
  String? rowTime;

  @JsonKey(includeFromJson: false, includeToJson: false)
  late final Map<int, String?> iconURLLookup;

  MediaRow({
    required this.contentType,
    this.displayConfig = const DisplayConfig(height: 0, width: 0),
    required this.mediaItemGroups,
    required this.mediaItemIcons,
    required this.mediaItems,
    required this.title,
  }) {
    Map<int, String> lookup = {};
    final tempIcons = mediaItemIcons;
    for (var icon in tempIcons) {
      lookup[icon.id] = icon.url;
    }
    iconURLLookup = lookup;
  }

  getIconURL(int iconID) {
    return iconURLLookup[iconID] ?? "";
  }

  Map<String, dynamic> toJson() => _$MediaRowToJson(this);

  factory MediaRow.fromJson(Map<String, dynamic> json) =>
      _$MediaRowFromJson(json);
}

Map<String, dynamic> serializeMediaRow(MediaRow object) => object.toJson();

List<Map<String, dynamic>> serializeMediaRowList(List<MediaRow> objects) =>
    objects.map((e) => e.toJson()).toList();

MediaRow deserializeMediaRow(Map<String, dynamic> json) =>
    MediaRow.fromJson(json);

List<MediaRow> deserializeMediaRowList(List<Map<String, dynamic>> json) =>
    json.map((e) => MediaRow.fromJson(e)).toList();

@JsonSerializable()
class MediaHeaderMeta {
  @JsonKey(name: 'page_no')
  final int pageNo;
  @JsonKey(name: 'total_pages')
  final int totalPages;

  const MediaHeaderMeta({
    this.pageNo = 0,
    this.totalPages = 0,
  });

  Map<String, dynamic> toJson() => _$MediaHeaderMetaToJson(this);

  factory MediaHeaderMeta.fromJson(Map<String, dynamic> json) =>
      _$MediaHeaderMetaFromJson(json);
}

Map<String, dynamic> serializeMediaHeaderMeta(MediaHeaderMeta object) =>
    object.toJson();

MediaHeaderMeta deserializeMediaHeaderMeta(Map<String, dynamic> json) =>
    MediaHeaderMeta.fromJson(json);

@JsonSerializable()
class MediaHeader {
  final String description;
  final List<Map<String, dynamic>> images;
  @JsonKey(name: 'item')
  MediaItem? mediaItem;
  final MediaHeaderMeta meta;

  MediaHeader({
    this.description = "",
    this.images = const [],
    this.mediaItem,
    this.meta = const MediaHeaderMeta(),
  });

  Map<String, dynamic> toJson() => _$MediaHeaderToJson(this);

  factory MediaHeader.fromJson(Map<String, dynamic> json) =>
      _$MediaHeaderFromJson(json);
}

Map<String, dynamic> serializeMediaHeader(MediaHeader object) =>
    object.toJson();

MediaHeader deserializeMediaHeader(Map<String, dynamic> json) =>
    MediaHeader.fromJson(json);

@JsonSerializable()
class MediaDetail {
  @JsonKey(name: 'media_header')
  final MediaHeader? mediaHeader;
  @JsonKey(name: 'media_rows')
  final List<MediaRow> mediaRows;

  const MediaDetail({
    this.mediaHeader,
    this.mediaRows = const [],
  });

  Map<String, dynamic> toJson() => _$MediaDetailToJson(this);

  factory MediaDetail.fromJson(Map<String, dynamic> json) =>
      _$MediaDetailFromJson(json);
}

Map<String, dynamic> serializeMediaDetail(MediaDetail object) =>
    object.toJson();

MediaDetail deserializeMediaDetail(Map<String, dynamic> json) =>
    MediaDetail.fromJson(json);

@JsonSerializable()
class StandardPromotionResult {
  @JsonKey(name: 'standard_promotions', defaultValue: [])
  final List<StandardPromotion> standardPromotions;

  const StandardPromotionResult({required this.standardPromotions});

  factory StandardPromotionResult.fromJson(Map<String, dynamic> json) =>
      _$StandardPromotionResultFromJson(json);
}

StandardPromotionResult deserializeStandardPromotionResult(
        Map<String, dynamic> json) =>
    StandardPromotionResult.fromJson(json);

@JsonSerializable()
class StandardPromotion {
  @JsonKey(defaultValue: "")
  final String image;
  @JsonKey(name: 'image_title', defaultValue: "")
  final String imageTitle;
  final ChatAction action;

  const StandardPromotion({
    required this.image,
    required this.imageTitle,
    this.action = const ChatAction(),
  });

  factory StandardPromotion.fromJson(Map<String, dynamic> json) =>
      _$StandardPromotionFromJson(json);
}

StandardPromotion deserializeStandardPromotion(Map<String, dynamic> json) =>
    StandardPromotion.fromJson(json);

List<StandardPromotion> deserializeStandardPromotionList(
        List<Map<String, dynamic>> json) =>
    json.map((e) => StandardPromotion.fromJson(e)).toList();

@JsonSerializable()
class SearchSuggestionResult {
  @JsonKey(defaultValue: "")
  final String query;
  @JsonKey(defaultValue: [])
  final List<SearchSuggestion> results;

  SearchSuggestionResult({
    required this.query,
    required this.results,
  });

  factory SearchSuggestionResult.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionResultFromJson(json);
}

SearchSuggestionResult deserializeSearchSuggestionResult(
        Map<String, dynamic> json) =>
    SearchSuggestionResult.fromJson(json);

@JsonSerializable()
class SearchSuggestion {
  @JsonKey(defaultValue: "")
  final String title;
  final bool fromHistory;

  const SearchSuggestion(
    this.title, {
    this.fromHistory = false,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionFromJson(json);
}

SearchSuggestion deserializeSearchSuggestion(Map<String, dynamic> json) =>
    SearchSuggestion.fromJson(json);

List<SearchSuggestion> deserializeSearchSuggestionList(
        List<Map<String, dynamic>> json) =>
    json.map((e) => SearchSuggestion.fromJson(e)).toList();

@JsonSerializable()
class MediaItemListElement {
  @JsonKey(name: 'item_type', defaultValue: "")
  final String itemType;
  @JsonKey(name: 'item_ids', defaultValue: [])
  final List<String> itemIds;

  const MediaItemListElement({
    required this.itemType,
    required this.itemIds,
  });
  @override
  int get hashCode =>
      itemType.hashCode ^
      itemIds.hashCode;


  factory MediaItemListElement.fromJson(Map<String, dynamic> json) =>
      _$MediaItemListElementFromJson(json);
  Map<String, dynamic> toJson() {
    return {
      'item_type': itemType,
      'item_ids': itemIds,
    };
  }
}

MediaItemListElement deserializeMediaItemListElement(
        Map<String, dynamic> json) =>
    MediaItemListElement.fromJson(json);

List<MediaItemListElement> deserializeMediaItemListElementList(
        List<Map<String, dynamic>> json) =>
    json.map((e) => MediaItemListElement.fromJson(e)).toList();

@JsonSerializable()
class UserInterests {
  @JsonKey(defaultValue: [])
  final List<MediaItemListElement> favorites;
  @JsonKey(defaultValue: [])
  final List<MediaItemListElement> seen;
  @JsonKey(defaultValue: [])
  final List<MediaItemListElement> watchlist;
  @JsonKey(name: 'not_interested_list', defaultValue: [])
  final List<MediaItemListElement> notInterested;
  int get hashCode =>
      favorites.hashCode ^
      seen.hashCode ^
      watchlist.hashCode ^
      notInterested.hashCode;

  const UserInterests({
    required this.favorites,
    required this.seen,
    required this.watchlist,
    required this.notInterested,
  });
  Map<String, dynamic> toJson() {
    return {
      'favorites': favorites.map((item) => item.toJson()).toList(),
      'seen': seen.map((item) => item.toJson()).toList(),
      'watchlist': watchlist.map((item) => item.toJson()).toList(),
      'not_interested_list': notInterested.map((item) => item.toJson()).toList(),
    };
  }
  factory UserInterests.fromJson(Map<String, dynamic> json) =>
      _$UserInterestsFromJson(json);

}

UserInterests deserializeUserInterests(Map<String, dynamic> json) =>
    UserInterests.fromJson(json);

@JsonSerializable()
class UserInterestsResult {
  @JsonKey(name: 'results')
  final UserInterests userInterests;

  const UserInterestsResult({
    this.userInterests = const UserInterests(
      favorites: [],
      seen: [],
      watchlist: [],
      notInterested: [],
    ),
  });
  @override
  int get hashCode =>
      userInterests.favorites.hashCode ^
      userInterests.notInterested.hashCode ^
      userInterests.seen.hashCode ^
      userInterests.watchlist.hashCode;

  factory UserInterestsResult.fromJson(Map<String, dynamic> json) =>
      _$UserInterestsResultFromJson(json);
  Map<String, dynamic> toJson() => _$UserInterestsResultToJson(this);

}

UserInterestsResult deserializeUserInterestsResult(Map<String, dynamic> json) =>
    UserInterestsResult.fromJson(json);

@JsonSerializable()
class FavoriteLanguages {
  @JsonKey(defaultValue: [])
  final List<String> languages;

  const FavoriteLanguages({required this.languages});

  factory FavoriteLanguages.fromJson(Map<String, dynamic> json) =>
      _$FavoriteLanguagesFromJson(json);
}

FavoriteLanguages deserializeFavoriteLanguages(Map<String, dynamic> json) =>
    FavoriteLanguages.fromJson(json);

@JsonSerializable()
class TvDevice {
  final int id;
  @JsonKey(name: 'name', defaultValue: "")
  final String name;
  @JsonKey(name: 'serial_number', defaultValue: "")
  final String serialNumber;
  @JsonKey(name: 'pushy_token', defaultValue: "")
  final String pushyToken;

  const TvDevice({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.pushyToken,
  });

  factory TvDevice.fromJson(Map<String, dynamic> json) =>
      _$TvDeviceFromJson(json);

  @override
  String toString() {
    return "Name: $name ID: $id SN: $serialNumber Pushy Token: $pushyToken";
  }
}

TvDevice deserializeTvDevice(Map<String, dynamic> json) =>
    TvDevice.fromJson(json);

List<TvDevice> deserializeTvDeviceList(List<Map<String, dynamic>> json) =>
    json.map((e) => TvDevice.fromJson(e)).toList();

@JsonSerializable()
class GenreList {
  @JsonKey(defaultValue: [], name: 'result')
  final List<Genre> list;

  const GenreList({required this.list});

  factory GenreList.fromJson(Map<String, dynamic> json) =>
      _$GenreListFromJson(json);
}

GenreList deserializeGenreList(Map<String, dynamic> json) =>
    GenreList.fromJson(json);

@JsonSerializable()
class Genre {
  @JsonKey(defaultValue: '')
   String title;

  bool isSelected = false;

  Genre({required this.title, this.isSelected = false});

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}

Genre deserializeGenre(Map<String, dynamic> json) => Genre.fromJson(json);

@JsonSerializable()
class LanguageList {
  @JsonKey(defaultValue: [], name: 'result')
  final List<Language> list;

  const LanguageList({required this.list});

  factory LanguageList.fromJson(Map<String, dynamic> json) =>
      _$LanguageListFromJson(json);
}

LanguageList deserializeLanguageList(Map<String, dynamic> json) =>
    LanguageList.fromJson(json);

@JsonSerializable()
class Language {
  @JsonKey(defaultValue: '')
  final String title;

  bool isSelected = false;

  Language({required this.title,this.isSelected=false});

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);
}

Language deserializeLanguage(Map<String, dynamic> json) =>
    Language.fromJson(json);

@JsonSerializable()
class Channel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: 0,name: 'operator_channel_id')
  final int operatorChannelId;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String image;

  @JsonKey(defaultValue: '')
  final String genre;

  @JsonKey(defaultValue: '')
  final String language;

  @JsonKey(defaultValue: '')
  final String key;

  @JsonKey(defaultValue: '', name: 'feed_hls')
  final String feedHLS;

  @JsonKey(defaultValue: '', name: 'feed_deeplink')
  final String feedDeepLink;

  @JsonKey(defaultValue: '', name: 'slug')
  final String slug;

  @JsonKey(defaultValue: '', name: 'identifier')
  final String identifier;

  @JsonKey(defaultValue: '', name: 'deeplink_package')
  final String deeplinkPackage;

  @JsonKey(defaultValue: '', name: 'feed_deeplink_package_tv')
  final String feedDeeplinkPackageTv;

  @JsonKey(defaultValue: '', name: 'feed_deeplink_package_mobile')
  final String feedDeeplinkPackageMobile;

  @JsonKey(defaultValue: '', name: 'source')
  final String source;

  @JsonKey(defaultValue: false, name: 'is_active')
  final bool isActive;

  const Channel(
      {required this.id,
      required this.operatorChannelId,
      required this.name,
      required this.image,
      required this.genre,
      required this.language,
      required this.key,
      required this.feedHLS,
      required this.feedDeepLink,
      required this.source,
      required this.deeplinkPackage,
      required this.feedDeeplinkPackageMobile,
      required this.feedDeeplinkPackageTv,
      required this.identifier,
      required this.isActive,
      required this.slug});

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
}

Channel deserializeChannel(Map<String, dynamic> json) => Channel.fromJson(json);
List<Channel> deserializeChannelList(List<Map<String, dynamic>> json) =>
    json.map((e) => Channel.fromJson(e)).toList();

class GameData {
  final String id;
  final String title;
  final String image;
  final List<String> imagePreview;
  final String desktopUrl;
  final String mobileUrl;
  final Misc misc;

  GameData({
    required this.id,
    required this.title,
    required this.image,
    required this.imagePreview,
    required this.desktopUrl,
    required this.mobileUrl,
    required this.misc,
  });

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      id: json['data']['id'],
      title: json['data']['title'],
      image: json['data']['image'],
      imagePreview: List<String>.from(json['data']['image_preview'].map((x) => x)),
      desktopUrl: json['data']['desktopUrl'],
      mobileUrl: json['data']['mobileUrl'],
      misc: Misc.fromJson(json['data']['misc']),
    );
  }
}

class Misc {
  final List<String> keywords;
  final int ratingCritic;
  final int ratingUser;
  final List<dynamic> attributeCensorRating;
  final String synopsis;
  final List<String> lang;
  final String? description; // Updated to String?

  Misc({
    required this.keywords,
    required this.ratingCritic,
    required this.ratingUser,
    required this.attributeCensorRating,
    required this.synopsis,
    required this.lang,
    this.description, // Now accepts a String?
  });

  factory Misc.fromJson(Map<String, dynamic> json) {
    return Misc(
      keywords: List<String>.from(json['keywords'].map((x) => x)),
      ratingCritic: json['rating_critic'],
      ratingUser: json['rating_user'],
      attributeCensorRating: List<dynamic>.from(json['attribute_censor_rating'].map((x) => x)),
      synopsis: json['synopsis'],
      lang: List<String>.from(json['lang'].map((x) => x)),
      description: json['description']?? null, // Fallback to null if not present
    );
  }
}
