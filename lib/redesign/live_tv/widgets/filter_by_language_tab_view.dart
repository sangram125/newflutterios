import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/live_tv/tv_guide_screen.dart';
import 'package:flutter/material.dart';

class FilterByLanguageTabView extends StatefulWidget {
  const FilterByLanguageTabView({super.key});

  @override
  State<FilterByLanguageTabView> createState() => _FilterByLanguageTabViewState();
}

class _FilterByLanguageTabViewState extends State<FilterByLanguageTabView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MediaRow> filterByChannelList = [];

  @override
  void initState() {
    super.initState();
    filterByChannelList = appState.loadingPageRows.value
        .where((title) => title.title != "Dor's Top Drama Recommendations")
        .toList();
    _tabController = TabController(length: filterByChannelList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return filterByChannelList.isEmpty
        ? const SizedBox()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 32),
                child: Text('Filter by Language',
                    style: TextStyle(
                        fontFamily: 'DMSerifDisplay',
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.20,
                        color: Colors.white))),
            const SizedBox(height: 20),
            ValueListenableBuilder(
                valueListenable: appState.loadingPageRows,
                builder: (context, value, child) {
                  filterByChannelList = appState.loadingPageRows.value
                      .where((title) => title.title != "Dor's Top Drama Recommendations")
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
                        tabs: filterByChannelList.map((category) => Tab(text: category.title)).toList()),
                    Container(
                        height: 1,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: const Color(0xFF4D4D4D)),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.33,
                        width: double.infinity,
                        child: TabBarView(
                            controller: _tabController,
                            children: filterByChannelList.map((category) {
                              return OTTProviderGrid(items: category.mediaItems, language: category.title);
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

class OTTProviderGrid extends StatelessWidget {
  final List<MediaItem> items;
  final String language;

  const OTTProviderGrid({Key? key, required this.items, required this.language}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 30, mainAxisSpacing: 20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          debugPrint('item image: ${item.toJson()}');
          return GestureDetector(
            onTap: () {
              log('item --------id: ${item.toJson()}');
              if (appState.filteredChannels.value
                  .any((element) => element.id.toString() == item.itemID.toString())) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TvGuideScreen(channelId: item.itemID, language: language)));
              } else {
             //   item.actions[0].chatAction.executeAction(context, mediaItem: item);
              }
            },
            child: Stack(children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                          width: 150,
                          height: 118,
                          child: CachedNetworkImage(imageUrl: item.image, fit: BoxFit.cover)))),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: 16,
                      height: 16,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                          image: DecorationImage(image: NetworkImage(item.imageHD), fit: BoxFit.fill),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))))
            ]),
          );
        });
  }
}
