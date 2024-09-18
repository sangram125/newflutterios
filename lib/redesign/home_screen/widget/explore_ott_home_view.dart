import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/redesign/home_screen/widget/latest_content.dart';
import 'package:dor_companion/redesign/home_screen/widget/ott_explore_detail_view.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:dor_companion/widgets/custom_button.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreOttHomeView extends StatefulWidget {
  const ExploreOttHomeView({super.key});

  @override
  State<ExploreOttHomeView> createState() => _ExploreOttHomeViewState();
}

class _ExploreOttHomeViewState extends State<ExploreOttHomeView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MediaRow> filterByChannelList = [];
  List<MediaRow> exploreRows = [];

  @override
  void initState() {
    super.initState();
    filterByChannelList = homeState.rows.value
        .where((title) => title.title=='Explore the OTT World')
        .toList();
    print("explore rows ${filterByChannelList.length}");
    print("exp ${filterByChannelList.elementAt(0).mediaItems.length}");

    getIt<SensyApi>().fetchMediaDetail("pr_app",filterByChannelList.elementAt(0).mediaItems.elementAt(0).itemID).then((mediaDetail) {
      exploreRows = [];
      exploreRows = mediaDetail.mediaRows;
    setState(() {

    });

    });
    _tabController = TabController(length:filterByChannelList.elementAt(0).mediaItems.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    print("lengty media item ${filterByChannelList.elementAt(0).mediaItems.length}");
    print("tab length ${_tabController!.length}");
    return filterByChannelList.isEmpty
        ? const SizedBox()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
       Center(
         child: Text.rich(
           TextSpan(
             children: [
               TextSpan(
                 text: 'Explore the',
                 style: GoogleFonts.dmSerifDisplay(
                   color: Colors.white,
                   fontSize: 32,
                   fontWeight: FontWeight.w400,
                   letterSpacing: 0.20,
                 ),
               ),
               TextSpan(
                 text: ' ',
                 style: GoogleFonts.dmSerifDisplay(
                   color: Color(0xFFFF323B),
                   fontSize: 32,
                   fontWeight: FontWeight.w400,
                   letterSpacing: 0.20,
                 ),
               ),
               TextSpan(
                 text: 'OTTs',
                 style: GoogleFonts.dmSerifDisplay(
                   color: Color(0xFF6C2DF3),
                   fontSize: 32,
                   fontWeight: FontWeight.w400,
                   letterSpacing: 0.20,
                 ),
               ),
             ],
           ),
           textAlign: TextAlign.center,
         ),
       ),
      const SizedBox(height: 10),
      ValueListenableBuilder(
          valueListenable: homeState.rows,
          builder: (context, value, child) {
            filterByChannelList = homeState.rows.value
                .where((title) => title.title=='Explore the OTT World')
                .toList();
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TabBar(
                onTap: (value){
                  exploreRows = [];
                  //filterByChannelList.elementAt(0).mediaItems.elementAt(0).actions[0].chatAction.executeAction(context, mediaItem: filterByChannelList.elementAt(0).mediaItems.elementAt(0));
                  print("value of tab ${value}");
                  getIt<SensyApi>().fetchMediaDetail("pr_app",filterByChannelList.elementAt(0).mediaItems.elementAt(value).itemID).then((mediaDetail) async {
                    exploreRows = await mediaDetail.mediaRows;
                    print("explore rows ${exploreRows.length}");
                    setState(() {

                    });
                  });
                },
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
                  tabs: filterByChannelList.first.mediaItems.map((category) =>
                      Tab(
                        child:Row(
                          children:[
                            Image.network(category.image,width: 25,height: 30,),
                            SizedBox(width: 5,),
                            Text(category.title,)
                          ]
                        ),
                        // icon: Image.network(category.imageHD,width: 24,height: 24,),
                        // text: category.title,
                      )).toList()
              ),
              Container(
                  height: 1,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: const Color(0xFF4D4D4D)),
              exploreRows.isEmpty? Loader():SizedBox(
                height:MediaQuery.of(context).size.height * 0.55,
                  //height: MediaQuery.of(context).size.height * 0.33,
                  width: double.infinity,
                  child: TabBarView(
                      controller: _tabController,
                      children: exploreRows.map((category) {
                        return OTTProviderGridView(isIconPresent:false,items: category.mediaItems,crossAxisCount: 2,);
                      }).toList())),
              Center(
                child: CustomButton(
                    onPressed: () async {
                      MediaHeader header =MediaHeader();
   await  getIt<SensyApi>().fetchMediaDetail("pr_app",filterByChannelList.elementAt(0).mediaItems.elementAt(_tabController!.index).itemID).then((mediaDetail) {
      exploreRows = [];
      header = mediaDetail.mediaHeader!;
      exploreRows = mediaDetail.mediaRows;
      setState(() {});
    });
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>  OttExploreDetailView(row: exploreRows, mediaHeader: header!,logoImage: filterByChannelList.elementAt(0).mediaItems.elementAt(_tabController!.index).image,)));

                    //  filterByChannelList.first.mediaItems.elementAt(_tabController!.index).actions[0].chatAction.executeAction(context, mediaItem: filterByChannelList.elementAt(0).mediaItems.elementAt(_tabController!.index));
                }, text: 'Explore ${filterByChannelList.first.mediaItems.elementAt(_tabController!.index).title}',
                ),
              )
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
