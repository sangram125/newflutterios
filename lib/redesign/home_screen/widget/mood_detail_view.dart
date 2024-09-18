
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/redesign/home_screen/widget/mood_suggestion_rail.dart';
import 'package:dor_companion/redesign/live_tv/widgets/card_banners.dart';
import 'package:dor_companion/widgets/appbar_custom.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';





class MoodDetailView extends StatefulWidget {
  List<MediaRow> rows;
  String moodTitle;
  MoodDetailView({
    Key? key,
    required this.rows, this.moodTitle=''
  }) : super(key: key);

  @override
  State<MoodDetailView> createState() => _MoodDetailViewState();
}

class _MoodDetailViewState extends State<MoodDetailView> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);


    return PerformanceTrackedWidget(
      widgetName: 'mood-detail-view',
      child: Scaffold(
          appBar: MyAppBar(showIcon: true, pageText: '',
          ),
          backgroundColor: Colors.black,

          body: SafeArea(
              child: SingleChildScrollView(
                  child:  Column(children: [
                    homeState.banners.value.isEmpty
                        ? const SizedBox()
                        :
                    // isBannersError
                    //     ? SizedBox(
                    //     height: MediaQuery.of(context).size.width,
                    //     child: Center(
                    //         child: ElevatedButton(
                    //             onPressed: fetchBanners,
                    //             style: ElevatedButton.styleFrom(
                    //                 shape: const StadiumBorder(),
                    //                 backgroundColor:
                    //                 Theme.of(context).colorScheme.tertiary,
                    //                 textStyle: AppTypography.fontSizeChanges),
                    //             child: const Text("Tap to retry",
                    //                 style: AppTypography.undefinedTextStyle))))
                         CommonBanner(
                           isHomeScreen: true,
                        bannerList: homeState.banners.value,
                        isShowPlayButton: true,
                        isShowNotifyButton: false,
                        isShowPlayWithWatchListButton: false,
                        onCardPressed: (index) {
                          homeState.banners.value[index].action.executeAction(context);
                          //eventCall.bannerClickEvent('home_screen');
                        }),
                    Container(
                        color: Colors.black.withOpacity(0.800000011920929),
                        child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MoodSuggestionRailView(moodTitle:widget.moodTitle,rows: widget.rows,),
                            ])),
                  ])))

      ),
    );

  }

  @override
  bool get wantKeepAlive => true;
}
