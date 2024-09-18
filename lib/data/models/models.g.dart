// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


Map<String, dynamic> _$MobileNumberToJson(MobileNumber instance) =>
    <String, dynamic>{
      'phone_country_code': instance.countryCode,
      'phone_number': instance.number,
      'otp': instance.otp,
      'name': instance.name,
    };

AccessToken _$AccessTokenFromJson(Map<String, dynamic> json) => AccessToken(
  token: json['access'] as String? ?? '',
  tokenType: json['token_type'] as String? ?? '',
  qrUrl: json['qr_url'] as String? ?? '',
  profilesExist: json['profiles_exist'] as bool? ?? true,
);


Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  id: json['id'] as int,
  customerId: json['customer_id'] as int? ?? -1,
  facadeId: json['facade_id'] as int? ?? -1,
  token: json['facade_token'] as String? ?? '',
  name: json['name'] as String? ?? '',
  isPersonalized: json['is_personalized'] as bool? ?? false,
  isRestricted: json['is_restricted'] as bool? ?? true,
  parentFacadeId: json['parent_facade_id'] as int?,
  label: json['label'] as String? ?? '',
);


// SubscriptionPrice _$SubscriptionPriceFromJson(Map<String, dynamic> json) =>
//     SubscriptionPrice(
//       idSlug: json['id_slug'] as String? ?? "",
//       id: json['id'] as int? ?? 0,
//       price: (json['price'] as num?)?.toDouble() ?? 0,
//       currencyCode: json['currency_code'] as String? ?? "",
//       displayCurrency: json['display_currency'] as String? ?? "",
//       validityMode: json['validity_mode'] as int? ?? 0,
//       validityValue: json['validity_value'] as int? ?? 0,
//       validityUnit: json['validity_unit'] as int? ?? 0,
//       displayValidity: json['display_validity'] as String? ?? "",
//       tvDevicesLimit: json['validity_devices_tv'] as int? ?? 0,
//       mobileDevicesLimit: json['validity_devices_mobile'] as int? ?? 0,
//     );
//
// Map<String, dynamic> _$SubscriptionPriceToJson(SubscriptionPrice instance) =>
//     <String, dynamic>{
//       'id_slug': instance.idSlug,
//       'price': instance.price,
//       'id': instance.id,
//       'currency_code': instance.currencyCode,
//       'display_currency': instance.displayCurrency,
//       'validity_mode': instance.validityMode,
//       'validity_value': instance.validityValue,
//       'validity_unit': instance.validityUnit,
//       'display_validity': instance.displayValidity,
//       'validity_devices_tv': instance.tvDevicesLimit,
//       'validity_devices_mobile': instance.mobileDevicesLimit,
//     };

// SubscriptionPlan _$SubscriptionPlanFromJson(Map<String, dynamic> json) =>
//     SubscriptionPlan(
//       id: json['id'] as int,
//       adminTitle: json['admin_title'] as String? ?? '',
//       apps: (json['apps'] as List<dynamic>?)
//               ?.map((e) => Apps.fromJson(e as Map<String, dynamic>))
//               .toList() ??
//           [],
//       idSlug: json['id_slug'] as String? ?? '',
//       defaultCurrencyCode: json['default_currency_code'] as String? ?? '',
//       price: json['price'] == null
//           ? const SubscriptionPrice()
//           : SubscriptionPrice.fromJson(json['price'] as Map<String, dynamic>),
//       displayTitle: json['display_title'] as String? ?? '',
//       displayDescription: json['display_description'] as String? ?? '',
//       appTags: (json['app_tags'] as List<dynamic>?)
//               ?.map((e) => e as String)
//               .toList() ??
//           [],
//       price_points: (json['price_points'] as List<dynamic>)
//           .map((e) => SubscriptionPrice.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       mediaDetail: json['media_detail'] == null
//           ? const MediaDetail()
//           : MediaDetail.fromJson(json['media_detail'] as Map<String, dynamic>),
//       planImage: json['image_url'] as String? ?? '',
//     );
//
// Map<String, dynamic> _$SubscriptionPlanToJson(SubscriptionPlan instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'admin_title': instance.adminTitle,
//       'apps': instance.apps,
//       'id_slug': instance.idSlug,
//       'default_currency_code': instance.defaultCurrencyCode,
//       'price_points': instance.price_points,
//       'price': instance.price,
//       'display_title': instance.displayTitle,
//       'display_description': instance.displayDescription,
//       'app_tags': instance.appTags,
//       'media_detail': instance.mediaDetail,
//       'image_url': instance.planImage,
//     };

Apps _$AppsFromJson(Map<String, dynamic> json) => Apps(
  imageUrl: json['image_url'] as String? ?? '',
  idSlug: json['id_slug'] as String? ?? '',
  id: json['id'] as int,
);

Map<String, dynamic> _$AppsToJson(Apps instance) => <String, dynamic>{
  'image_url': instance.imageUrl,
  'id_slug': instance.idSlug,
  'id': instance.id,
};

// SubscribedPlan _$SubscribedPlanFromJson(Map<String, dynamic> json) =>
//     SubscribedPlan(
//       id: json['id'] as int,
//       planId: json['plan_id'] as int,
//       startsAt: json['starts_at'] as String? ?? '',
//       endsAt: json['ends_at'] as String? ?? '',
//       message: json['message'] as String? ?? '',
//     );
//
// Map<String, dynamic> _$SubscribedPlanToJson(SubscribedPlan instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'plan_id': instance.planId,
//       'starts_at': instance.startsAt,
//       'ends_at': instance.endsAt,
//       'message': instance.message,
//     };


Map<String, dynamic> _$CustomerNameToJson(CustomerName instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  phoneCountryCode: json['phone_country_code'] as String? ?? '',
  phoneNumber: json['phone_number'] as String? ?? '',
  mobileNumber: json['mobile_number'] as String? ?? '',
  profiles: (json['profiles'] as List<dynamic>?)
      ?.map((e) => Profile.fromJson(e as Map<String, dynamic>))
      .toList() ??
      [],
  // activePlans: (json['active_plans'] as List<dynamic>?)
  //         ?.map((e) => SubscribedPlan.fromJson(e as Map<String, dynamic>))
  //         .toList() ??
  //     [],
  crmUrl: json['crm_url'] as String? ?? '',
  sms_contact_id: json['sms_contact_id'] as String? ?? '',
  sms_access_token: json['sms_access_token'] as String? ?? '',
);


ClientToken _$ClientTokenFromJson(Map<String, dynamic> json) => ClientToken(
  clientToken: json['client_token'] as String,
);

Map<String, dynamic> _$ClientTokenToJson(ClientToken instance) =>
    <String, dynamic>{
      'client_token': instance.clientToken,
    };

DisplayConfig _$DisplayConfigFromJson(Map<String, dynamic> json) =>
    DisplayConfig(
      height: (json['height'] as num?)?.toDouble() ?? 160,
      width: (json['width'] as num?)?.toDouble() ?? 90,
      rowType: json['row_type'] as int? ?? DisplayConfig.rowTypeRegular,
    );

Map<String, dynamic> _$DisplayConfigToJson(DisplayConfig instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'row_type': instance.rowType,
    };

ChatActionMeta _$ChatActionMetaFromJson(Map<String, dynamic> json) =>
    ChatActionMeta(
      mediaDetail: json['media_detail'] == null
          ? const MediaDetail()
          : MediaDetail.fromJson(json['media_detail'] as Map<String, dynamic>),
      packageName: json['package_name'] as String? ?? "",
      packageNamePhone: json['package_name_phone'] as String? ?? "",
      appStoreId: json['app_store_id'] as String? ?? "",
      authorization: json['authorization'] as String? ?? "",
      androidDeeplink: json['deeplink_android'] as String? ?? "",
      iosDeeplink: json['deeplink_ios'] as String? ?? "",
      deeplinkContentId: json['deeplink_contentid'] as String? ?? "",
      activationUrl: json['activation_url'] as String? ?? "",
    );

Map<String, dynamic> _$ChatActionMetaToJson(ChatActionMeta instance) =>
    <String, dynamic>{
      'media_detail': instance.mediaDetail,
      'package_name': instance.packageName,
      'package_name_phone': instance.packageNamePhone,
      'app_store_id': instance.appStoreId,
      'authorization': instance.authorization,
      'deeplink_android': instance.androidDeeplink,
      'deeplink_ios': instance.iosDeeplink,
      'deeplink_contentid': instance.deeplinkContentId,
      'activation_url': instance.activationUrl,
    };

ChatAction _$ChatActionFromJson(Map<String, dynamic> json) => ChatAction(
  actionID: json['action_id'] as String? ?? "",
  actionTitle: json['action_title'] as String? ?? "",
  actionType: json['action_type'] as String? ?? "",
  response: json['response'] as String? ?? "",
  actionMeta: json['action_meta'] == null
      ? const ChatActionMeta()
      : ChatActionMeta.fromJson(
      json['action_meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatActionToJson(ChatAction instance) =>
    <String, dynamic>{
      'action_id': instance.actionID,
      'action_title': instance.actionTitle,
      'action_type': instance.actionType,
      'response': instance.response,
      'action_meta': instance.actionMeta,
    };

MediaAction _$MediaActionFromJson(Map<String, dynamic> json) => MediaAction(
  title: json['title'] as String? ?? '',
  image: json['image'] as String? ?? '',
  icon: json['icon'] as String? ?? '',
  chatAction: json['chat_action'] == null
      ? const ChatAction()
      : ChatAction.fromJson(json['chat_action'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MediaActionToJson(MediaAction instance) =>
    <String, dynamic>{
      'title': instance.title,
      'image': instance.image,
      'icon': instance.icon,
      'chat_action': instance.chatAction,
    };

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      start: json['start'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      channelId: json['channel_id'] as int? ?? 0,
    );


MediaItem _$MediaItemFromJson(Map<String, dynamic> json) => MediaItem(
  actions: (json['actions'] as List<dynamic>?)
      ?.map((e) => MediaAction.fromJson(e as Map<String, dynamic>))
      .toList() ??
      const [],
  description: json['description'] as String? ?? "",
  iconIDs:
  (json['icon_ids'] as List<dynamic>?)?.map((e) => e as int).toList() ??
      const [],
  image: json['image'] as String? ?? "",
  imageHD: json['image_hd'] as String? ?? "",
  itemID: json['item_id'] as String? ?? "",
  itemType: json['item_type'] as String? ?? "",
  package: json['package'] as String? ?? "",
  subtitle: json['subtitle'] as String? ?? "",
  title: json['title'] as String? ?? "",
  video: json['video'] as String? ?? "",
  schedule: json['schedule'] == null
      ? null
      : Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
  isLiveTVItem: json['isLiveTVItem'] as bool? ?? false,
  isAppForYou: json['isAppForYou'] as bool? ?? false,
  selected: json['selected'] as bool? ?? false,
);

Map<String, dynamic> _$MediaItemToJson(MediaItem instance) => <String, dynamic>{
  'actions': instance.actions,
  'description': instance.description,
  'icon_ids': instance.iconIDs,
  'image': instance.image,
  'image_hd': instance.imageHD,
  'item_id': instance.itemID,
  'item_type': instance.itemType,
  'package': instance.package,
  'subtitle': instance.subtitle,
  'title': instance.title,
  'video': instance.video,
  'isLiveTVItem': instance.isLiveTVItem,
  'isHomeScreen': instance.isHomeScreen,
  'isAppForYou': instance.isAppForYou,
  'selected': instance.selected,
  'schedule': instance.schedule,
};

MediaItemIcon _$MediaItemIconFromJson(Map<String, dynamic> json) =>
    MediaItemIcon(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );

Map<String, dynamic> _$MediaItemIconToJson(MediaItemIcon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
    };

MediaRow _$MediaRowFromJson(Map<String, dynamic> json) => MediaRow(
  contentType: json['content_type'] as int? ?? -1,
  displayConfig: json['display_config'] == null
      ? const DisplayConfig(height: 0, width: 0)
      : DisplayConfig.fromJson(
      json['display_config'] as Map<String, dynamic>),
  mediaItemGroups: (json['media_item_groups'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList() ??
      [],
  mediaItemIcons: (json['media_item_icons'] as List<dynamic>?)
      ?.map((e) => MediaItemIcon.fromJson(e as Map<String, dynamic>))
      .toList() ??
      [],
  mediaItems: (json['media_items'] as List<dynamic>?)
      ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
      .toList() ??
      [],
  title: json['title'] as String? ?? '',
)
  ..rowImage = json['rowImage'] as String?
  ..rowTime = json['rowTime'] as String?;

Map<String, dynamic> _$MediaRowToJson(MediaRow instance) => <String, dynamic>{
  'content_type': instance.contentType,
  'display_config': instance.displayConfig,
  'media_item_groups': instance.mediaItemGroups,
  'media_item_icons': instance.mediaItemIcons,
  'media_items': instance.mediaItems,
  'title': instance.title,
  'rowImage': instance.rowImage,
  'rowTime': instance.rowTime,
};

MediaHeaderMeta _$MediaHeaderMetaFromJson(Map<String, dynamic> json) =>
    MediaHeaderMeta(
      pageNo: json['page_no'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 0,
    );

Map<String, dynamic> _$MediaHeaderMetaToJson(MediaHeaderMeta instance) =>
    <String, dynamic>{
      'page_no': instance.pageNo,
      'total_pages': instance.totalPages,
    };

MediaHeader _$MediaHeaderFromJson(Map<String, dynamic> json) => MediaHeader(
  description: json['description'] as String? ?? "",
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList() ??
      const [],
  mediaItem: json['item'] == null
      ? null
      : MediaItem.fromJson(json['item'] as Map<String, dynamic>),
  meta: json['meta'] == null
      ? const MediaHeaderMeta()
      : MediaHeaderMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MediaHeaderToJson(MediaHeader instance) =>
    <String, dynamic>{
      'description': instance.description,
      'images': instance.images,
      'item': instance.mediaItem,
      'meta': instance.meta,
    };

MediaDetail _$MediaDetailFromJson(Map<String, dynamic> json) => MediaDetail(
  mediaHeader: json['media_header'] == null
      ? null
      : MediaHeader.fromJson(json['media_header'] as Map<String, dynamic>),
  mediaRows: (json['media_rows'] as List<dynamic>?)
      ?.map((e) => MediaRow.fromJson(e as Map<String, dynamic>))
      .toList() ??
      const [],
);

Map<String, dynamic> _$MediaDetailToJson(MediaDetail instance) =>
    <String, dynamic>{
      'media_header': instance.mediaHeader,
      'media_rows': instance.mediaRows,
    };

StandardPromotionResult _$StandardPromotionResultFromJson(
    Map<String, dynamic> json) =>
    StandardPromotionResult(
      standardPromotions: (json['standard_promotions'] as List<dynamic>?)
          ?.map(
              (e) => StandardPromotion.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );


StandardPromotion _$StandardPromotionFromJson(Map<String, dynamic> json) =>
    StandardPromotion(
      image: json['image'] as String? ?? '',
      imageTitle: json['image_title'] as String? ?? '',
      action: json['action'] == null
          ? const ChatAction()
          : ChatAction.fromJson(json['action'] as Map<String, dynamic>),
    );


SearchSuggestionResult _$SearchSuggestionResultFromJson(
    Map<String, dynamic> json) =>
    SearchSuggestionResult(
      query: json['query'] as String? ?? '',
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => SearchSuggestion.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );


SearchSuggestion _$SearchSuggestionFromJson(Map<String, dynamic> json) =>
    SearchSuggestion(
      json['title'] as String? ?? '',
      fromHistory: json['fromHistory'] as bool? ?? false,
    );


MediaItemListElement _$MediaItemListElementFromJson(
    Map<String, dynamic> json) =>
    MediaItemListElement(
      itemType: json['item_type'] as String? ?? '',
      itemIds: (json['item_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
    );


UserInterests _$UserInterestsFromJson(Map<String, dynamic> json) =>
    UserInterests(
      favorites: (json['favorites'] as List<dynamic>?)
          ?.map((e) =>
          MediaItemListElement.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      seen: (json['seen'] as List<dynamic>?)
          ?.map((e) =>
          MediaItemListElement.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      watchlist: (json['watchlist'] as List<dynamic>?)
          ?.map((e) =>
          MediaItemListElement.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      notInterested: (json['not_interested_list'] as List<dynamic>?)
          ?.map((e) =>
          MediaItemListElement.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );


UserInterestsResult _$UserInterestsResultFromJson(Map<String, dynamic> json) =>
    UserInterestsResult(
      userInterests: json['results'] == null
          ? const UserInterests(
          favorites: [], seen: [], watchlist: [], notInterested: [])
          : UserInterests.fromJson(json['results'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserInterestsResultToJson(
    UserInterestsResult instance) =>
    <String, dynamic>{
      'results': instance.userInterests,
    };

FavoriteLanguages _$FavoriteLanguagesFromJson(Map<String, dynamic> json) =>
    FavoriteLanguages(
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
    );


TvDevice _$TvDeviceFromJson(Map<String, dynamic> json) => TvDevice(
  id: json['id'] as int,
  name: json['name'] as String? ?? '',
  serialNumber: json['serial_number'] as String? ?? '',
  pushyToken: json['pushy_token'] as String? ?? '',
);


GenreList _$GenreListFromJson(Map<String, dynamic> json) => GenreList(
  list: (json['result'] as List<dynamic>?)
      ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
      .toList() ??
      [],
);


Genre _$GenreFromJson(Map<String, dynamic> json) => Genre(
  title: json['title'] as String? ?? '',
  isSelected: json['isSelected'] as bool? ?? false,
);


LanguageList _$LanguageListFromJson(Map<String, dynamic> json) => LanguageList(
  list: (json['result'] as List<dynamic>?)
      ?.map((e) => Language.fromJson(e as Map<String, dynamic>))
      .toList() ??
      [],
);


Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
  title: json['title'] as String? ?? '',
);
// ..isSelected = json['isSelected'] as bool;


Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
  id: json['id'] as int? ?? 0,
  operatorChannelId: json['operator_channel_id'] as int? ?? 0,
  name: json['name'] as String? ?? '',
  image: json['image'] as String? ?? '',
  genre: json['genre'] as String? ?? '',
  language: json['language'] as String? ?? '',
  key: json['key'] as String? ?? '',
  feedHLS: json['feed_hls'] as String? ?? '',
  feedDeepLink: json['feed_deeplink'] as String? ?? '',
  source: json['source'] as String? ?? '',
  deeplinkPackage: json['deeplink_package'] as String? ?? '',
  feedDeeplinkPackageMobile:
  json['feed_deeplink_package_mobile'] as String? ?? '',
  feedDeeplinkPackageTv: json['feed_deeplink_package_tv'] as String? ?? '',
  identifier: json['identifier'] as String? ?? '',
  isActive: json['is_active'] as bool? ?? false,
  slug: json['slug'] as String? ?? '',
);
