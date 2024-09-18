import 'dart:ui';

import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/constants/color.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/home_screen/widget/special_collection_list_view.dart';
import 'package:flutter/material.dart';

class SpecialCollectionView extends StatelessWidget {
  bool isSearchScreen;
   SpecialCollectionView({super.key, this.isSearchScreen= false});

  @override
  Widget build(BuildContext context) {
    List<MediaRow> topRecommendationList = homeState.rows.value
        .where((title) => title.title.contains('Birthday'))
        .toList();
    return topRecommendationList.isEmpty
        ? const Text("")
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          isSearchScreen? Text(
            'HOT DRIPS',
            style: TextStyle(
              color: Color(0xFF808080),
              fontSize: 12,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              height: 0.10,
              letterSpacing: 2,
            ),
          ):
      const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("Curated just for you",
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 0.20,
                  fontSize: 14,
                  color: Color(0xFF999999),
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.w400))),
      isSearchScreen? Text(""):const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("Special collection",
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 0.20,
                  fontSize: 28,
                  color: Colors.white,
                  fontFamily: 'DMSerifDisplay',
                  fontWeight: FontWeight.w400))),
      const SizedBox(height: 10),
      ValueListenableBuilder(
          valueListenable: homeState.rows,
          builder: (context, value, child) {
            List<MediaRow> topRecommendationList = homeState.rows.value
                .where((title) => title.title.contains('Birthday'))
                .toList();
            return SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 1,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () =>Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>  SpecialCollectionListView(rows: topRecommendationList))),
                          // topRecommendationList.first.mediaItems[index].actions[0].chatAction
                          // .executeAction(context,
                          // mediaItem: topRecommendationList.first.mediaItems[index]),
                      child: SizedBox(
                        width: 345,
                        height: 230,
                        child: Stack(
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                // image: DecorationImage(
                                //   image: NetworkImage(
                                //     topRecommendationList.first.mediaItems[0].imageHD,
                                //   ),
                                //   fit: BoxFit.fill,
                                // ),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: AppColors.whiteColor850),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                  ),
                                  border: Border.all(
                                    color: AppColors.whiteColor850, // Border color
                                    width: 1, // Border width
                                  ),
                                  color: Colors.black.withOpacity(0.5), // Semi-transparent background
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0.5), // Adjust blur level
                                  child: Center(
                                    child: Text(
                                      topRecommendationList.first.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ));
          })
    ]);
  }
}
