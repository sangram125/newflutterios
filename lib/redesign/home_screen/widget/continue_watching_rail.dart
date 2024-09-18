import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/home_screen/widget/latest_content.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:flutter/material.dart';

import '../../../data/models/constants.dart';

class ContinueWatchingRailView extends StatelessWidget {
  const ContinueWatchingRailView({super.key});

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
  @override
  Widget build(BuildContext context) {
    List<MediaRow> topRecommendationList = homeState.rows.value
        .where((title) => title.title == "Continue Watching")
        .toList();

    return topRecommendationList.isEmpty
        ? const SizedBox.shrink()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("Pickup from where you left off",
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 0.20,
                  fontSize: 14,
                  color: Color(0xFF999999),
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.w400))),
      const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("Continue watching",
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 0.20,
                  fontSize: 28,
                  color: Colors.white,
                  fontFamily: 'DMSerifDisplay',
                  fontWeight: FontWeight.w400))),

      ValueListenableBuilder(
          valueListenable: homeState.rows,
          builder: (context, value, child) {
            List<MediaRow> topRecommendationList = homeState.rows.value
                .where((title) => title.title == "Continue Watching")
                .toList();
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.28,
                width: double.infinity,
                child: OTTProviderGridView( items: topRecommendationList.first.mediaItems,isIconPresent:true,crossAxisCount: 1,));
          })
    ]);
  }
}
