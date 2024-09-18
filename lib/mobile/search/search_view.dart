import 'dart:async';
import 'package:dor_companion/mobile/search/SearchSugeestionsView.dart';
import 'package:dor_companion/mobile/search/search_controller/search_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../widgets/custom_search_widget.dart' as se;
import '../../data/api/sensy_api.dart';
import '../../data/models/models.dart';
import '../../data/models/search_suggestions.dart';
import '../screens/fullscreen_toast.dart';
import '../widgets/add_watch_list_view.dart';
import '../../utils.dart';
import '../../widgets/loader.dart';
import '../../widgets/media_detail/media_rows_view.dart';


class CustomSearchDelegate extends se.SearchDelegate {
  var searchSuggestionsCompleter = Completer<SearchSuggestionResult>();
  final _debouncer = Debouncer(milliseconds: 500);

  final SensyApi sensyApi;
  final SearchSuggestions searchSuggestion;
  final SpeechToText _speechToText = SpeechToText();
  final bool _speechInitialized = false;
  final bool _speechEnabled = false;
  final Rx<bool> _isListening = false.obs;
  bool isComingFromProfile;

  CustomSearchDelegate({
    required this.sensyApi,
    required this.searchSuggestion,
    this.isComingFromProfile = false,
  }) : super(
    searchFieldLabel: "What do you want to watch today?",
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.only(
          left: 16,
          bottom: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
            fontSize: 15,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: "Clear",
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
      Container(
        margin: const EdgeInsets.only(left: 5, right: 8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF3158CE),
        ),
        child: IconButton(
          icon: const Icon(Icons.keyboard_voice_outlined),
          tooltip: "Voice search",
          onPressed: () => _startListening(context),
        ),
      ),
    ];
  }

  _showPermissionDialog(BuildContext context) {
    final searchController = Get.put(SearchViewController());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF040C3F),
          title: const Text("Permissions required"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: const Text("We need some permissions from you to "
              "enable Voice Search."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Reject",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await searchController.initSpeech(_speechEnabled,_speechToText, _speechInitialized);
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchController = Get.put(SearchViewController());
    if (query.isEmpty) {
      return _buildSuggestions(searchController.searchHistory);

    }
    searchSuggestion.addToHistory(query);
    return isComingFromProfile
        ? AddWatchListView(
      mediaDetailFuture: () => sensyApi.fetchSearchResult(query),
      key: const Key("watchlist"),
    )
        : MediaRowsView(
      isTopicScreen: true,
      mediaDetailFuture: () => sensyApi.fetchSearchResult(query),
      key: const Key("search"),
    );
  }

  Widget _buildSuggestions(List<SearchSuggestion> searchSuggestions) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SearchSuggestionsView(
        query: query,
        searchSuggestions: searchSuggestion,
        searchSuggestionList: searchSuggestions,
        setQuery: (BuildContext context, String query) {
          this.query = query;
          showResults(context);
          searchSuggestion.addToHistory(query);
        },
        isComingFromProfile: isComingFromProfile,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchSuggestionsCompleter = Completer<SearchSuggestionResult>();
    _debouncer.run(() {
      if (query.isNotEmpty) {
        searchSuggestionsCompleter
            .complete(sensyApi.fetchSearchSuggestions(query));
      }
    });

    if (query.isEmpty) {
      return _buildSuggestions([]);
    }

    return FutureBuilder<SearchSuggestionResult>(
      future: searchSuggestionsCompleter.future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: Loader());
          case ConnectionState.done:
          default:
            if (snapshot.hasData) {
              return _buildSuggestions(snapshot.data!.results);
            } else {
              return Container();
            }
        }
      },
    );
  }


  _startListening(BuildContext context) {
    _startListeningAsync(
          () {
        _showPermissionDialog(context);
      },
          () {
        showResults(context);
      },
      context,
    );
    showFullScreenBottomSheet(context);
  }

  _startListeningAsync(Function promptPermissions, Function showResults,
      BuildContext context) async {
    final searchController = Get.put(SearchViewController());
    if (!await _speechToText.hasPermission) {
      promptPermissions();
      return;
    }

    if (!_speechInitialized) {
      await searchController.initSpeech(_speechEnabled,_speechToText, _speechInitialized);
    }

    _isListening.value = true;
    query = " ";
    query = "";
    if (kDebugMode) {
      print("STT: Started listening");
    }
    _speechToText.listen(
      onResult: (result) {
        _onSpeechResult(result, showResults,context);
      },
      pauseFor: const Duration(seconds: 5),
      listenMode: ListenMode.search,
    );
  }

  _onSpeechResult(SpeechRecognitionResult result, Function showResults,BuildContext context) {
    if (kDebugMode) {
      print("STT: Received result $result");
    }

    if (result.finalResult) {
      _isListening.value = false;
      showResults();
      if(_isListening.value==false){
        Navigator.of(context).pop();
      }
    }

    final resultString = result.recognizedWords;
    if (resultString.isNotEmpty) {
      query = resultString;
    }

    final message = _speechToText.isListening
        ? query
        : _speechEnabled
        ? "Waiting to start"
        : "Speech not available";
    if (kDebugMode) {
      print("STT: $message");
    }
  }
}



