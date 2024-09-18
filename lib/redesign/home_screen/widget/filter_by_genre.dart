import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/redesign/home_screen/widget/mood_detail_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FilterByGenreTabView extends StatefulWidget {
  bool isSearchScreen;
   FilterByGenreTabView({super.key, this.isSearchScreen=false});

  @override
  State<FilterByGenreTabView> createState() => _FilterByGenreTabViewState();
}

class _FilterByGenreTabViewState extends State<FilterByGenreTabView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MediaRow> genreList = [];

  @override
  void initState() {
    super.initState();
    genreList= homeState.genreRows.value;
    _tabController = TabController(length: genreList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return  genreList.isEmpty?const Text(""):Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
       Padding(
          padding: EdgeInsets.only(left: 16.0, top: 32),
          child: widget.isSearchScreen ?Text(
            'SEARCH BY GENERES',
            style: TextStyle(
              color: Color(0xFF808080),
              fontSize: 12,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              height: 0.10,
              letterSpacing: 2,
            ),
          ):Text('Watch by Genre',
              style: TextStyle(
                  fontFamily: 'DMSerifDisplay',
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.20,
                  color: Colors.white))),
      const SizedBox(height: 20),
      ValueListenableBuilder(
          valueListenable: homeState.moodRows,
          builder: (context, value, child) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.33,
                  width: double.infinity,
                  child: TabBarView(
                      controller: _tabController,
                      children: genreList.map((category) {
                        return OTTProviderGrid(items: category.mediaItems);
                      }).toList())),]);
          })
    ]);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}

class OTTProviderGrid extends StatelessWidget {
  final List<MediaItem> items;

  const OTTProviderGrid({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 20, mainAxisSpacing: 20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          String genreName = item.title;
          String imagePath = '';
          switch (genreName) {
            case 'Drama':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_drama_png;
              break;
            case 'Comedy':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_comedy_png;
              break;
            case 'Action':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_action_png;
              break;
            case 'Thriller':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_thriller_png;
              break;
            case 'Romance':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_romance_png;
              break;
            case 'Crime':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_crime_png;
              break;
            case 'Mystery':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_mystery_png;
              break;
            case 'Adventure':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_adventure_png;
              break;
            case 'Horror':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_horror_png;
              break;
            case 'Animation':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_frame_2147224692_png;
              break;
            case 'Fantasy':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_fantasy_png;
              break;
            case 'Documentary':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_documentary_png;
              break;
            case 'Musical':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_musical_png;
              break;
            case 'Science':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_science_png;
              break;
            case 'War':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_war_png;
              break;
            case 'Historical':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_historical_png;
              break;
            case 'Western':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_sci_fi_png;
              break;
            case 'Kids':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_kids_png;
              break;
            default:
              imagePath = '';
              break;
          }
          return GestureDetector(
            onTap: () async {
               Future<MediaDetail> data =  getIt<SensyApi>().fetchMediaDetail('facet', item.itemID);
               data.then((value)=>
                   Navigator.push(context,
                       MaterialPageRoute(builder: (context) =>  MoodDetailView(rows:value.mediaRows, moodTitle:item.title))),
               ).catchError((errorObj) {
                 switch (errorObj.runtimeType) {
                   case DioException:
                     final response = (errorObj as DioException).response;
                     print("Failed to  ${response?.statusCode}");
                     break;
                   default:
                     if (kDebugMode) {
                       print("Encountered unknown error of type ${errorObj.runtimeType}");
                     }
                 }
               });
              // items
              //     .elementAt(index)
              //     .actions[0].chatAction
              //     .executeAction(context,
              //     mediaItem: items.elementAt(index));
            },
            child: Stack(children: [
              Positioned.fill(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(imagePath, fit: BoxFit.fill)),
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item.title,style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),),
                  ))
            ]),
          );
        });
  }
}
