import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:flutter/material.dart';

class DorTopDramaRecommendationView extends StatelessWidget {
  const DorTopDramaRecommendationView({super.key});

  @override
  Widget build(BuildContext context) {
    List<MediaRow> topRecommendationList = appState.loadingPageRows.value
        .where((title) => title.title == "Dor's Top Drama Recommendations")
        .toList();
    return topRecommendationList.isEmpty
        ? const SizedBox()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Dor's Top Drama Recommendations",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 0.20,
                        fontSize: 14,
                        color: Color(0xFF999999),
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.w400))),
            const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Top dramas",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 0.20,
                        fontSize: 28,
                        color: Colors.white,
                        fontFamily: 'DMSerifDisplay',
                        fontWeight: FontWeight.w400))),
            const SizedBox(height: 20),
            ValueListenableBuilder(
                valueListenable: appState.loadingPageRows,
                builder: (context, value, child) {
                  List<MediaRow> topRecommendationList = appState.loadingPageRows.value
                      .where((title) => title.title == "Dor's Top Drama Recommendations")
                      .toList();
                  return SizedBox(
                      height: 208,
                      width: double.infinity,
                      child: GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1.45, crossAxisCount: 1, mainAxisSpacing: 12),
                          itemCount: topRecommendationList.first.mediaItems.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => topRecommendationList.first.mediaItems[index].actions[0].chatAction
                                  .executeAction(context,
                                      mediaItem: topRecommendationList.first.mediaItems[index]),
                              child: SizedBox(
                                  width: 132,
                                  height: 208,
                                  child: Stack(children: [
                                    Container(
                                        width: 132,
                                        height: 198,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    topRecommendationList.first.mediaItems[index].image),
                                                fit: BoxFit.cover),
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(width: 1, color: Color(0xFF1F1F1F)),
                                                borderRadius: BorderRadius.circular(24)))),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            width: 16,
                                            height: 16,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(topRecommendationList
                                                        .first.mediaItems[index].imageHD),
                                                    fit: BoxFit.fill),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4)))))
                                  ])),
                            );
                          }));
                })
          ]);
  }
}
