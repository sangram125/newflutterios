import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/get_issue_item_model.dart';
import 'package:dor_companion/data/models/list_cluster.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/get_ticket_item_model.dart';
import '../models/models.dart';

part 'sensy_api.g.dart';

class ApiEndpoints {
  static const apiBase = "https://api-360-prod.streamboxmedia.com/api/";
  static const requestOtp = "v4/subscriber/otp";
  static const requestCrmOtp = "v4/subscriber/crmcom_otp";
  static const verifyOtp = "v4/subscriber/user";
  static const verifyCrmOtp = "v4/subscriber/crmcom_user";
  static const customer = "v4/subscriber/me";
  static const fetchClientToken = "v5/partners/client_token";
  static const createProfile = "v4/subscriber/profile";
  static const modifyProfile = "v4/subscriber/profile/{profile_id}";
  static const favoriteLanguages = "v2/user/languages";
  static const languages = "v4/epg/meta/languages";
  static const genres = "v4/epg/meta/genres";
  static const channels = "v2/partners/channels";
  static const channelsSchedule = "v4/epg/detail/tab/guide";
  static const fetchUserInterests = "v2/user/user_interests";
  static const fetchLiveNews = "https://news.ext.sensalore.com/v2/get_cluster";
  static const fetchDeeplinks = "v4/epg/reco/deeplinks";
  static const fetchMediaDetail = "v4/epg/detail/{item_type}/{item_id}";
  static const fetchSuggestedRows = "v4/epg/facets";
  static const favorites = "v2/user/favorites";
  static const watchlist = "v2/user/watchlist";
  static const seen = "v2/user/seen";
  static const notInterested = "v2/user/not_interested";
  static const fetchPromotions =
      "v4/engagement/standard_promotions?future_events=false";
  static const fetchSearchSuggestions = "v1/epg/facet";
  static const fetchSearchResult = "v4/epg/universal_search?format=json";
  static const performCallServer = "v4/engagement/call_server";
  static const authorizeAction = "v4/subscriber/deeplink/authorize";
  static const fetchTvDevices = "v4/subscriber/devices";
  static const forwardToTvDevice = "v4/subscriber/device/{device_id}/notify";
  static const genAISearch = "/v4/chatbot/audio_dialog";
  static const gamePage = "https://page.api.hungama.com/v1/page";
  // API Endpoints
  static const String issueEndpoint = '/api/resource/Issue';
  static const String ticketItemEndpoint = '/resource/Ticket Item';
  static const String leadSourceEndpoint = '/api/resource/Lead Source';
  static const String customerEndpoint = '/api/resource/Customer';
  static const String ticketTypeEndpoint = '/api/resource/Ticket Type?filters=[["ticket_category","=","Hardware"]]';
  static const String ticketCategoryEndpoint = 'resource/Ticket Category';
  static const String ticketItemFilteredEndpoint = '/api/resource/Ticket Item?filters=[["ticket_type","=","Audio%20Issue"]]';
}

@RestApi(
  baseUrl: ApiEndpoints.apiBase,
  parser: Parser.FlutterCompute,
)
@lazySingleton
abstract class SensyApi {
  @factoryMethod
  // Add baseUrl named param here if we need to inject a baseUrl (eg prod/dev)
  factory SensyApi(Dio dio) = _SensyApi;

  @POST(ApiEndpoints.requestOtp)
  Future<void> requestOtp(@Body() MobileNumber mobileNumber);

  @POST(ApiEndpoints.verifyOtp)
  Future<AccessToken> verifyOtp(@Body() MobileNumber mobileNumber);

  @POST(ApiEndpoints.requestCrmOtp)
  Future<void> requestCrmOtp(@Body() MobileNumber mobileNumber);

  @POST(ApiEndpoints.verifyCrmOtp)
  Future<AccessToken> verifyCrmOtp(@Body() MobileNumber mobileNumber);

  @POST(ApiEndpoints.customer)
  Future<void> nameCustomer(@Body() CustomerName name);

  @GET(ApiEndpoints.customer)
  Future<Customer> fetchCustomer();

  @POST(ApiEndpoints.fetchClientToken)
  Future<ClientToken> fetchClientToken();

  @FormUrlEncoded()
  @POST(ApiEndpoints.createProfile)
  Future<Profile> createProfile(@Field("name") String name);

  @FormUrlEncoded()
  @PUT(ApiEndpoints.modifyProfile)
  Future<void> setProfilePersonalized(@Path("profile_id") String profileId,
      @Field("is_personalized") bool isPersonalized);

  @FormUrlEncoded()
  @PUT(ApiEndpoints.modifyProfile)
  Future<void> renameProfile(@Path("profile_id") String profileId,
      @Field("name") String name);

  @DELETE(ApiEndpoints.modifyProfile)
  Future<void> deleteProfile(@Path("profile_id") String profileId);

  @GET(ApiEndpoints.fetchDeeplinks)
  Future<MediaDetail> fetchDeeplinks(@Query("languages") String languages);

  @GET(ApiEndpoints.fetchMediaDetail)
  Future<MediaDetail> fetchMediaDetail(@Path("item_type") String itemType,
      @Path("item_id") String itemId);

  @GET(ApiEndpoints.fetchMediaDetail)
  Future<MediaDetail> fetchPaginatedMediaDetail(
      @Path("item_type") String itemType,
      @Path("item_id") String itemId,
      @Query("page_no") int pageNo);

  @GET(ApiEndpoints.fetchSuggestedRows)
  Future<MediaDetail> fetchSuggestedRows(
      @Query("last_selected_type") String itemType,
      @Query("last_selected") String itemId);

  @GET(ApiEndpoints.favoriteLanguages)
  Future<FavoriteLanguages> fetchFavoriteLanguages();

  @GET(ApiEndpoints.languages)
  Future<LanguageList> fetchLanguages();

  @GET(ApiEndpoints.genres)
  Future<GenreList> fetchGenres();

  @GET(ApiEndpoints.channels)
  Future<List<Channel>> fetchChannels();

  @GET(ApiEndpoints.channelsSchedule)
  Future<MediaDetail> fetchChannelsSchedule(
      @Query("channels") String channelIds);

  @FormUrlEncoded()
  @POST(ApiEndpoints.favoriteLanguages)
  Future<FavoriteLanguages> postFavoriteLanguages(
      @Field("languages") String languages);

  @GET(ApiEndpoints.fetchUserInterests)
  Future<UserInterestsResult> fetchUserInterests();

  @GET(ApiEndpoints.fetchLiveNews)
  Future<ListCluster> fetchLiveNews();
  // @GET(ApiEndpoints.fetchPlans)
  // Future<List<SubscriptionPlan>> getPlans(@Query("languages") String languages);

  // @POST(ApiEndpoints.subscribeToPlan)
  // Future<SubscribedPlan> subscribeToPlan(@Field("id") int id, @Field("id_slug") String idSlug, @Field("price_point_id") int pricePointId);

  @FormUrlEncoded()
  @POST(ApiEndpoints.favorites)
  Future<void> addToFavorites(@Field("item_type") String itemType,
      @Field("item_id") String itemId);

  @FormUrlEncoded()
  @DELETE(ApiEndpoints.favorites)
  Future<void> removeFromFavorites(
      @Field("item_type") String itemType, @Field("item_id") String itemId);

  @FormUrlEncoded()
  @POST(ApiEndpoints.watchlist)
  Future<void> addToWatchlist(
      @Field("item_type") String itemType, @Field("item_id") String itemId);

  @FormUrlEncoded()
  @DELETE(ApiEndpoints.watchlist)
  Future<void> removeFromWatchlist(
      @Field("item_type") String itemType, @Field("item_id") String itemId);

  @FormUrlEncoded()
  @POST(ApiEndpoints.seen)
  Future<void> addToSeen(
      @Field("item_type") String itemType, @Field("item_id") String itemId);

  @FormUrlEncoded()
  @DELETE(ApiEndpoints.seen)
  Future<void> removeFromSeen(
      @Field("item_type") String itemType, @Field("item_id") String itemId);

  @FormUrlEncoded()
  @POST(ApiEndpoints.notInterested)
  Future<void> addToNotInterested(
      @Field("item_type") String itemType, @Field("item_id") String itemId);

  @FormUrlEncoded()
  @DELETE(ApiEndpoints.notInterested)
  Future<void> removeFromNotInterested(
      @Field("item_type") String itemType, @Field("item_id") String itemId);

  @GET(ApiEndpoints.fetchPromotions)
  Future<StandardPromotionResult> fetchPromotions(@Query("target_id") int id);

  @GET(ApiEndpoints.fetchSearchSuggestions)
  Future<SearchSuggestionResult> fetchSearchSuggestions(
      @Query("prefix") String prefix);

  @GET(ApiEndpoints.fetchSearchResult)
  Future<MediaDetail> fetchSearchResult(@Query("q") String query);

  @FormUrlEncoded()
  @POST(ApiEndpoints.performCallServer)
  Future<ChatAction?> performCallServer(@Field("action_id") String actionID,
      @Field("action_title") String actionTitle);

  @POST(ApiEndpoints.authorizeAction)
  Future<ChatAction> authorizeAction(
      @Query("platform") String platform, @Body() ChatAction chatAction);

  @GET(ApiEndpoints.fetchTvDevices)
  Future<List<TvDevice>> fetchTvDevices();

  @POST(ApiEndpoints.forwardToTvDevice)
  Future<void> forwardToTvDevice(
      @Path("device_id") String deviceId, @Body() ChatAction chatAction);

  @FormUrlEncoded()
  @POST(ApiEndpoints.genAISearch)
  Future<ChatAction> fetchAISearchResult(
      @Field("message") String message, @Field('chat_history') String history);
}
