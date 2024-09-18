import 'package:dor_companion/mobile/search/search_controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/search_suggestions.dart';
import 'LanguageItemView.dart';

class MovieList extends StatefulWidget {
  final SearchSuggestions searchSuggestions;

  const MovieList({super.key, required this.searchSuggestions});

  @override
  MovieListState createState() => MovieListState();
}

class MovieListState extends State<MovieList> {
  final searchController = Get.put(SearchViewController());

  @override
  void initState() {
    super.initState();
    // Ensure trendingMediaItem is loaded
    searchController.fetchData("tab", "find");
    searchController.fetchData("row", "search-trending");
    setSearchHistory(widget.searchSuggestions);
  }

  @override
  Widget build(BuildContext context) {

    final searchController = Get.put(SearchViewController());
    return Obx(() {
      searchController.visibleMovies.value =
      searchController.showAllMovies.value  ? searchController.movies.take(16).toList() : searchController.movies.take(5).toList();
      for (var element in searchController.trendingMediaItem) {
        searchController.movies.add(LanguageItemView(
          element.title,
          false,
              (context) => element.actions[0].chatAction.executeAction(context, mediaItem: element),
          mediaItem: element,
        ));
      }

      return Column(
        children: [
          Wrap(
            children: [
              for (var movie in searchController.visibleMovies) movie,
              Visibility(
                visible: !searchController.showAllMovies.value &&
                    searchController.trendingMediaItem.isNotEmpty,
                child: LanguageItemView(
                  'See More',
                  true,
                      (context) => searchController.showAllMovies.value = true,
                  mediaItem: null,
                ),
              ),
              Visibility(
                visible: searchController.showAllMovies.value &&
                    searchController.trendingMediaItem.isNotEmpty,
                child: LanguageItemView(
                  'See Less',
                  true,
                      (context) => searchController.showAllMovies.value = false,
                  mediaItem: null,
                ),
              ),
            ],
          ),
        ],
      );
    });

  }
  Future<void> setSearchHistory(SearchSuggestions searchSuggestions) async {
    setState(() {
      searchController.searchHistory.value = searchSuggestions.getSearchHistory();
    });
  }
}