import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../injection/injection.dart';
import '../api/sensy_api.dart';
import 'models.dart';

@lazySingleton
class FavoriteLanguagesChangeNotifier extends ChangeNotifier {
  static const List<String> languageNames = [
    "Hindi",
    "English",
    "Tamil",
    "Marathi",
    "Telugu",
    "Kannada",
    "Bengali",
    "Malayalam",
    "Bhojpuri",
    "Gujarati",
    "Punjabi",
    "Oriya",
    "Rajashtani",
    "Haryanvi",
    "Urdu"
  ];

  static const List<String> trendingList = [
    "Oppenheimer",
    "Stranger things",
    "Bigboss",
  ];

  static const List<String> browseAllMovie = [
    "Best of Bollywood",
    "Spine Chilling Horror",
    "Historical Epics",
  ];

  static const List<int> languageIds = [
    1,
    4,
    6,
    8,
    10,
    174,
    22,
    265,
  ];

  static const List<String> languageSymbols = [
    "हिं",
    "En",
    "த",
    "తె",
    "മ",
    "ಕ",
    "বা",
    "म",
  ];

  static const List<String> languageNamesInternational = [
    "Korean",
    "Spanish",
    "French",
    "Mandarin",
    "Japanese",
    "Cantonese",
    // "Urdu",
    "Indonesian",
    "Arabic",
    "German",
    "Turkish",
  ];

  static const List<int> languageIdsInternal = [
    1,
    4,
    6,
    8,
    10,
    174,
  ];

  static const List<String> internationalLanguageNames = [
    "Korean",
    "Spanish",
    "French",
    "Mandarin",
    "Japanese",
    "Cantonese",
    // "Urdu",
    "Indonesian",
    "Arabic",
    "German",
    "Turkish",
  ];

  static const List<int> internationalLanguageIds = [
    1,
    4,
    6,
    8,
    10,
    174,
  ];

  final SensyApi _sensyApi;

  FavoriteLanguages? _favoriteLanguages;
  FavoriteLanguages? _favoriteInternalLanguages;

  List<String> get favoriteLanguages => _favoriteLanguages?.languages ?? [];

  List<String> get favoriteInternalLanguages => _favoriteInternalLanguages?.languages ?? [];

  bool _isDoLater = false;

  bool get isDoLater => _isDoLater;

  void setIsDoLater(bool value) {
    _isDoLater = value;
  }

  FavoriteLanguagesChangeNotifier(this._sensyApi);

  Future<void> setupLanguages({bool rethrowErrors = false}) {
    final tempLanguages = _favoriteLanguages;

    _favoriteLanguages = null;

    return _sensyApi.fetchFavoriteLanguages().then((value) {
      if (kDebugMode) {
        print("Fetched favorite languages: ${value.languages}");
      }
      value.languages.sort();
      _favoriteLanguages = value;
    }).catchError((Object errorObj) {
      if (kDebugMode) {
        print("Failed to fetch favorite languages: ${errorObj.toString()}");
      }
      switch (errorObj.runtimeType) {
        case DioException:
          _favoriteLanguages = tempLanguages;
          final response = (errorObj as DioException).response;
          showVanillaToast("Failed to fetch favorite languages: ${response?.statusCode}");
      }
      if (rethrowErrors) throw errorObj;
    });
  }

  void clearFavoriteLanguages({bool notify = true}) {
    _favoriteLanguages = null;
    if (notify) {
      notifyListeners();
      getIt<UserAccount>().notify();
    }
  }

  String getFavoriteLanguages() {
    final languages = _favoriteLanguages?.languages.join(",") ?? "";
    if (kDebugMode) {
      print("Returning languages $languages");
    }
    return languages;
  }

  String getFormattedFavoriteLanguages() {
    final languages = _favoriteLanguages?.languages.join(", ") ?? "No languages selected";
    if (kDebugMode) {
      print("Returning formatted languages $languages");
    }
    return languages;
  }

  bool isFavoriteLanguage(String language) {
    return _favoriteLanguages?.languages.any((favLanguage) => favLanguage == language) ?? false;
  }

  notify() {
    // Wrap nofifyListeners() as it is annotated as protected
    notifyListeners();
  }

  Future<bool> postFavoriteLanguages(List<String> languages) async {
    return _sensyApi
        .postFavoriteLanguages(languages
            .reduce((value, element) => "${value.toLowerCase().trim()},${element.toLowerCase().trim()}"))
        .then((value) => setupLanguages())
        .then((value) {
      return Future.value(true);
    }).catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast("Failed to update favorites: ${response?.statusCode}");
      }
      return Future.value(false);
    });
  }
}
