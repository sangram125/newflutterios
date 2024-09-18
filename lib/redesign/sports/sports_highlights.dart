import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:flutter/material.dart';

class SportHighlights extends StatefulWidget {
  const SportHighlights({super.key});

  @override
  State<SportHighlights> createState() => _SportHighlightsState();
}

class _SportHighlightsState extends State<SportHighlights> {
  List<MediaRow> sportsHighlights = [];

  @override
  void initState() {
    super.initState();
    sportsHighlights = sportsAppState.rows.value
        .where((row) => row.title == 'Highlights')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.only(left: 20,bottom: 16,top: 16),
            child: Text("Highlights",
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 0.20,
                    fontSize: 26,
                    color: Colors.white,
                    fontFamily: 'DMSerifDisplay',
                    fontWeight: FontWeight.w400))),
        ValueListenableBuilder(
          valueListenable: sportsAppState.rows,
          builder: (context, value, child) {
            return SizedBox(
              height: 150,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 10),
                scrollDirection: Axis.horizontal,
                itemCount: sportsHighlights.length,
                itemBuilder: (context, index) {
                  final mediaRow = sportsHighlights[index];
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
                        onTap: () => sportsHighlights.first.mediaItems[index].actions[0].chatAction
                            .executeAction(context,
                            mediaItem: sportsHighlights.first.mediaItems[index]),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              width: 250,
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
                            Positioned(
                              bottom: -5,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(mediaItem.actions[0].icon),
                                        fit: BoxFit.fill),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4))),
                                ),
                              ),
                            ),
                          ],
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
