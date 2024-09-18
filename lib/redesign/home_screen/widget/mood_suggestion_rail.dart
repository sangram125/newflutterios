import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/home_screen/widget/latest_content.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodSuggestionRailView extends StatefulWidget {
  String moodTitle;
  List<MediaRow> rows;
  MoodSuggestionRailView({super.key, this.moodTitle = '',required this.rows});

  @override
  State<MoodSuggestionRailView> createState() => _MoodSuggestionRailViewState();
}

class _MoodSuggestionRailViewState extends State<MoodSuggestionRailView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MediaRow> filterByChannelList = [];

  @override
  void initState() {
    super.initState();
    filterByChannelList = widget.rows;
    print("widget.row s${widget.rows.length}");
    _tabController =
        TabController(length: filterByChannelList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return filterByChannelList.isEmpty
        ? const Text('')
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 32),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: widget.moodTitle,
                            style: GoogleFonts.dmSerifDisplay(
                              color: AppColors.colorPop,
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20,
                            )),
                        TextSpan(
                            text: ' content curated from your apps',
                            style: GoogleFonts.dmSerifDisplay(
                              color: AppColors.whiteColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder(
                    valueListenable: homeState.moodRows,
                    builder: (context, value, child) {
                      filterByChannelList = widget.rows;
                      print("widget.row s${widget.rows.length}");
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TabBar(
                            //     tabAlignment: TabAlignment.start,
                            //     controller: _tabController,
                            //     isScrollable: true,
                            //     padding: EdgeInsets.zero,
                            //     dividerColor: Colors.transparent,
                            //     indicatorColor: const Color(0xFFBE2C36),
                            //     unselectedLabelStyle: const TextStyle(
                            //         color: Color(0xFF808080),
                            //         fontFamily: 'DMSans',
                            //         letterSpacing: 0.20,
                            //         fontWeight: FontWeight.w500,
                            //         fontSize: 14),
                            //     labelStyle: const TextStyle(
                            //         color: Colors.white,
                            //         fontFamily: 'DMSans',
                            //         letterSpacing: 0.20,
                            //         fontWeight: FontWeight.w500,
                            //         fontSize: 14),
                            //     tabs: filterByChannelList.map((category) => Tab(text: category.title.substring(12))).toList()),
                            Container(
                                height: 1,
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                color: const Color(0xFF4D4D4D)),
                            SizedBox(
                                height: MediaQuery.of(context).size.height * 0.55,
                                width: double.infinity,
                                child: TabBarView(
                                    controller: _tabController,
                                    children:
                                        filterByChannelList.map((category) {
                                      return OTTProviderGridView(
                                        items: category.mediaItems,
                                        isIconPresent: true,
                                        crossAxisCount: 2,
                                      );
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