import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../utils.dart';
import '../api/sensy_api.dart';
import 'models.dart';

@lazySingleton
class UserInterestsChangeNotifier extends ChangeNotifier {
  final SensyApi _sensyApi;

  UserInterestsResult? _userInterestsResult;

  UserInterestsChangeNotifier(this._sensyApi);

  Future<void> setupInterests(
      {bool notifyChanges = true, bool rethrowErrors = false}) {
    final tempInterests = _userInterestsResult;

    _userInterestsResult = null;

    return _sensyApi.fetchUserInterests().then((value) {
      _userInterestsResult = value;
      log("=================================inside setupInterests===========================");
      log(value.userInterests.watchlist.length.toString());
      //if (notifyChanges) notifyListeners();
    }).catchError((Object errorObj) {
      if (kDebugMode) {
        print("Failed to fetch user interests: ${errorObj.toString()}");
      }
      switch (errorObj.runtimeType) {
        case DioException:
          _userInterestsResult = tempInterests;
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to fetch user interests: ${response?.statusCode}");
      }
      if (rethrowErrors) throw errorObj;
    });
  }

  clearInterests({bool notify = true}) {
    _userInterestsResult = null;
    if (notify) notifyListeners();
  }

  bool hasFavorites() {
    return _userInterestsResult?.userInterests.favorites.isNotEmpty ?? false;
  }

  isFavorite(String itemType, String itemId) {
    return _userInterestsResult?.userInterests.favorites.any(
            (mediaItemListElement) =>
                mediaItemListElement.itemType == itemType &&
                mediaItemListElement.itemIds
                    .any((listItemId) => listItemId == itemId)) ??
        false;
  }

  isSeen(String itemType, String itemId) {
    return _userInterestsResult?.userInterests.seen.any(
            (mediaItemListElement) =>
                mediaItemListElement.itemType == itemType &&
                mediaItemListElement.itemIds
                    .any((listItemId) => listItemId == itemId)) ??
        false;
  }

  isInWatchlist(String itemType, String itemId) {
    return _userInterestsResult?.userInterests.watchlist.any(
            (mediaItemListElement) =>
                mediaItemListElement.itemType == itemType &&
                mediaItemListElement.itemIds
                    .any((listItemId) => listItemId == itemId)) ??
        false;
  }

  isInNotInterestedList(String itemType, String itemId) {
    return _userInterestsResult?.userInterests.notInterested.any(
            (mediaItemListElement) =>
                mediaItemListElement.itemType == itemType &&
                mediaItemListElement.itemIds
                    .any((listItemId) => listItemId == itemId)) ??
        false;
  }

  toggleFavorite(String itemType, String itemId) async {
    isFavorite(itemType, itemId)
        ? await _removeFromFavorites(itemType, itemId)
        : await _addToFavorites(itemType, itemId);
  }

  _removeFromFavorites(String itemType, String itemId) async {
    await _sensyApi
        .removeFromFavorites(itemType, itemId)
        .then((value) => setupInterests(notifyChanges:false))
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to remove from favorites: ${response?.statusCode}");
      }
    });
  }

  _addToFavorites(String itemType, String itemId) async {
    await _sensyApi
        .addToFavorites(itemType, itemId)
        .then((value) => setupInterests(notifyChanges: false))
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print(response);
          // showVanillaToast(
          //     "Failed to add to favorites: ${response?.statusCode}");
      }
    });
  }

  toggleWatchlist(String itemType, String itemId) async {
    isInWatchlist(itemType, itemId)
        ? await _removeFromWatchlist(itemType, itemId)
        : await _addToWatchlist(itemType, itemId);
  }

  addToWatchlist(String itemType, String itemId) async {
    isInWatchlist(itemType, itemId)
        ? null
        : await _addToWatchlist(itemType, itemId);
  }

  List<Future<MediaDetail>> getWatchList() {
    if (_userInterestsResult != null) {
      final watchList = _userInterestsResult?.userInterests.watchlist ?? [];
      List<Future<MediaDetail>> featureList = [];
      log(watchList.length.toString());
      for (MediaItemListElement item in watchList) {
         featureList.addAll(item.itemIds.map((itemId) =>
             _sensyApi.fetchMediaDetail(itemId, item.itemType))) ;
      }
      return featureList;
    }
    return [];
  }

  _removeFromWatchlist(String itemType, String itemId) async {
    await _sensyApi
        .removeFromWatchlist(itemType, itemId)
        .then((value) => setupInterests(notifyChanges: false))
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to remove from watchlist: ${response?.statusCode}");
      }
    });
  }

  _addToWatchlist(String itemType, String itemId) async {
    await _sensyApi
        .addToWatchlist(itemType, itemId)
        .then((value) => setupInterests(notifyChanges: false))
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to add to watchlist: ${response?.statusCode}");
      }
    });
  }

  toggleSeen(String itemType, String itemId) async {
    isSeen(itemType, itemId)
        ? await _removeFromSeen(itemType, itemId)
        : await _addToSeen(itemType, itemId);
  }

  _removeFromSeen(String itemType, String itemId) async {
    await _sensyApi
        .removeFromSeen(itemType, itemId)
        .then((value) => setupInterests())
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to remove from seen: ${response?.statusCode}");
      }
    });
  }

  _addToSeen(String itemType, String itemId) async {
    await _sensyApi
        .addToSeen(itemType, itemId)
        .then((value) => setupInterests())
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print("Failed to add to seen: ${response?.statusCode}");
      }
    });
  }

  toggleNotInterested(String itemType, String itemId) async {
    isInNotInterestedList(itemType, itemId)
        ? await _removeFromNotInterested(itemType, itemId)
        : await _addToNotInterested(itemType, itemId);
  }

  _removeFromNotInterested(String itemType, String itemId) async {
    await _sensyApi
        .removeFromNotInterested(itemType, itemId)
        .then((value) => setupInterests())
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to remove from not interested: ${response?.statusCode}");
      }
    });
  }

  _addToNotInterested(String itemType, String itemId) async {
    await _sensyApi
        .addToNotInterested(itemType, itemId)
        .then((value) => setupInterests())
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to add to not interested: ${response?.statusCode}");
      }
    });
  }
}
