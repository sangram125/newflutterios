import 'package:cached_network_image/cached_network_image.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/redesign/sports/sports_category.dart';
import 'package:flutter/material.dart';

import '../../data/api/sensy_api.dart';

class SportsGrid extends StatefulWidget {
  const SportsGrid({super.key});

  @override
  State<SportsGrid> createState() => _SportsGridState();
}

class _SportsGridState extends State<SportsGrid> {
  List<MediaItem> sportsCategoryList = [];

  @override
  void initState() {
    super.initState();

    sportsCategoryList = sportsAppState.rows.value
        .firstWhere((row) => row.title == "Explore your favourite Sport")
        .mediaItems;
  }

  @override
  Widget build(BuildContext context) {
    return sportsCategoryList.isEmpty
        ? const SizedBox()
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16),
          child: Text(
            'Watch sports by category',
            style: TextStyle(
                fontFamily: 'DMSerifDisplay',
                fontSize: 26,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.20,
                color: Colors.white),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: sportsAppState.rows,
          builder: (context, value, child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.39,
              width: double.infinity,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of rows
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 20,
                ),
                itemCount: sportsCategoryList.length,
                itemBuilder: (context, index) {
                  final item = sportsCategoryList[index];
                  String imageUrl = item.imageHD.isNotEmpty
                      ? item.imageHD
                      : item.image;
                  return GestureDetector(
                    onTap: () async {
                          List<MediaRow> sportsrow = [];
                          await  getIt<SensyApi>().fetchMediaDetail("sport_genre", sportsCategoryList[index].itemID).then((mediaDetail) {
                            sportsrow = [];
                            sportsrow = mediaDetail.mediaRows;
                            setState(() {});
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  SportsCategory(
                                rows: sportsrow, moodTitle: item.title,
                                  sportsCategoryList: sportsCategoryList)));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SizedBox(
                              width: 150,
                              height: 100,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        // Display title below the image
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: Color(0xFFB2B2B2),
                            fontSize: 10,
                            fontFamily: "DM Sans",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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

