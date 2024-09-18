import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/redesign/live_tv/tv_guide_screen.dart';
import 'package:flutter/material.dart';

class TypesOfLiveChannelGridScreen extends StatefulWidget {
  const TypesOfLiveChannelGridScreen({super.key});

  @override
  State<TypesOfLiveChannelGridScreen> createState() => _TypesOfLiveChannelGridScreenState();
}

class _TypesOfLiveChannelGridScreenState extends State<TypesOfLiveChannelGridScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.42,
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('Watch TV by type',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 0.20,
                      fontSize: 14,
                      color: Color(0xFF999999),
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.w400))),
          const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('Types of Live channels',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 0.20,
                      fontSize: 28,
                      color: Colors.white,
                      fontFamily: 'DMSerifDisplay',
                      fontWeight: FontWeight.w400))),
          const SizedBox(height: 20),
          Expanded(
              child: ValueListenableBuilder(
                  valueListenable: appState.genres,
                  builder: (context, value, child) {
                    List<Genre> genreList =
                        appState.genres.value.list.where((genre) => genre.title != 'All').map((genre) {
                      String genreName = genre.title;
                      String imagePath;
                      switch (genreName) {
                        case 'Entertainment':
                          imagePath = Assets.assets_images_live_tv_entertainment_image_png;
                          break;
                        case 'News':
                          imagePath = Assets.assets_images_live_tv_news_image_png;
                          break;
                        case 'Business News':
                          imagePath = Assets.assets_images_live_tv_business_news_image_png;
                          break;
                        case 'Food & Lifestyle':
                          imagePath = Assets.assets_images_live_tv_food_lifestyle_image_png;
                          break;
                        case 'Music':
                          imagePath = Assets.assets_images_live_tv_music_image_png;
                          break;
                        case 'Sports':
                          imagePath = Assets.assets_images_live_tv_sports_image_png;
                          break;
                        case 'Comedy':
                          imagePath = Assets.assets_images_live_tv_comedy_image_png;
                          break;
                        case 'Movies':
                          imagePath = Assets.assets_images_live_tv_movies_image_png;
                          break;
                        case 'Fun & Games':
                          imagePath = Assets.assets_images_live_tv_fun_games_image_png;
                          break;
                        case 'Kids':
                          imagePath = Assets.assets_images_live_tv_kids_image_png;
                          break;
                        case 'Travel':
                          imagePath = Assets.assets_images_live_tv_travel_image_png;
                          break;
                        case 'Infotainment':
                          imagePath = Assets.assets_images_live_tv_infotainment_image_png;
                          break;
                        case 'Devotional':
                          imagePath = Assets.assets_images_live_tv_devotional_image_png;
                          break;
                        case 'Finance':
                          imagePath = Assets.assets_images_live_tv_finance_image_png;
                          break;
                        default:
                          imagePath = '';
                          break;
                      }
                      return Genre(title: genreName, image: imagePath);
                    }).toList();
                    return GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.07, crossAxisCount: 2),
                        itemCount: genreList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TvGuideScreen(genre: genreList[index].title)));
                              },
                              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                Container(
                                    width: 100,
                                    height: 100,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(genreList[index].image!), fit: BoxFit.fill),
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(width: 1, color: Color(0xFF1F1F1F)),
                                            borderRadius: BorderRadius.circular(20)))),
                                const SizedBox(height: 6),
                                Text(genreList[index].title.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Color(0xFFB2B2B2),
                                        fontSize: 8,
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 2))
                              ]));
                        });
                  }))
        ]));
  }
}
