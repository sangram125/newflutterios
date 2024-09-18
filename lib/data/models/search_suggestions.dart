import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

@lazySingleton
class SearchSuggestions {
  final SharedPreferences sharedPrefs;

  const SearchSuggestions(this.sharedPrefs);

  static List<SearchSuggestion> fromJsonResponse(
      List<Map<String, dynamic>> json) {
    return (List.from(json).map((s) => SearchSuggestion(s["title"])).toList());
  }

  static fromJsonResponseInIsolate(List<Map<String, dynamic>> json) {
    return compute(fromJsonResponse, json);
  }

  List<String> _getSearchHistory() {
    final List<String>? items = sharedPrefs.getStringList('searchHistory');
    return items ?? [];
  }

  _saveSearchHistory(List<String> searchHistory) {
    sharedPrefs.setStringList('searchHistory', searchHistory);
  }

  List<SearchSuggestion> getSearchHistory() {
    List<SearchSuggestion> searchHistory = _getSearchHistory()
        .map((title) => SearchSuggestion(title, fromHistory: true))
        .toList();
    return searchHistory.reversed.toList();
  }

  addToHistory(String searchTerm) {
    List<String> searchHistory = _getSearchHistory();
    searchHistory.add(searchTerm);
    searchHistory = searchHistory.toSet().toList();
    const limit = 10;
    if (searchHistory.length > limit) {
      searchHistory =
          searchHistory.sublist((limit - searchHistory.length).abs());
    }
    _saveSearchHistory(searchHistory);
  }

  removeFromHistory(String searchTerm) {
    List<String> searchHistory = _getSearchHistory();
    searchHistory.remove(searchTerm);
    _saveSearchHistory(searchHistory);
  }
}
