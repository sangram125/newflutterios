import 'dart:async';

import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/search_suggestions.dart';
import 'package:dor_companion/utils.dart';
import 'package:get/get.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/redesign/home_screen/widget/mood_detail_view.dart';
import 'package:dor_companion/redesign/search/widget/suggestion_view.dart';
import 'package:dor_companion/widgets/appbar_custom.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../widgets/custom_search_widget.dart' as se;
import 'package:dor_companion/mobile/search/search_controller/search_controller.dart';
class SearchTabView extends StatefulWidget {
  var searchSuggestionsCompleter = Completer<SearchSuggestionResult>();
  final _debouncer = Debouncer(milliseconds: 500);

  final SensyApi sensyApi;
  final SearchSuggestions searchSuggestion;
  final SpeechToText _speechToText = SpeechToText();
  final bool _speechInitialized = false;
  final bool _speechEnabled = false;
  final Rx<bool> _isListening = false.obs;
  bool isComingFromProfile;

  SearchTabView({
    required this.sensyApi,
    required this.searchSuggestion,
    this.isComingFromProfile = false,
  }) : super(
  );


  @override
  State<SearchTabView> createState() => _SearchTabViewState();
}

class _SearchTabViewState extends State<SearchTabView>
    with SingleTickerProviderStateMixin {

  List<MediaRow> genreList = [];
TextEditingController controller = TextEditingController();
  final searchController = Get.put(SearchViewController());
  @override
  void initState() {
    super.initState();
     genreList= homeState.genreRows.value;
    // _tabController = TabController(length: genreList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      appBar:LogoAppBar(pageText:'SEARCH', showLogo: true, ),
      body:
      SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                 controller: controller,
                  // //focusNode: focusNode,
                 // style: widget.delegate.searchFieldStyle ?? theme.textTheme.titleLarge,
                  // textInputAction: textInputAction,
                  // onChanged: _onQueryChanged1(context),
                  // keyboardType: widget.delegate.keyboardType,
                  onSubmitted: (String _) {
                   //showResults(context);
                  },

                  decoration: InputDecoration(
                      filled: true, // Enable filling
                      fillColor: Color(0xFF171717), // Set fill color
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF333333), width: 1),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF333333), width: 1),
                      ),

                      prefixIcon: Icon(Icons.search),
                      suffixIcon:Row(
                        mainAxisSize: MainAxisSize.min,
                        children: buildActions(context)!,
                      ),
                      hintText: 'search for comedy'
                  ),
                ),
              ),
            ],
          ),
          _buildSuggestions(searchController.searchHistory, context)
        ]),
      ),
    );
  }
  Widget _buildSuggestions(List<SearchSuggestion> searchSuggestions, BuildContext context) {

    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SuggestionsView(
        query: controller.text,
        searchSuggestions: widget.searchSuggestion,
        searchSuggestionList: searchSuggestions,
        setQuery: (BuildContext context, String query) {
          // this.query = query;
          // showResults(context);
          // searchSuggestion.addToHistory(query);
        }, isComingFromProfile: false,
      ),
    );
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: "Clear",
          onPressed: () {
            // query = '';
            // showSuggestions(context);
          },
        ),
      Container(
        margin: const EdgeInsets.only(left: 5, right: 8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: IconButton(
          icon: const Icon(Icons.keyboard_voice_outlined),
          tooltip: "Voice search",
          onPressed: () {
            //_startListening(context),
          }
        ),
      ),
    ];
  }
  @override
  void dispose() {
    //_tabController?.dispose();
    super.dispose();
  }
}
