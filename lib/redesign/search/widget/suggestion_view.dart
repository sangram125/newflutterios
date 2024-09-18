import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/data/models/search_suggestions.dart';
import 'package:dor_companion/mobile/search/search_controller/search_controller.dart';
import 'package:dor_companion/redesign/home_screen/widget/filter_by_genre.dart';
import 'package:dor_companion/redesign/home_screen/widget/filter_by_moods.dart';
import 'package:dor_companion/redesign/home_screen/widget/mood_detail_view.dart';
import 'package:dor_companion/redesign/home_screen/widget/special_collection_list_view.dart';
import 'package:dor_companion/redesign/home_screen/widget/special_collection_view.dart';
import 'package:dor_companion/redesign/search/widget/suggestion_row_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class SuggestionsView extends StatefulWidget {
  const SuggestionsView({
    Key? key,
    required this.query,
    required this.searchSuggestions,
    required this.searchSuggestionList,
    required this.setQuery,
    required this.isComingFromProfile,
  }) : super(key: key);

  final String query;
  final SearchSuggestions searchSuggestions;
  final List<SearchSuggestion> searchSuggestionList;
  final Function setQuery;
  final bool isComingFromProfile;

  @override
  State<SuggestionsView> createState() => _SuggestionsViewState();
}

class _SuggestionsViewState extends State<SuggestionsView> {
  final searchController = Get.put(SearchViewController());

  @override
  void initState() {
    super.initState();

    searchController.fetchData("tab", "find");
    searchController.fetchData("row", "search-trending");
    setSearchHistory(widget.searchSuggestions);
  }

  @override
  Widget build(BuildContext context) {
    List<SearchSuggestion> searchSuggestions =
    widget.query.isEmpty
        ? searchController.searchHistory
        : widget.searchSuggestionList;
    if (widget.query.isEmpty) {
      return widget.isComingFromProfile
          ? Container()
          : _searchTheme();
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          SearchSuggestion suggestion = searchSuggestions[index];
          bool isFromHistory = widget.query.isEmpty;
          return Container(
            margin: const EdgeInsets.only(top: 5),
            child: ListTile(
              onTap: () => widget.setQuery(context, suggestion.title),
              title: Text(suggestion.title),
              trailing: isFromHistory
                  ? IconButton(
                icon: const Icon(Icons.close),
                color: Theme.of(context).iconTheme.color,
                onPressed: () async {
                  await widget.searchSuggestions
                      .removeFromHistory(suggestion.title);
                  setSearchHistory(widget.searchSuggestions);
                },
              )
                  : null,
            ),
          );
        },
        itemCount: searchSuggestions.length,
      );
    }
  }

  SingleChildScrollView _searchTheme() {
    final searchController = Get.put(SearchViewController());
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //_title(title: "What's trending"),
            const SizedBox(
              height: 8.0,
            ),
            SuggestionRowView(searchSuggestions:widget.searchSuggestions),
            // Container(
            //   margin: const EdgeInsets.only(top: 20),
            //   child: _title(title: "Browse by Genre"),
            // ),
            const SizedBox(height: 16.0),
            SpecialCollectionView(isSearchScreen: true,),
            FilterByMoodTabView(isSearchScreen: true,crossAxisCount:2,childAspectRatio :0.7, height: 0.33,),
            FilterByGenreTabView(isSearchScreen: true,)
            // GridView.builder(
            //   primary: false,
            //   shrinkWrap: true,
            //   itemBuilder: (BuildContext context, int index) {
            //     final movieName = searchController.mediaItem[index].title;
            //     var moviePicture = searchController.mediaItem[index].image;
            //     String backgroundImage = "assets/images/search_images/banner_${index % 8 + 1}.svg";
            //     return
            //    SizedBox(
            //      height: 800,
            //      child: Column(children: [
            //        // BrowseAllListItem(movieName, moviePicture, backgroundImage,
            //        //   title: searchController.mediaItem[index].title,)
            //        SpecialCollectionListView(rows: []),
            //        FilterByMoodTabView(),
            //        FilterByGenreTabView()
            //      ]),
            //    )
            //  },
              //itemCount: searchController.mediaItem.length,
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 2,
              //   crossAxisSpacing: 5,
              //   mainAxisSpacing: 12,
              //   childAspectRatio: 4 / 3,
              // ),
           // ),
          ],
        ),
      ),
    );
  }
  Future<void> setSearchHistory(SearchSuggestions searchSuggestions) async {
    setState(() {
      searchController.searchHistory.value = searchSuggestions.getSearchHistory();
    });
  }
  Row _title({required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontFamily: "DM Sans", fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
