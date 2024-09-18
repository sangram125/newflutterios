import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/app_state.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:flutter/material.dart';

class TvGuideVm extends ChangeNotifier {
  List<Language> languageList = [];
  List<Genre> genreList = [];
  String? selectedType;
  String? selectedLanguage;
  Channel? selectedChannel;
  List<Channel> leftPanelList = [];
  List<MediaRow> rightPanelData = [];
  bool isError = false;
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getLanguage() async {
    setLoading(true);
    try {
      await getIt<SensyApi>().fetchLanguages().then((languages) {
        languageList = languages.list;
        languageList.insert(0, Language(title: 'All', isSelected: true));
        notifyListeners();
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> setData({String? genre, String? language, String? channelId}) async {
    if (genre != null) {
      selectedType = genre;
    }
    await getLanguage();
    await setLanguage(language);
    if (channelId != null) {
      selectedType =
          appState.filteredChannels.value.firstWhere((channel) => channel.id.toString() == channelId).genre;
    }

    setGenreList();
    await filterChannels(channelId: channelId);
    notifyListeners();
  }

  Future<void> setLanguage(String? language) async {
    if (language != null) {
      selectedLanguage = language;
      for (var languageItem in languageList) {
        languageItem.isSelected = languageItem.title == language;
      }
    } else {
      var selectedItem = languageList.firstWhere((element) => element.isSelected);
      selectedItem.isSelected = true;
      selectedLanguage = selectedItem.title;
    }
    notifyListeners();
  }

  void setGenreList() {
    genreList = appState.genreWithImages.value.list.where((genre) => genre.title != 'All').map((element) {
      element.isSelected = element.title == selectedType;
      return element;
    }).toList();
    notifyListeners();
  }

  Future<void> updateLanguages(String selectedLanguageTitle) async {
    for (var language in languageList) {
      language.isSelected = language.title == selectedLanguageTitle;
    }
    selectedLanguage = selectedLanguageTitle;
    await filterChannels();
    notifyListeners();
  }

  Future<void> changeLiveTvType(String title) async {
    selectedType = title;
    for (var genre in genreList) {
      genre.isSelected = genre.title == title;
    }
    await filterChannels();
    notifyListeners();
  }

  Future<void> filterChannels({String? channelId}) async {
    List<String> selectedGenres =
        genreList.where((genre) => genre.isSelected).map((genre) => genre.title).toList();
    List<String> selectedLanguages =
        languageList.where((language) => language.isSelected).map((language) => language.title).toList();

    bool isAllGenreSelected = selectedGenres.first == 'All';
    bool isAllLanguageSelected = selectedLanguages.first == 'All';

    leftPanelList = appState.filteredChannels.value
        .where((channel) =>
            (isAllGenreSelected || selectedGenres.contains(channel.genre)) &&
            (isAllLanguageSelected || selectedLanguages.contains(channel.language)))
        .toList();

    if (channelId != null) {
      Channel? removedChannel =
          leftPanelList.firstWhere((channel) => channel.id.toString() == channelId.toString());

      leftPanelList.remove(removedChannel);
      leftPanelList.insert(0, removedChannel);
    }

    if (leftPanelList.isNotEmpty) {
      selectChannel(leftPanelList.first);
    }

    notifyListeners();
  }

  void updateGenres() {
    Set<String> uniqueGenres = Set<String>.from(leftPanelList.map((channel) => channel.genre));
    genreList = uniqueGenres.map((genre) => Genre(title: genre)).toList();
    genreList.insert(0, Genre(title: "All", isSelected: true));
  }

  void selectChannel(Channel channel) {
    selectedChannel = channel;
    updateRightPanelData(channel);
    notifyListeners();
  }

  void updateRightPanelData(Channel channel) {
    rightPanelData = appState.rows.value.where((row) => row.title == channel.name).toList();

    if (rightPanelData.isEmpty) {
      isError = true;
    } else {
      isError = false;
      for (var row in rightPanelData) {
        for (var mediaItem in row.mediaItems) {
          mediaItem.video = channel.feedHLS;
          mediaItem.isLiveTVItem = true;
          mediaItem.source = channel.source;
        }
      }
    }
  }

  void clearData() {
    selectedChannel = null;
    selectedType = null;
    selectedLanguage = null;
    selectedChannel = null;
    leftPanelList.clear();
    rightPanelData.clear();
    languageList.clear();
    // genreList.clear();
    notifyListeners();
  }
}
