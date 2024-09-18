import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/redesign/home_screen/widget/ott_explore_detail_view.dart';
import 'package:flutter/material.dart';
import '../../data/api/sensy_api.dart';
import '../../data/models/constants.dart';

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
  int index=0;

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
          image: imageList[i].image,
          mediaItems: filterByChannelList[i].mediaItems));
    }
    _tabController = TabController(length: finalList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return finalList.isEmpty
        ? const SizedBox()
        : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('Tournament based on OTT',
                style: AppTypography.bodyLabel(14,Colors.grey),
            ),
          ),
      const Padding(
          padding: EdgeInsets.only(left: 16.0,bottom: 10),
          child: Text('Sports By Platform',
              style: TextStyle(
                  fontFamily: 'DMSerifDisplay',
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.20,
                  color: Colors.white)),
      ),
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
                  onTap: (value) {
                    index = value;
                    setState(() {

                    });
                  },
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
                        return AppsGrid(items: category.mediaItems, firstImage: imageList[index]);
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

// class AppsGrid extends StatelessWidget {
//   final List<MediaItem> items;
//   final MediaItem firstImage;
//
//   const AppsGrid({Key? key, required this.items, required this.firstImage}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () {
//             //item.actions[0].chatAction.executeAction(context, mediaItem: item);
//             firstImage.actions[0].chatAction.executeAction(context);
//
//           },
//           child: SizedBox(
//             width: 132,
//             height: 132,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(24),
//               child: CachedNetworkImage(imageUrl: firstImage.image, fit: BoxFit.cover),
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             physics: BouncingScrollPhysics(),
//             padding: const EdgeInsets.all(16),
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               final item = items[index];
//               return Padding(
//                 padding: const EdgeInsets.only(right: 20),
//                 child:  GestureDetector(
//                   onTap: () => item.actions[0].chatAction.executeAction(context, mediaItem: item),
//                   child: SizedBox(
//                     width: 198,
//                     height: 132,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(24),
//                       child: CachedNetworkImage(imageUrl: item.image, fit: BoxFit.cover),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

class AppsGrid extends StatefulWidget {
  final List<MediaItem> items;
  final MediaItem firstImage;

   AppsGrid({Key? key, required this.items, required this.firstImage}) : super(key: key);

  @override
  State<AppsGrid> createState() => _AppsGridState();
}

class _AppsGridState extends State<AppsGrid> {
List<MediaRow> row = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                  MediaHeader header =MediaHeader();
                  await  getIt<SensyApi>().fetchMediaDetail("pr_app",widget.firstImage.itemID).then((mediaDetail) {
                    row = [];
                header = mediaDetail.mediaHeader!;
                    row = mediaDetail.mediaRows;
                setState(() {});
                });
                Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  OttExploreDetailView(row: row, mediaHeader: header!,
                  logoImage:  widget.firstImage.image,)));
                //widget.firstImage.actions[0].chatAction.executeAction(context);
              },
              child: SizedBox(
                width: 132,
                height: 132,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CachedNetworkImage(imageUrl: widget.firstImage.image, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(width: 20), // Add some space between the first image and the list
            ...widget.items.map((item) => Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () => item.actions[0].chatAction.executeAction(context, mediaItem: item),
                child: SizedBox(
                  width: 198,
                  height: 132,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: CachedNetworkImage(imageUrl: item.image, fit: BoxFit.cover),
                  ),
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}