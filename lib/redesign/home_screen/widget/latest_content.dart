import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:dor_companion/widgets/custom_button.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LatestContentView extends StatefulWidget {
  List<MediaRow> rows;
   LatestContentView({super.key, required this.rows});

  @override
  State<LatestContentView> createState() => _LatestContentViewState();
}

class _LatestContentViewState extends State<LatestContentView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MediaRow> filterByChannelList = [];
  List<String> tabTitles =['Movies', 'Shows'];


  @override
  void initState() {
    super.initState();
    filterByChannelList = widget.rows
        .where((title) => title.title=='Latest Movies'|| title.title=='Latest Shows' )
        .toList();
    _tabController = TabController(length:tabTitles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return filterByChannelList.isEmpty
        ? const SizedBox()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
       Padding(
          padding: EdgeInsets.only(left: 16.0, top: 32),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Latest content',
                  style: GoogleFonts.dmSerifDisplay(
                    color: AppColors.colorPop,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.20,
                  ),
                ),
                TextSpan(
                  text: ' curated from your apps',
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
            filterByChannelList = widget.rows
                .where((title) => title.title=='Latest Movies'|| title.title=='Latest Shows')
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

class OTTProviderGridView extends StatelessWidget {
  final List<MediaItem> items;
  bool isIconPresent;
  bool indexPresent;
  int crossAxisCount;

   OTTProviderGridView({Key? key, required this.items, this.isIconPresent = false, this.indexPresent=false,required this.crossAxisCount}) : super(key: key);
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
    return GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.45, crossAxisCount: crossAxisCount, mainAxisSpacing: indexPresent ?30 :15,crossAxisSpacing: 30),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final watchOnAction = getFirstWatchOnActionOrNull(items.elementAt(index).actions);
          final item = items[index];
          return GestureDetector(
            onTap: () => item.actions[0].chatAction.executeAction(context, mediaItem: item),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: CachedNetworkImage(imageUrl: item.image, fit: BoxFit.fill))
                ),
                indexPresent==true?Positioned(
                  top: -20, // Position at the top of the Stack
                  left: -28, // Center horizontally
                  right: 0, // Center horizontally
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text((index+1).toString(),
                          style: GoogleFonts.dmSerifDisplay(fontSize: 60)
                      ),
                    ),
                  ),
                ):SizedBox.shrink() ,
                isIconPresent ? Positioned(
                  bottom: -13, // Aligns the icon to the bottom of the container
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black,
                        ),
                        padding: const EdgeInsets.all(2.0), // Padding around the icon
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            watchOnAction!.icon ?? '',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ):SizedBox.shrink(),
              ],
            ),
          );
        });
  }
}
