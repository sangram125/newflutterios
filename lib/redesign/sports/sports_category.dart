import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/redesign/live_tv/widgets/card_banners.dart';
import 'package:dor_companion/redesign/sports/sports_detail_vm.dart';
import 'package:dor_companion/redesign/sports/widget/selected_sports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SportsCategory extends StatefulWidget {
  List<MediaRow> rows;
  String moodTitle;
   List<MediaItem>? sportsCategoryList;
  SportsCategory({
    Key? key,
    required this.rows, this.moodTitle='', this.sportsCategoryList
  }) : super(key: key);

  @override
  State<SportsCategory> createState() => _SportsCategoryState();
}

class _SportsCategoryState extends State<SportsCategory> with AutomaticKeepAliveClientMixin {

  late SportsDetailVm sportsDetailVm;

  @override
  void initState() {
    sportsDetailVm= Provider.of<SportsDetailVm>(context, listen: false);
    sportsDetailVm.setData(widget.moodTitle, widget.sportsCategoryList??[], widget.rows);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PerformanceTrackedWidget(
      widgetName: 'sports-category-view',
      child: Scaffold(
          appBar: buildAppBar(context),
          backgroundColor: Colors.black,
          body: SafeArea(
              child: SingleChildScrollView(
                  child:  Column(children: [
                    sportsAppState.banners.value.isEmpty
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
                        bannerList: sportsAppState.banners.value,
                        isShowPlayButton: true,
                        isShowNotifyButton: false,
                        isShowPlayWithWatchListButton: false,
                        onCardPressed: (index) {
                          sportsAppState.banners.value[index].action.executeAction(context);
                          //eventCall.bannerClickEvent('home_screen');
                        }),
                    Consumer<SportsDetailVm>(
                      builder: (context, value, child) => Container(
                        color: Colors.black.withOpacity(0.800000011920929),
                        child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: value.sportsRow.map((category) {
                              return SelectedSports(
                                rows: category.mediaItems,
                                moodTitle: category.title,);
                            }).toList()),
                      ),
                    ),
                  ],
                  ),
              ),
          ),
      ),
    );

  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
          elevation: 0,
          titleSpacing: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    "assets/icons/left_arrow.svg",
                    alignment: Alignment.topLeft,
                    height: 24,
                    width: 24,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sports category",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 11,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.20,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Consumer<SportsDetailVm>(
                      builder: (context, value, child) =>
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              barrierColor: Colors.black.withOpacity(0.800000011920929),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(32), topRight: Radius.circular(32))),
                              constraints:
                              BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder: (context, setState) {
                                  return Container(
                                      decoration: const ShapeDecoration(
                                          color: Color(0xFF171717),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(32),
                                                  topRight: Radius.circular(32)))),
                                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                                        const SizedBox(height: 12),
                                        Container(
                                            width: 55,
                                            height: 4,
                                            decoration: ShapeDecoration(
                                                color: const Color(0xFF4D4D4D),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(200)))),
                                        const SizedBox(height: 32),
                                        const Text('SELECT SPORTS CATEGORY',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'DMSans',
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 2)),
                                        const SizedBox(height: 24),
                                        Expanded(
                                            child: Consumer<SportsDetailVm>(
                                                builder: (context, tvGuideProvider, child) =>
                                                    ListView.builder(
                                                        itemCount: tvGuideProvider.sportsList.length,
                                                        shrinkWrap: true,
                                                        padding:
                                                        const EdgeInsets.symmetric(horizontal: 16)
                                                            .copyWith(bottom: 16),
                                                        itemBuilder: (context, index) {
                                                          final data = tvGuideProvider.sportsList[index];
                                                          return InkWell(
                                                            onTap: () async {
                                                              Navigator.pop(context);
                                                             tvGuideProvider
                                                                 .changeSportsType(data.title);
                                                            },
                                                            child: Container(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 24, vertical: 12),
                                                                margin: const EdgeInsets.only(bottom: 10),
                                                                decoration: ShapeDecoration(
                                                                    color: const Color(0xFF0E0E0E),
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            width: 1,
                                                                            color: data.selected ??false
                                                                                ? const Color(0xFF666666)
                                                                                : Colors.transparent),
                                                                        borderRadius:
                                                                        BorderRadius.circular(12))),
                                                                child: Row(children: [
                                                                  Text(data.title,
                                                                      textAlign: TextAlign.center,
                                                                      style: const TextStyle(
                                                                          color: Color(0xFFE5E5E5),
                                                                          fontSize: 13,
                                                                          fontFamily: 'DMSans',
                                                                          fontWeight: FontWeight.w500,
                                                                          letterSpacing: 0.20)),
                                                                  const Spacer(),
                                                                  Visibility(
                                                                      visible: data.selected??false,
                                                                      child: const Icon(Icons.done,
                                                                          size: 16))
                                                                ])),
                                                          );
                                                        })))
                                      ]));
                                });
                              }).whenComplete(() {
                                setState(() {
                                });
                              },);
                        },
                        child: Row(
                          children: [
                            Text(
                              value.sportType!.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(width: 10,),
                            SvgPicture.asset(
                              "assets/icons/down_arrow.svg",
                              alignment: Alignment.topRight,
                              height: 14,
                              width: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(right: 10),
            //   child: SvgPicture.asset(
            //     "assets/icons/search.svg",
            //     alignment: Alignment.topRight,
            //     height: 24,
            //     width: 24,
            //   ),
            // ),
          ],
        );
  }

  @override
  bool get wantKeepAlive => true;
}


