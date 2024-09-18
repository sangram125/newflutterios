import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/home_screen/widget/latest_content.dart';
import 'package:dor_companion/sdk_action_manager.dart';
import 'package:dor_companion/widgets/appbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecialCollectionListView extends StatefulWidget {
  List<MediaRow> rows;
  SpecialCollectionListView({super.key, required this.rows});

  @override
  State<SpecialCollectionListView> createState() =>
      _SpecialCollectionListViewState();
}

class _SpecialCollectionListViewState extends State<SpecialCollectionListView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MediaRow> filterByChannelList = [];

  @override
  void initState() {
    super.initState();
    filterByChannelList = widget.rows;
    _tabController =
        TabController(length: filterByChannelList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(showIcon: true, pageText: '',

        ),
        body: widget.rows.isEmpty
            ? const SizedBox()
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 32),
                  child: Text(
                    widget.rows.elementAt(0).title,
                    style: const TextStyle(
                      fontFamily: 'DMSerifDisplay',
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: homeState.rows,
                  builder: (context, value, child) {
                    // Flatten the media items list
                    final mediaItems = filterByChannelList
                        .expand((category) => category.mediaItems)
                        .toList();

                    return Expanded(
                      child: OTTProviderGridViewSpecial(items: mediaItems,isIconPresent: true,crossAxisCount: 3,),
                    );
                  },
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}

class OTTProviderGridViewSpecial extends StatelessWidget {
  final List<MediaItem> items;
  bool isIconPresent;
  bool indexPresent;
  int crossAxisCount;

  OTTProviderGridViewSpecial({Key? key, required this.items, this.isIconPresent = false, this.indexPresent=false,required this.crossAxisCount}) : super(key: key);
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
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16),
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.7, crossAxisCount: crossAxisCount, mainAxisSpacing: indexPresent ?30 :15,crossAxisSpacing: 10),
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
