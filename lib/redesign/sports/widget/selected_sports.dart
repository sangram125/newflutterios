import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/sports/widget/content_view.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:flutter/material.dart';

class SelectedSports extends StatefulWidget {
  final List<MediaItem> rows;
  String moodTitle;

  SelectedSports({Key? key,required this.rows, this.moodTitle=''});


  @override
  State<SelectedSports> createState() => _SelectedSportsState();
}

class _SelectedSportsState extends State<SelectedSports> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MediaItem> sportsCategoryList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length:2, vsync: this);
    sportsCategoryList = widget.rows;
  }

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
    return sportsCategoryList.isEmpty
        ? const SizedBox.shrink()
        : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
       Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(widget.moodTitle,
              style: TextStyle(
                  letterSpacing: 0.20,
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: 'DMSerifDisplay',
                  fontWeight: FontWeight.w400))),
      SizedBox(height: 6,),
      ValueListenableBuilder(
          valueListenable: sportsAppState.rows,
          builder: (context, value, child) {
            List<MediaItem> topRecommendationList = widget.rows;
            return SizedBox(
                height:MediaQuery.of(context).size.height * 0.26,
                width: double.infinity,
                child: DetailView(
                  items: topRecommendationList,
                  isIconPresent: true,
                  )
            );
          })
    ]);
  }
}
