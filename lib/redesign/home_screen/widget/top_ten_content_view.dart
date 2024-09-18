import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/home_screen/widget/latest_content.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../assets.dart';

class TopTenContentView extends StatefulWidget {
  const TopTenContentView({super.key});

  @override
  State<TopTenContentView> createState() => _TopTenContentViewState();
}

class _TopTenContentViewState extends State<TopTenContentView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  List<MediaRow> filterByChannelList =[];
  List<String> tabTitles =['Movies', 'Shows'];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
 filterByChannelList = homeState.rows.value
        .where((title) => title.title=="Dor's Film Fest - Top 10 Movies"||title.title=="Binge Party - Dor's Top 10 Shows")
        .toList();
    return filterByChannelList.isEmpty
        ? const SizedBox()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
       Padding(
          padding: EdgeInsets.only(left: 16.0, top: 32),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'DOR’s ',
                  style: GoogleFonts.dmSerifDisplay(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.20,
                  ),
                ),
                TextSpan(
                  text: 'top 10',
                  style: GoogleFonts.dmSerifDisplay(
                    color: Color(0xFFFF323B),
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.20,
                  ),
                ),
                TextSpan(
                  text: ' content curated from your apps',
                  style: GoogleFonts.dmSerifDisplay(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.20,
                  ),
                ),
              ],
            ),
          )),
      const SizedBox(height: 10),
      ValueListenableBuilder(
          valueListenable: homeState.rows,
          builder: (context, value, child) {
            List<MediaRow> filterByChannelList  = homeState.rows.value
                .where((title) => title.title=="Dor's Film Fest - Top 10 Movies"||title.title=="Binge Party - Dor's Top 10 Shows")
                .toList();
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
                  tabs: tabTitles.map((category) => Tab(text: category)).toList()),
              Container(
                  height: 1,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: const Color(0xFF4D4D4D)),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: double.infinity,
                  child: TabBarView(
                      controller: _tabController,
                      children: filterByChannelList.map((category) {
                        return OTTProviderGridView(items: category.mediaItems,isIconPresent: true,indexPresent: true,crossAxisCount: 1,);
                      }).toList()))
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