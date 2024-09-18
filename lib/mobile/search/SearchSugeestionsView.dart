import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/data/models/search_suggestions.dart';
import 'package:dor_companion/mobile/search/search_controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'BrowseAllItems.dart';
import 'MovieList.dart';

class SearchSuggestionsView extends StatefulWidget {
  const SearchSuggestionsView({
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
  State<SearchSuggestionsView> createState() => _SearchSuggestionsViewState();
}

class _SearchSuggestionsViewState extends State<SearchSuggestionsView> {
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
        : Obx(()=> _searchTheme());
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
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _title(title: "What's trending"),
            const SizedBox(
              height: 8.0,
            ),
            MovieList(searchSuggestions:widget.searchSuggestions),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: _title(title: "Browse by Genre"),
            ),
            const SizedBox(height: 16.0),
            GridView.builder(
              primary: false,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final movieName = searchController.mediaItem[index].title;
                var moviePicture = searchController.mediaItem[index].image;
                String backgroundImage = "assets/images/search_images/banner_${index % 8 + 1}.svg";
                return GestureDetector(
                  onTap: () {
                    searchController.mediaItem[index].isLiveTVItem = true;
                    final action = searchController.mediaItem[index].actions[0].chatAction;
                    var action2 = searchController.mediaItem[index];
                    action.executeAction(context, mediaItem: action2);
                  },
                  child: Wrap(children: [
                    BrowseAllListItem(movieName, moviePicture, backgroundImage,
                      title: searchController.mediaItem[index].title,)
                  ]),
                );
              },
              itemCount: searchController.mediaItem.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 12,
                childAspectRatio: 4 / 3,
              ),
            ),
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
