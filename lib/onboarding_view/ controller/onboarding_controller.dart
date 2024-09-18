import 'package:carousel_slider/carousel_controller.dart';
import 'package:dor_companion/onboarding_view/model/onboarding_model.dart';
import 'package:get/get.dart';

import '../../../data/models/user_account.dart';
import '../../../injection/injection.dart';

class OnboardingController extends GetxController {

  RxList<OnboardingModel> onboardingModel = [
    OnboardingModel(
      backgroundImagePath:
      "assets/images/onboarding_images/onboarding_background_1.png",
      blurImagePath: "assets/images/onboarding_images/onboarding_blure_1.png",
      largeFontTitle: "Ek Connection, \n Unlimited Entertainment",
      smallFontTitle:
      "say goodbye to multiple subscriptions, and \n hello to affordable streaming",
      isSkipButtonRequred: true,
    ),
    OnboardingModel(
      backgroundImagePath:
      "assets/images/onboarding_images/handsome-modern-guy.png",
      blurImagePath: "assets/images/onboarding_images/blur_gift.png",
      largeFontTitle: "Your home to \n unlimited \n entertainment",
      smallFontTitle:
      "Play games, watch content, and collect \n points to win exciting rewards",
      isSkipButtonRequred: true,
    ),
    OnboardingModel(
      backgroundImagePath: "assets/images/onboarding_images/hand_mobile.png",
      blurImagePath: "assets/images/onboarding_images/three_emoji.png",
      largeFontTitle: "Curated content \n for your taste",
      smallFontTitle:
      "Experience entertainment like never before \n with content curated for your taste",
      isSkipButtonRequred: false,
    )
  ].obs;

  final carouselController = CarouselController();
  RxInt pageIndex = 0.obs;

  List<String> buttonImagesPath = [
    "onboarding_arrow_indiicator_1.png",
    "onboarding_arrow_indiicator_2.png",
    "onboarding_arrow_indiicator_3.png",
  ];

  void arrowIndicatorTapped() {
    if (pageIndex.value != 2) {
      carouselController.nextPage();
    } else {
      getIt<UserAccount>().setIsCompletedOnboarding(true);
    }
  }
}
