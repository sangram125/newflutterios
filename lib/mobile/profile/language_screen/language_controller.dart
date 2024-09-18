import 'package:dor_companion/data/models/languages.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../screens/personalization_view.dart';
class LanguageController extends GetxController{
  RxBool isSaving = false.obs;
  late RxMap<String, bool> favoritesMap;
  late RxMap<String, bool> internationalFavoritesMap;
  RxInt currentStep = 0.obs; // Keep track of the current step
  RxList<bool> completionStatus = [false, false, false].obs;
  RxBool isLocalLanguageSaved = false.obs;
  RxInt selectedIndex = 0.obs;
  bool isSkipPressed = false;
  @override
  void onInit() {
    super.onInit();
    favoritesMap = RxMap<String, bool>.from({
      for (var name in FavoriteLanguagesChangeNotifier.languageNames)
        name: getIt<FavoriteLanguagesChangeNotifier>()
            .favoriteLanguages
            .contains(name),
    });
    internationalFavoritesMap = RxMap<String, bool>.from({
      for (var name in FavoriteLanguagesChangeNotifier.internationalLanguageNames)
        name: getIt<FavoriteLanguagesChangeNotifier>()
            .favoriteLanguages
            .contains(name),
    });
  }
  save(BuildContext context) {
    LanguageController controller=Get.put(LanguageController());

    if (controller.isSaving.value) return;
    final languages = controller.favoritesMap?.keys
        .where((element) => controller.favoritesMap[element] ?? false)
        .toList();
    final languages2 = controller.internationalFavoritesMap?.keys
        .where((element) => controller.internationalFavoritesMap[element] ?? false)
        .toList();
    List<String> langList = [];
    for (int i = 0; i < languages!.length; i++) {
      langList.add(languages[i]);
    }
    for (int j = 0; j < languages2!.length; j++) {
      langList.add(languages2[j]);
    }
    if (langList.isEmpty) {
      showVanillaToast("At least one language is required");
      return;
    }

      controller.isSaving.value = true;

    getIt<FavoriteLanguagesChangeNotifier>()
        .postFavoriteLanguages(langList)
        .then((saved) => finishLanguageSelection(saved,context));
  }
  finishLanguageSelection(bool saved, BuildContext context) {
    isSaving.value = false;
    if (!saved) return;


    if(saved){
      if(!isSkipPressed) {
        selectedIndex = selectedIndex + 1;
        currentStep = currentStep + 1;
        completionStatus[currentStep.value - 1] = true;
        if(currentStep.value == 2){
          completionStatus[currentStep.value - 1] = true;
          completionStatus[currentStep.value - 2] = true;
        }
      }
    }
  }
    willDoLatter(BuildContext context) async {
    favoritesMap["English"] = true;
    isSkipPressed = true;
    save(context);
  }
}