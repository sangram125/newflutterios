import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/widgets/thumbnail_protrait_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OTTExplorer extends StatefulWidget {
  bool isStartIcon;
  bool isLogoAvailable;
  String title;
  List<MediaItem> mediaItem;
  List<MediaRow> rows ;
  int tabBarLength;
  String contentTitle;
  List<Map<String, dynamic>> languageList;
  OTTExplorer({Key? key, this.title='',this.isLogoAvailable=false,this.isStartIcon=false,required this.mediaItem, required
  this.rows, this.tabBarLength = 1,this.contentTitle = '', required this.languageList}) : super(key: key);

  @override
  _OTTExplorerPageState createState() => _OTTExplorerPageState();
}

class _OTTExplorerPageState extends State<OTTExplorer> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<OTTProvider> providers = [];
  @override
  void initState() {
    super.initState();
    providers.addAll([
      {
        "name": "Movies",
        "logo": Assets.assets_images_amazon_prime_prime_video_svg,
        "shows": [
          "Show1",
          "Show2",
          "Show3",
          "Show4",
          "Show5",
          "Show6",
          "Show7",
          "Show8",
          "Show9",
          "Show10",
          "Show11",
          "Show12"
        ]
      },
      {
        "name": "TV Shows",
        "logo": Assets.assets_images_amazon_prime_prime_video_svg,
        "shows": [
          "Show1",
          "Show2",
          "Show3",
          "Show4",
          "Show5",
          "Show6",
          "Show7",
          "Show8",
          "Show9",
          "Show10",
          "Show11",
          "Show12"
        ]
      },
      {
        "name": "Documentries",
        "logo": Assets.assets_images_amazon_prime_prime_video_svg,
        "shows": [
          "Show1",
          "Show2",
          "Show3",
          "Show4",
          "Show5",
          "Show6",
          "Show7",
          "Show8",
          "Show9",
          "Show10",
          "Show11",
          "Show12"
        ]
      }
    ].map((item) => OTTProvider.fromJson(item)).toList());
    _tabController = TabController(length:(widget.languageList.isNotEmpty && !widget.isLogoAvailable) ? widget.languageList.length : widget.isLogoAvailable ? widget.mediaItem.length: providers.length, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    print("is logo avalilba e${widget.rows.length}");
    if(widget.isLogoAvailable) {
      widget.mediaItem.map((value) {
        print("image value ${value.imageHD}");
      });
    }
    return  Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFF4D0CDA), Color(0xFF733FE2)],
          ),
        ),
        child: Column(children: [
          widget.isStartIcon ? Icon(Icons.star, color: Colors.purple, size: 30):SizedBox.shrink(),
          const SizedBox(height: 10),
          Text(widget.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          if (_tabController != null)
            TabBar(
                tabAlignment: TabAlignment.start,
                controller: _tabController,
                isScrollable: true,
                dividerColor: const Color(0xFF4D4D4D),
                indicatorColor: const Color(0xFFBE2C36),
                unselectedLabelStyle:
                const TextStyle(color: Color(0xFF808080), fontWeight: FontWeight.w500, fontSize: 14),
                labelStyle:
                const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                tabs: widget.languageList.isNotEmpty && !widget.isLogoAvailable ? widget.languageList.map((value){
                  print("language value ${value}");
                  return Tab(
                      height: 70,
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const SizedBox(width: 5),
                        Text(value.toString())
                      ]));}).toList():
                widget.isLogoAvailable ? widget.mediaItem.map((value){
                  print("image value ${value.imageHD}");
                  return Tab(
                      height: 70,
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        widget.isLogoAvailable? Image.network(value.image,width: 24,height: 24,):Text(""),
                        const SizedBox(width: 5),
                        Text(value.title)
                      ]));}).toList() :
                providers
                    .map((provider) => Tab(
                    height: 70,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      widget.isLogoAvailable? SvgPicture.asset(provider.logo):Text(""),
                      const SizedBox(width: 5),
                      Text(provider.name)
                    ])))
                    .toList()),
          Expanded(
            child: !widget.isLogoAvailable ? TabBarView(
              controller: _tabController,

              children:[
                if(widget.rows.any((item) => item.title == 'Latest Movies'))
                  OTTProviderGrid(mediaItem: widget.rows.elementAt(0).mediaItems),
                if(widget.rows.any((item) => item.title == 'Latest Movies'))
                  OTTProviderGrid(mediaItem: widget.rows.elementAt(0).mediaItems),
                if(widget.rows.any((item) => item.title == "Dor's Film Fest - Top 10 Movies"))
                  ListView.builder(
                      itemCount:widget.rows.elementAt(0).mediaItems.length,
                      scrollDirection:Axis.horizontal,
                      itemBuilder: (context, i) {
                        //final watchOnAction = getFirstWatchOnActionOrNull(rows.elementAt(index-1).mediaItems.elementAt(i).actions);

                        return  ThumbnailProtraitWidget(isTopPresent: false,isIconPresent: false,
                          // isIconPresent: watchOnAction != null? true : false,
                          imageUrl: widget.rows.elementAt(0).mediaItems.elementAt(i).image,
                          //  logoUrl: watchOnAction == null ? "" :watchOnAction!.icon,
                        );}),
                if(widget.rows.any((item) => item.title == "Binge Party - Dor's Top 10 Shows"))
                  ListView.builder(
                      itemCount:widget.rows.elementAt(1).mediaItems.length,
                      scrollDirection:Axis.horizontal,
                      itemBuilder: (context, i) {
                        //final watchOnAction = getFirstWatchOnActionOrNull(rows.elementAt(index-1).mediaItems.elementAt(i).actions);

                        return  ThumbnailProtraitWidget(isTopPresent: false,
                          isIconPresent: false,
                          imageUrl: widget.rows.elementAt(1).mediaItems.elementAt(i).image,
                          //  logoUrl: watchOnAction == null ? "" :watchOnAction!.icon,
                        );}),

                Text("r")
              ]  ,
              //children: providers.map((provider) => OTTProviderGrid(mediaItem: widget.mediaItem)).toList()
            ): TabBarView(
              controller: _tabController,

              children:  widget.mediaItem.map((value) {
                // int index = entry.key;       // Index of the current item
                // var value = entry.value;     // The current item

                // Construct the OTTProviderGrid widget based on the index and item
                return OTTProviderGrid(
                  mediaItem: widget.mediaItem,  // Assuming `value` has `mediaItems`
                );
              }).toList(),


              //children: providers.map((provider) => OTTProviderGrid(mediaItem: widget.mediaItem)).toList()
            ),),
          const SizedBox(height: 20),
          const Icon(Icons.star, color: Colors.purple, size: 30),
          const SizedBox(height: 30)
        ]));
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }
}

class OTTProvider {
  final String name;
  final String logo;
  final List<String> shows;

  OTTProvider({required this.name, required this.logo, required this.shows});

  factory OTTProvider.fromJson(Map<String, dynamic> json) {
    return OTTProvider(name: json['name'], logo: json['logo'], shows: List<String>.from(json['shows']));
  }
}

class OTTProviderGrid extends StatelessWidget {
  final List<MediaItem> mediaItem;

  const OTTProviderGrid({Key? key, required this.mediaItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: mediaItem.length,
        itemBuilder: (context, index) {
          return ClipRRect(
              borderRadius:  BorderRadius.circular(20),
              child: Image.network(mediaItem.elementAt(index).image, fit: BoxFit.fill,));
        });
  }
}
