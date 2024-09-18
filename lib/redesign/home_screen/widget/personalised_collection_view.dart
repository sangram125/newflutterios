import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/home_screen/widget/latest_content.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:flutter/material.dart';

class PersonalisedCollectionView extends StatelessWidget {
   PersonalisedCollectionView({super.key});

  static MediaAction? getFirstWatchOnActionOrNull(List<MediaAction> actions) {
    if (actions.isEmpty) return null;
    for (MediaAction action in actions) {
      if (ActionTypes.watchOnActionTypes
          .contains(action.chatAction.actionType)) {
        return action;
      }
    }

    return null;
  }
  List<MediaItem> mediaItems =[];
  @override
  Widget build(BuildContext context) {
    List<MediaRow> topRecommendationList = homeState.rows.value
        .where((title) => title.title.contains('Personalized')||title.title.contains('Personalized shows'))
        .toList();

    return topRecommendationList.isEmpty
        ? const SizedBox.shrink()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 32),
          child: Text("Daily personalised collection",
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 0.20,
                  fontSize: 14,
                  color: Color(0xFF999999),
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.w400))),
      const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("Today’s specials",
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 0.20,
                  fontSize: 28,
                  color: Colors.white,
                  fontFamily: 'DMSerifDisplay',
                  fontWeight: FontWeight.w400))),
      const SizedBox(height: 10),
      ValueListenableBuilder(
          valueListenable: homeState.rows,
          builder: (context, value, child) {
            List<MediaRow> topRecommendationList = homeState.rows.value
                .where((title) => title.title.contains('Personalized')||title.title.contains('Personalized shows'))
                .toList();
            for(var data in topRecommendationList){
              for(var data1 in data.mediaItems) {
                mediaItems.add(data1);
              }
            }
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.28,
                width: double.infinity,
                child: OTTProviderGridView( items: mediaItems,isIconPresent:true,crossAxisCount: 1,));
          })
    ]);
  }
}
