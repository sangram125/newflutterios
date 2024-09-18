import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:flutter/material.dart';

class SportNews extends StatefulWidget {
  const SportNews({super.key});

  @override
  State<SportNews> createState() => _SportNewsState();
}

class _SportNewsState extends State<SportNews> {
  List<MediaRow> sportsNewsList = [];

  @override
  void initState() {
    super.initState();
    sportsNewsList = sportsAppState.rows.value
        .where((row) => row.title == 'Sports News')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
            padding: EdgeInsets.only(left: 20,bottom: 16,right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sports News",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 0.20,
                        fontSize: 26,
                        color: Colors.white,
                        fontFamily: 'DMSerifDisplay',
                        fontWeight: FontWeight.w400)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'POWERED BY',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFFE5E5E5),
                        fontSize: 8,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                        height: 0.16,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 11,
                      height: 11,
                      child: Image.asset(Assets.assets_images_app_logos_youtube_jpg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ),
        ValueListenableBuilder(
          valueListenable: sportsAppState.rows,
          builder: (context, value, child) {
            return SizedBox(
              height: 150,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: sportsNewsList.length,
                itemBuilder: (context, index) {
                  final mediaRow = sportsNewsList[index];
                  if (mediaRow.mediaItems.isEmpty) {
                    return const SizedBox(
                      width: 280,
                      height: 150,
                      child: Center(child: Text("No media available")),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(left: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: mediaRow.mediaItems.length,
                    itemBuilder: (context, mediaIndex) {
                      final mediaItem = mediaRow.mediaItems[mediaIndex];
                      String imageUrl = mediaItem.imageHD.isNotEmpty
                          ? mediaItem.imageHD
                          : mediaItem.image;
                      return GestureDetector(
                        onTap: () {
                          mediaItem.actions[0].chatAction.executeAction(context, mediaItem: mediaItem);
                        },
                        child: SizedBox(
                          width: 280,
                          height: 158,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            margin: const EdgeInsets.only(right: 20),
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFF1F1F1F),
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
