import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';

class GenreListHelper {
  static void updateGenreListWithImages() {
    List<Genre> processedList = appState.genres.value.list
        .where((genre) => genre.title != 'All')
        .map((genre) => Genre(
            title: genre.title, image: _getImagePathForGenre(genre.title), isSelected: genre.isSelected))
        .toList();

    appState.genreWithImages.value = GenreList(list: processedList);
    appState.genreWithImages.notifyListeners();
  }

  static String _getImagePathForGenre(String genreName) {
    switch (genreName) {
      case 'Entertainment':
        return Assets.assets_images_live_tv_entertainment_image_png;
      case 'News':
        return Assets.assets_images_live_tv_news_image_png;
      case 'Business News':
        return Assets.assets_images_live_tv_business_news_image_png;
      case 'Food & Lifestyle':
        return Assets.assets_images_live_tv_food_lifestyle_image_png;
      case 'Music':
        return Assets.assets_images_live_tv_music_image_png;
      case 'Sports':
        return Assets.assets_images_live_tv_sports_image_png;
      case 'Comedy':
        return Assets.assets_images_live_tv_comedy_image_png;
      case 'Movies':
        return Assets.assets_images_live_tv_movies_image_png;
      case 'Fun & Games':
        return Assets.assets_images_live_tv_fun_games_image_png;
      case 'Kids':
        return Assets.assets_images_live_tv_kids_image_png;
      case 'Travel':
        return Assets.assets_images_live_tv_travel_image_png;
      case 'Infotainment':
        return Assets.assets_images_live_tv_infotainment_image_png;
      case 'Devotional':
        return Assets.assets_images_live_tv_devotional_image_png;
      case 'Finance':
        return Assets.assets_images_live_tv_finance_image_png;
      default:
        return '';
    }
  }
}
