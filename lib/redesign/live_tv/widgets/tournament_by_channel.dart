import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:flutter/material.dart';

class TournamentModel {
  final String image;
  final String title;
  final List<MediaItem> mediaItems;

  TournamentModel({required this.title, required this.image, required this.mediaItems});
}

class TournamentByChannel extends StatefulWidget {
  const TournamentByChannel({super.key});

  @override
  State<TournamentByChannel> createState() => _TournamentByChannelState();
}

class _TournamentByChannelState extends State<TournamentByChannel> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MediaRow> filterByChannelList = [];
  List<MediaItem> imageList = [];

  List<TournamentModel> finalList = [];

  @override
  void initState() {
    super.initState();

    imageList = sportsAppState.rows.value
        .where((row) => row.title == 'Watch by apps')
        .expand((row) => row.mediaItems)
        .toList();

    filterByChannelList = sportsAppState.rows.value
        .where((title) => (title.title == 'Tournaments on Jio Cinema' ||
            title.title == 'Tournaments on Hotstar' ||
            title.title == 'Tournaments on Sony LIV' ||
            title.title == 'Tournaments on Fancode'))
        .toList();

    for (int i = 0; i < imageList.length; i++) {
      finalList.add(TournamentModel(
          title: filterByChannelList[i].title,
          image: imageList[i].imageHD,
          mediaItems: filterByChannelList[i].mediaItems));
    }
    _tabController = TabController(length: finalList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return finalList.isEmpty
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
                valueListenable: sportsAppState.rows,
                builder: (context, value, child) {
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
                        tabs: finalList
                            .map((category) =>
                                Tab(text: category.title.toString().replaceAll('Tournaments on ', '')))
                            .toList()),
                    Container(
                        height: 1,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: const Color(0xFF4D4D4D)),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: double.infinity,
                        child: TabBarView(
                            controller: _tabController,
                            children: finalList.map((category) {
                              return OTTProviderGrid(items: category.mediaItems, firstImage: category.image);
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
  final String firstImage;

  const OTTProviderGrid({Key? key, required this.items, required this.firstImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, childAspectRatio: 0.8, crossAxisSpacing: 30, mainAxisSpacing: 20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => item.actions[0].chatAction.executeAction(context, mediaItem: item),
            child: index == 0
                ? SizedBox(
                    width: 100,
                    height: 100,
                    child: CachedNetworkImage(imageUrl: firstImage, fit: BoxFit.cover))
                : Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: SizedBox(
                            width: 150,
                            height: 118,
                            child: CachedNetworkImage(imageUrl: item.image, fit: BoxFit.cover)))),
          );
        });
  }
}

// class TournamentByChannel extends StatelessWidget {
//   const TournamentByChannel({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     List<MediaRow> topRecommendationList = sportsAppState.rows.value
//         .where((title) => (title.title == 'Tournaments on Jio Cinema' ||
//             title.title == 'Tournaments on Hotstar' ||
//             title.title == 'Tournaments on Sony LIV' ||
//             title.title == 'Tournaments on Fancode'))
//         .toList();
//     return topRecommendationList.isEmpty
//         ? const SizedBox()
//         : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             const Padding(
//                 padding: EdgeInsets.only(left: 20),
//                 child: Text("Dor's Top Drama Recommendations",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         letterSpacing: 0.20,
//                         fontSize: 14,
//                         color: Color(0xFF999999),
//                         fontFamily: 'DMSans',
//                         fontWeight: FontWeight.w400))),
//             const Padding(
//                 padding: EdgeInsets.only(left: 20),
//                 child: Text("Top dramas",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         letterSpacing: 0.20,
//                         fontSize: 28,
//                         color: Colors.white,
//                         fontFamily: 'DMSerifDisplay',
//                         fontWeight: FontWeight.w400))),
//             const SizedBox(height: 20),
//             ValueListenableBuilder(
//                 valueListenable: sportsAppState.rows,
//                 builder: (context, value, child) {
//                   List<MediaRow> topRecommendationList = sportsAppState.rows.value
//                       .where((title) => (title.title == 'Tournaments on Jio Cinema' ||
//                       title.title == 'Tournaments on Hotstar' ||
//                       title.title == 'Tournaments on Sony LIV' ||
//                       title.title == 'Tournaments on Fancode'))
//                       .toList();
//                   return SizedBox(
//                       height: 208,
//                       width: double.infinity,
//                       child: GridView.builder(
//                           shrinkWrap: true,
//                           scrollDirection: Axis.horizontal,
//                           padding: const EdgeInsets.only(left: 16),
//                           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                               childAspectRatio: 1.45, crossAxisCount: 1, mainAxisSpacing: 12),
//                           itemCount: topRecommendationList.first.mediaItems.length,
//                           itemBuilder: (context, index) {
//                             return GestureDetector(
//                               onTap: () => topRecommendationList.first.mediaItems[index].actions[0].chatAction
//                                   .executeAction(context,
//                                       mediaItem: topRecommendationList.first.mediaItems[index]),
//                               child: SizedBox(
//                                   width: 132,
//                                   height: 208,
//                                   child: Stack(children: [
//                                     Container(
//                                         width: 132,
//                                         height: 198,
//                                         clipBehavior: Clip.antiAlias,
//                                         decoration: ShapeDecoration(
//                                             image: DecorationImage(
//                                                 image: NetworkImage(
//                                                     topRecommendationList.first.mediaItems[index].image),
//                                                 fit: BoxFit.cover),
//                                             shape: RoundedRectangleBorder(
//                                                 side: const BorderSide(width: 1, color: Color(0xFF1F1F1F)),
//                                                 borderRadius: BorderRadius.circular(24)))),
//                                     Align(
//                                         alignment: Alignment.bottomCenter,
//                                         child: Container(
//                                             width: 16,
//                                             height: 16,
//                                             clipBehavior: Clip.antiAlias,
//                                             decoration: ShapeDecoration(
//                                                 image: DecorationImage(
//                                                     image: NetworkImage(topRecommendationList
//                                                         .first.mediaItems[index].imageHD),
//                                                     fit: BoxFit.fill),
//                                                 shape: RoundedRectangleBorder(
//                                                     borderRadius: BorderRadius.circular(4)))))
//                                   ])),
//                             );
//                           }));
//                 })
//           ]);
//   }
// }
