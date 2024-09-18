import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/search_suggestions.dart';
import 'package:dor_companion/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../data/models/models.dart';
import '../../../injection/injection.dart';
import '../LanguageItemView.dart';

class SearchViewController extends GetxController {
  RxList<MediaItem> mediaItem = <MediaItem>[].obs;
  RxList<MediaItem> trendingMediaItem = <MediaItem>[].obs;
  RxList<SearchSuggestion> searchHistory =<SearchSuggestion>[].obs;
  SearchSuggestions? searchSuggestions;
  RxList<LanguageItemView> movies = <LanguageItemView>[].obs;
  RxBool showAllMovies = false.obs;
  RxList<LanguageItemView> visibleMovies = <LanguageItemView>[].obs;
  initSpeech(bool speechEnabled,  SpeechToText speechToText ,bool speechInitialized) async {
    speechEnabled = await speechToText.initialize(
      onError: (errorNotification) {
        if (kDebugMode) {
          print("STT Error: $errorNotification");
        }
      },
    );
    speechInitialized = true;
    if (kDebugMode) {
      print("STT: Speech enabled: $speechEnabled");
    }
  }

  Future<void> fetchData(String itemId, String itemType) async {

    return getIt<SensyApi>().fetchMediaDetail(itemId, itemType).then((value) {
      if (itemType == 'find') {
        mediaItem.value = value.mediaRows[0].mediaItems;
      } else {
        trendingMediaItem.value = value.mediaRows[0].mediaItems;
      }
    }).catchError((Object errorObj) {
      if (kDebugMode) {
        print("Failed to fetch favorite languages: ${errorObj.toString()}");
      }
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to fetch favorite languages: ${response?.statusCode}");
      }
    });
  }

  Future<void> setSearchHistory(SearchSuggestions searchSuggestions) async {
    // setState(() {
    searchHistory.value = searchSuggestions.getSearchHistory();
    // });
  }
}