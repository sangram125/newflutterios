import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/languages.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/screens/personalization_view.dart';
import 'package:dor_companion/responsive.dart';
import 'package:dor_companion/utils.dart';
import 'package:dor_companion/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/loader.dart';

class LanguageSelectionView extends StatefulWidget {
  const LanguageSelectionView({super.key});

  @override
  State<LanguageSelectionView> createState() => _LanguageSelectionViewState();
}

class _LanguageSelectionViewState extends State<LanguageSelectionView> {
  Map<String, bool> favoritesMap = {
    for (var name in FavoriteLanguagesChangeNotifier.languageNames)
      name: getIt<FavoriteLanguagesChangeNotifier>()
          .favoriteLanguages
          .contains(name)
  };

  Map<String, bool> internationalFavoritesMap = {
    for (var name in FavoriteLanguagesChangeNotifier.internationalLanguageNames)
      name: getIt<FavoriteLanguagesChangeNotifier>()
          .favoriteLanguages
          .contains(name)
  };
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = ResponsiveWidget.isSmallScreen(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: isSaving
            ? const Center(child: Loader())
            : isSmallScreen
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 50, bottom: 20),
                    child: Column(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              "Set up your \n language \n preference",
                              style: AppTypography.languageViewLangPreference,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: ListView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildLanguages(favoritesMap, "National"),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  _buildLanguages(internationalFavoritesMap,
                                      "International"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 90,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _save();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .all<Color>(const Color(
                                            0xFF3158CE)), // Set desired color
                                  ),
                                  child: const Text(
                                    'Proceed',
                                    style: AppTypography.profileMainViewsTitle,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _willDoLatter();
                                  // getIt<FavoriteLanguagesChangeNotifier>().setIsDoLater(true);
                                  // getIt<AppRouter>().push("/personalization");
                                },
                                child: const Text(
                                  "I’ll do it later",
                                  style: AppTypography.settingViewDoItLater,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final languageId =
                          FavoriteLanguagesChangeNotifier.languageIds[index];
                      final languageName =
                          FavoriteLanguagesChangeNotifier.languageNames[index];
                      final languageSymbol = FavoriteLanguagesChangeNotifier
                          .languageSymbols[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            favoritesMap[languageName] =
                                !(favoritesMap[languageName] ?? true);
                          });
                        },
                        child: LanguageItemView(
                          languageId,
                          languageName,
                          languageSymbol,
                          favoritesMap[languageName] ?? false,
                        ),
                      );
                    },
                    itemCount:
                        FavoriteLanguagesChangeNotifier.languageIds.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isSmallScreen ? 3 : 7,
                      crossAxisSpacing: isSmallScreen ? 10 : 40,
                      mainAxisSpacing: isSmallScreen ? 10 : 40,
                    ),
                  ),
      ),
    );
  }

  _buildLanguages(Map<String, bool> map, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style:  AppTypography.settingsViewTitle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
          spacing: 15.0,
          runSpacing: 15.0,
          children: map.entries
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    setState(() {
                      map[e.key] = !(map[e.key] ?? true);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 5.0,
                      right: 15.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: !(map[e.key] ?? true)
                          ? const Color(0xFF040523)
                          : const Color(0xFF3158CE),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (!(map[e.key] ?? true))
                            ? Container()
                            : SvgPicture.asset(
                                "assets/icons/cancel.svg",
                                width: 16,
                                height: 16,
                                color: Colors.white,
                              ),
                        if (!(map[e.key] ?? false)) const SizedBox(width: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            e.key,
                            style: AppTypography.keyTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  _save() {
    if (isSaving) return;

    final languages = favoritesMap.keys
        .where((element) => favoritesMap[element] ?? false)
        .toList();

    final languages2 = internationalFavoritesMap.keys
        .where((element) => internationalFavoritesMap[element] ?? false)
        .toList();

    List<String> langList = [];

    for (int i = 0; i < languages.length; i++) {
      langList.add(languages[i]);
    }

    for (int j = 0; j < languages2.length; j++) {
      langList.add(languages2[j]);
    }

    if (langList.isEmpty) {
      showVanillaToast("At least one language is required");
      return;
    }

    setState(() => isSaving = true);

    getIt<FavoriteLanguagesChangeNotifier>()
        .postFavoriteLanguages(langList)
        .then((saved) => _finishLanguageSelection(saved));
  }

  _finishLanguageSelection(bool saved) {
    setState(() {
      isSaving = false;
    });

    if (!saved) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  const PersonalizationView(),
      ),
    );
  }

  void _willDoLatter() {
    favoritesMap["English"] = true;
    _save();
  }
}

class LanguageItemView extends StatelessWidget {
  final int languageId;
  final String languageName;
  final String languageSymbol;
  final bool isFavorite;

  const LanguageItemView(
      this.languageId, this.languageName, this.languageSymbol, this.isFavorite,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 106,
      height: 106,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                languageSymbol,
                style:AppTypography.settingViewLangSymbol,
              ),
            ),
            Positioned.fill(
              bottom: 16,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  languageName,
                  style:AppTypography.settingViewLangName,
                ),
              ),
            ),
            Positioned.fill(
              top: 8,
              right: 8,
              child: Align(
                alignment: Alignment.topRight,
                child: isFavorite
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 28,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: 28,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
