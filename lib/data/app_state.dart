import 'package:carousel_slider/carousel_controller.dart';
import 'package:dor_companion/data/models/list_cluster.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'models/models.dart';

LiveTvState appState = LiveTvState();
class LiveTvState {
  static final LiveTvState _singleton = LiveTvState._internal();

  factory LiveTvState() {
    return _singleton;
  }

  LiveTvState._internal();

  ValueNotifier<List<StandardPromotion>> banners = ValueNotifier([]);
  ValueNotifier<List<StandardPromotion>> bannersWeb = ValueNotifier([]);
  ValueNotifier<List<Channel>> channels = ValueNotifier([]);
  ValueNotifier<List<Channel>> filteredChannels = ValueNotifier([]);
  ValueNotifier<List<MediaRow>> rows = ValueNotifier([]);
  ValueNotifier<List<MediaRow>> loadingPageRows = ValueNotifier([]);
  ValueNotifier<GenreList> genres = ValueNotifier(const GenreList(list: []));
  ValueNotifier<LanguageList> languages = ValueNotifier(const LanguageList(list: []));
  ValueNotifier<List> selectedFilterList = ValueNotifier([]);
  ValueNotifier<List<Channel>> channelListForGenre = ValueNotifier([]);
  ValueNotifier<bool> isBannersError = ValueNotifier(false);
  ValueNotifier<bool> isBannersWebError = ValueNotifier(false);
  ValueNotifier<bool> isGenresError = ValueNotifier(false);
  ValueNotifier<bool> isLanguagesError = ValueNotifier(false);
  ValueNotifier<bool> isChannelsError = ValueNotifier(false);
  ValueNotifier<bool> isError = ValueNotifier(false);
  ValueNotifier<bool> loadingMore = ValueNotifier(false);
  ValueNotifier<bool> fabIsVisible = ValueNotifier(false);
  ValueNotifier<int> totalPages = ValueNotifier(1);
  ValueNotifier<int> currentPage = ValueNotifier(1);
  ValueNotifier<int> currentView = ValueNotifier(0);
  ValueNotifier<ScrollController> scrollController = ValueNotifier(ScrollController());
  ValueNotifier<CarouselController> buttonCarouselController = ValueNotifier(CarouselController());
  ValueNotifier<bool> isTVGuideTap = ValueNotifier(false);
  ValueNotifier<bool> isShows = ValueNotifier(false);
  ValueNotifier<ListCluster> liveNewsRow = ValueNotifier( ListCluster(cluster: []));
  ValueNotifier<int> lastSelected = ValueNotifier(0);
  ValueNotifier<int> lastSelectedChannel = ValueNotifier(0);
  AnalyticsEvent eventCall = AnalyticsEvent();
  ValueNotifier<bool> isLiveNewsTileTapped = ValueNotifier(false);
  ValueNotifier<int> indexOfFetchingData = ValueNotifier(0);
}

SportsAppState sportsAppState = SportsAppState();

class SportsAppState {
  static final SportsAppState _singleton = SportsAppState._internal();

  factory SportsAppState() {
    return _singleton;
  }

  SportsAppState._internal();

  ValueNotifier<List<StandardPromotion>> banners = ValueNotifier([]);
  ValueNotifier<List<StandardPromotion>> bannersWeb = ValueNotifier([]);
  ValueNotifier<List<MediaRow>> rows = ValueNotifier([]);
  ValueNotifier<bool> isBannersError = ValueNotifier(false);
  ValueNotifier<bool> isBannersWebError = ValueNotifier(false);
  ValueNotifier<bool> isError = ValueNotifier(false);
  ValueNotifier<bool> loadingMore = ValueNotifier(false);
  ValueNotifier<bool> fabIsVisible = ValueNotifier(false);
  ValueNotifier<int> totalPages = ValueNotifier(1);
  ValueNotifier<int> currentPage = ValueNotifier(1);
  ValueNotifier<ScrollController> scrollController = ValueNotifier(ScrollController());


}

NewsState newsAppState = NewsState();
class NewsState {
  static final NewsState _singleton = NewsState._internal();

  factory NewsState() {
    return _singleton;
  }

  NewsState._internal();

  ValueNotifier<List<StandardPromotion>> banners = ValueNotifier([]);
  ValueNotifier<List<StandardPromotion>> bannersWeb = ValueNotifier([]);
  ValueNotifier<List<MediaRow>> rows = ValueNotifier([]);
  ValueNotifier<bool> isBannersError = ValueNotifier(false);
  ValueNotifier<bool> isBannersWebError = ValueNotifier(false);
  ValueNotifier<bool> isError = ValueNotifier(false);
  ValueNotifier<bool> loadingMore = ValueNotifier(false);
  ValueNotifier<bool> fabIsVisible = ValueNotifier(false);
  ValueNotifier<int> totalPages = ValueNotifier(1);
  ValueNotifier<int> currentPage = ValueNotifier(1);
  ValueNotifier<ScrollController> scrollController = ValueNotifier(ScrollController());
}

HomeState homeState = HomeState();
class HomeState {
  static final HomeState _singleton = HomeState._internal();

  factory HomeState() {
    return _singleton;
  }

  HomeState._internal();

  ValueNotifier<List<StandardPromotion>> banners = ValueNotifier([]);
  ValueNotifier<List<StandardPromotion>> bannersWeb = ValueNotifier([]);
  ValueNotifier<List<MediaRow>> rows = ValueNotifier([]);
  ValueNotifier<bool> isBannersError = ValueNotifier(false);
  ValueNotifier<bool> isBannersWebError = ValueNotifier(false);
  ValueNotifier<bool> isError = ValueNotifier(false);
  ValueNotifier<bool> loadingMore = ValueNotifier(false);
  ValueNotifier<bool> fabIsVisible = ValueNotifier(false);
  ValueNotifier<int> totalPages = ValueNotifier(1);
  ValueNotifier<int> currentPage = ValueNotifier(1);
  ValueNotifier<ScrollController> scrollController = ValueNotifier(ScrollController());
}
