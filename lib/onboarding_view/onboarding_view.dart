import 'package:carousel_slider/carousel_slider.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/onboarding_view/%20controller/onboarding_controller.dart';
import 'package:dor_companion/onboarding_view/DoIndicator.dart';
import 'package:dor_companion/onboarding_view/onboard_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../injection/injection.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {

  final onBoardingController = Get.put(OnboardingController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            final double height = MediaQuery.of(context).size.height * 0.8;
            return Obx(()=>
              Column(
                children: [
                  CarouselSlider(
                    carouselController: onBoardingController.carouselController,
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        //setState(() {
                          onBoardingController.pageIndex.value = index;
                       // });
                      },
                      height: height,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: false,
                    ),
                    items: onBoardingController.onboardingModel
                        .map(
                          (item) => AnimatedContainer(
                        duration: const Duration(microseconds: 5),
                        child: OnBoardContent(
                          onboardingModel: item,
                          onTap: () {
                            getIt<UserAccount>()
                                .setIsCompletedOnboarding(true);
                          },
                        ),
                      ),
                    )
                        .toList(),
                  ),
                  _buildSliderAction()
                ],
              ),
            );
          },
        ),
      ),
    );
  }


  Expanded _buildSliderAction() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...List.generate(
              onBoardingController.onboardingModel.length,
                  (index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: DoIndicator(
                  isActive: index == onBoardingController.pageIndex.value,
                ),
              ),
            ),
            const Spacer(),

              GestureDetector(
                onTap: onBoardingController.arrowIndicatorTapped,
                child: Image.asset(
                  'assets/images/onboarding_images/${onBoardingController.buttonImagesPath[onBoardingController.pageIndex.value]}',
                  fit: BoxFit.cover,
                ),

            )
          ],
        ),
      ),
    );
  }


}

