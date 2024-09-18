import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/redesign/home_screen/widget/latest_content.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:dor_companion/widgets/custom_button.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalisedCollectionForOttExploreView extends StatefulWidget {
  List<MediaRow> rows;
  String text1;
  String text2;
  bool isTwoLineText;
  PersonalisedCollectionForOttExploreView({super.key, required this.rows, required this.text1,
  required this.text2,required this.isTwoLineText});

  @override
  State<PersonalisedCollectionForOttExploreView> createState() => _PersonalisedCollectionForOttExploreViewState();
}

class _PersonalisedCollectionForOttExploreViewState extends State<PersonalisedCollectionForOttExploreView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MediaRow> filterByChannelList = [];
  List<String> tabTitles =['Movies', 'Shows'];


  @override
  void initState() {
    super.initState();
    filterByChannelList = widget.rows;

        // .where((title) => title.title.contains('Personalized Movie picks')||title.title.contains('Personalized TV Show picks'))
        // .toList();
    _tabController = TabController(length:filterByChannelList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return filterByChannelList.isEmpty
        ? const SizedBox()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      widget.isTwoLineText ?
       Padding(
         padding: EdgeInsets.only(left: 16.0, top: 32),
         child: Column(
          children: [
            Text(widget.text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 0.20,
                    fontSize: 14,
                    color: Color(0xFF999999),
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.w400)),
            Text(widget.text2 ,
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 0.20,
                    fontSize: 28,
                    color: Colors.white,
                    fontFamily: 'DMSerifDisplay',
                    fontWeight: FontWeight.w400)),
          ],
               ),
       ):
      Padding(
          padding: EdgeInsets.only(left: 16.0, top: 32),
          child:
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.text1,
                  style: GoogleFonts.dmSerifDisplay(
                    color: AppColors.colorPop,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.20,
                  ),
                ),
                TextSpan(
                  text: ' ${widget.text2}',
                  style: GoogleFonts.dmSerifDisplay(
                    color: AppColors.whiteColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.20,
                  ),
                ),
              ],
            ),
          )),
      ValueListenableBuilder(
          valueListenable: homeState.rows,
          builder: (context, value, child) {
            filterByChannelList = widget.rows;
                // .where((title) => title.title.contains('Personalized Movie picks')||title.title.contains('Personalized TV Show picks'))
                // .toList();
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TabBar(
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  isScrollable: true,
                  padding: EdgeInsets.zero,
                  dividerColor: Colors.transparent,
                  indicatorColor: const Color(0xFFBE2C36),
                  unselectedLabelStyle: const TextStyle(
                      color: Color(0xFF808080),
                      fontFamily: 'DMSans',
                      letterSpacing: 0.20,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  labelStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'DMSans',
                      letterSpacing: 0.20,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  tabs: tabTitles.map((category) =>
                      Tab(
                        text: category,
                      )).toList()
              ),
              Container(
                  height: 1,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: const Color(0xFF4D4D4D)),
              filterByChannelList.isEmpty? Loader():SizedBox(
                  height:MediaQuery.of(context).size.height * 0.55,
                  //height: MediaQuery.of(context).size.height * 0.33,
                  width: double.infinity,
                  child: TabBarView(
                      controller: _tabController,
                      children: filterByChannelList.map((category) {
                        return OTTProviderGridView(items: category.mediaItems,isIconPresent: true,crossAxisCount: 2,);
                      }).toList())),
            ]);
          })
    ]);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
