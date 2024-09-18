import 'package:dor_companion/data/models/models.dart';
import 'package:flutter/material.dart';
import '../../data/api/sensy_api.dart';
import '../../injection/injection.dart';

class SportsDetailVm extends ChangeNotifier {
  String? sportType;
  List<MediaItem> sportsList = [];
  List<MediaRow> sportsRow = [];

  void setData(String title, List<MediaItem> list, List<MediaRow> rows) {
    sportType = title;
    sportsRow = rows;
    setSportList(list);
    notifyListeners();
  }

  void setSportList(List<MediaItem> list) {
    sportsList = list.map((element) {
      element.selected = element.title == sportType;
      return element;
    }).toList();
    notifyListeners();
  }

  Future<void> changeSportsType(String title) async {
    sportType = title;
    var itemID;
    for (var i = 0; i < sportsList.length; i++) {
      var genre = sportsList[i];
      if (genre.title == title) {
        sportsList[i].selected = true;
        itemID = genre.itemID;
      } else {
        sportsList[i].selected = false;
      }
    }
    await  getIt<SensyApi>().fetchMediaDetail("sport_genre",
        itemID).then((mediaDetail) {
      sportsRow = [];
      sportsRow = mediaDetail.mediaRows;
    });
    notifyListeners();
  }
}
