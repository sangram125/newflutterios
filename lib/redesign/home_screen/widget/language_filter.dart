import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/home_screen/widget/latest_content.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:flutter/material.dart';

class HomePageLanguageTabView extends StatefulWidget {
  const HomePageLanguageTabView({super.key});

  @override
  State<HomePageLanguageTabView> createState() => _HomePageLanguageTabViewState();
}

class _HomePageLanguageTabViewState extends State<HomePageLanguageTabView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MediaRow> filterByChannelList = [];

  @override
  void initState() {
    super.initState();
    filterByChannelList = homeState.rows.value
        .where((title) => title.title.contains('Trending in'))
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
          child: Text('Trending content curated from your apps',
              style: TextStyle(
                  fontFamily: 'DMSerifDisplay',
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.20,
                  color: Colors.white))),
      const SizedBox(height: 20),
      ValueListenableBuilder(
          valueListenable: homeState.rows,
          builder: (context, value, child) {
            filterByChannelList = homeState.rows.value
                .where((title) => title.title.contains('Trending in'))
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
                  tabs: filterByChannelList.map((category) => Tab(text: category.title.substring(12))).toList()),
              Container(
                  height: 1,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: const Color(0xFF4D4D4D)),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  child: TabBarView(
                      controller: _tabController,
                      children: filterByChannelList.map((category) {
                        return OTTProviderGridView(items: category.mediaItems,isIconPresent: true,crossAxisCount: 2,);
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

  const OTTProviderGrid({Key? key, required this.items}) : super(key: key);
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 30, mainAxisSpacing: 20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final watchOnAction = getFirstWatchOnActionOrNull(items.elementAt(index).actions);
          return GestureDetector(
            onTap: () => item.actions[0].chatAction.executeAction(context, mediaItem: item),
            child: Stack(children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                          width: 150,
                          height: 118,
                          child: CachedNetworkImage(imageUrl: item.imageHD, fit: BoxFit.fill)))),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.all( Radius.circular(2),
                      ),),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2),
                              ),
                              child: Image.network(watchOnAction!.icon ?? '', fit: BoxFit.cover,width: 20,height: 20,)),
                          // Text(" +3 More", style: AppTypography.bodyLabel(10,AppColors.whiteColor400),)
                        ],
                      ),
                    ),
                  ))
            ]),
          );
        });
  }
}
