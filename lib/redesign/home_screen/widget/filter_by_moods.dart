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
import 'package:flutter_svg/flutter_svg.dart';

class FilterByMoodTabView extends StatefulWidget {
  bool isSearchScreen;
  final int crossAxisCount ;
  final double childAspectRatio;
  final double height;
   FilterByMoodTabView({super.key, this.isSearchScreen=false,required this.crossAxisCount, required this.childAspectRatio, required this.height});

  @override
  State<FilterByMoodTabView> createState() => _FilterByMoodTabViewState();
}

class _FilterByMoodTabViewState extends State<FilterByMoodTabView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MediaRow> filterByChannelList = [];
  List<String> moodList = ['happy',
    'romantic',
    'curious',
    'energetic',
    'annoyed',
    'excited',
    'scared',
    'inspired',
    'bored',
    'relaxed',
    'nostalgic',
    'stressed',
    'philosophical',
    'serious'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: moodList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return  Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
       Padding(
          padding: EdgeInsets.only(left: 16.0, top: 32),
          child: widget.isSearchScreen ? Text(
            'SEARCH BY HOW YOU FEEL',
            style: TextStyle(
              color: Color(0xFF808080),
              fontSize: 12,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              height: 0.10,
              letterSpacing: 2,
            ),
          ):Text('Watch by Mood',
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
                  height: MediaQuery.of(context).size.height * widget.height,
                  width: double.infinity,
                  child: OTTProviderGrid(items: moodList,crossAxisCount:widget.crossAxisCount,childAspectRatio :widget.childAspectRatio))]);
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
  final List<String> items;
  final int crossAxisCount ;
  final double childAspectRatio;

   OTTProviderGrid({Key? key, required this.items, required this.crossAxisCount, required this.childAspectRatio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, childAspectRatio:childAspectRatio, crossAxisSpacing: 20, mainAxisSpacing: 20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          String genreName = item;
          String imagePath = '';
          switch (genreName) {
            case 'happy':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_happy_svg;
              break;
            case 'romantic':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_romantic_svg;
              break;
            case 'curious':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_curious_svg;
              break;
            case 'energetic':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_energetic_svg;
              break;
              //wrong imahe
            case 'annoyed':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_annoyed_svg;
              break;
            case 'excited':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_excited_svg;
              break;
            case 'scared':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_scared_svg;
              break;
            case 'inspired':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_inspired_svg;
              break;
              //wrong imahge
            case 'bored':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_bored_svg;
              break;
            case 'relaxed':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_relaxed_svg;
              break;
            case 'nostalgic':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_nostalgia_svg;
              break;
            case 'stressed':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_stressed_svg;
              break;
            case 'philosophical':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_philosophical_svg;
              break;
            case 'serious':
              imagePath = Assets.assets_images_genre_card_and_mood_card_images_serious_svg;
              break;
            default:
              imagePath = '';
              break;
          }
          return GestureDetector(
            onTap: () async {
             await  getIt<SensyApi>().fetchMoodDetail(item).then((moods) {
                homeState.moodRows.value = moods.mediaRows;
              }).catchError((errorObj) {
                switch (errorObj.runtimeType) {
                  case DioException:
                    final response = (errorObj as DioException).response;
                    print("Failed to fetch mood: ${response?.statusCode}");
                    break;
                  default:
                    if (kDebugMode) {
                      print("Encountered unknown error of type ${errorObj.runtimeType}");
                    }
                }
              });

            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  MoodDetailView(rows: homeState.moodRows.value, moodTitle:item)));},
            child: Stack(children: [
              Positioned.fill(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SvgPicture.asset(imagePath, fit: BoxFit.fill)),
              ),
              // Align(
              //     alignment: Alignment.bottomLeft,
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text(item),
              //     ))
            ]),
          );
        });
  }
}
