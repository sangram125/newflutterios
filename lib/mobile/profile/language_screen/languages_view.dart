import 'package:dio/dio.dart';
import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/languages.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/data/models/user_interests.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/profile/language_screen/language_controller.dart';
import 'package:dor_companion/mobile/profile/language_screen/widgets/icon_tab_widget.dart';
import 'package:dor_companion/mobile/profile/language_screen/widgets/language_item_widget.dart';
import 'package:dor_companion/mobile/profile/language_screen/widgets/personalisation_tab_widget.dart';
import 'package:dor_companion/utils.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageView extends StatefulWidget {
  final bool isComingFromProfile;

  const LanguageView({super.key, this.isComingFromProfile = false});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  bool isSavingTopic = false;

  @override
  void initState() {
    super.initState();
    controller.favoritesMap = RxMap<String, bool>.from({
      for (var name in FavoriteLanguagesChangeNotifier.languageNames)
        name: getIt<FavoriteLanguagesChangeNotifier>().favoriteLanguages.contains(name),
    });
    controller.internationalFavoritesMap = RxMap<String, bool>.from({
      for (var name in FavoriteLanguagesChangeNotifier.internationalLanguageNames)
        name: getIt<FavoriteLanguagesChangeNotifier>().favoriteLanguages.contains(name),
    });
  }

  bool isChecked = false;
  LanguageController controller = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    debugPrint('widget.isComingFromProfile ${widget.isComingFromProfile}');
    AnalyticsEvent eventCall = AnalyticsEvent();

    // Widget buildIcon(int index, String iconPath, Function() onTap) {
    //   return Obx(()=>
    //    GestureDetector(
    //       onTap: () {
    //         onTap();
    //           // controller.selectedIndex.value = index;
    //           // controller.currentStep.value = index; // Update current step
    //       },
    //       child: Container(
    //         decoration:  const BoxDecoration(
    //           color: Colors.transparent,
    //         ),
    //         child: SvgPicture.asset(iconPath, // Top image
    //           fit: BoxFit.fill,
    //           color: controller.selectedIndex.value == index ||  controller.completionStatus[index] ? Colors.white : Colors.grey,
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return Obx(
      () => Scaffold(
        body: SafeArea(
            child: GradientBackground(
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Visibility(
                  visible: (controller.currentStep.value != 0 || widget.isComingFromProfile),
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  child: IconButton(
                    icon: CircleAvatar(
                        backgroundColor: const Color(0xFF1D1E39),
                        child: SvgPicture.asset(Assets.assets_icons_arrow_back_svg,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn))),
                    onPressed: () {
                      if (controller.currentStep.value == 1) {
                        controller.currentStep.value = 0;
                        controller.selectedIndex.value = 0;
                      } else if (controller.currentStep.value == 2) {
                        controller.currentStep.value = 1;
                        controller.selectedIndex.value = 1;
                      } else {
                        context.pop();
                      } // Add navigation logic here
                    },
                  ),
                ),
                Text(
                  "My choice",
                  style: AppTypography.languageViewTitle,
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      //await controller.willDoLatter(context);
                      if (widget.isComingFromProfile == true) {
                        context.pop();
                      }
                      if ((controller.currentStep.value == 2 || controller.currentStep.value == 1) &&
                          widget.isComingFromProfile == false) {
                        _saveTopic();
                      }
                    },
                    child: controller.currentStep.value == 0
                        ? Container()
                        : const Text(
                            "Skip",
                            style: TextStyle(
                              color: Color(0xFFA8C7FA),
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ),
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        TabIconCommon(
                            index: 0,
                            iconPath: "assets/images/onboarding_images/language_tab_icon.svg",
                            onTap: () {
                              controller.selectedIndex.value = 0;
                              controller.currentStep.value = 0;
                            }),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Opacity(
                            opacity: 0.80,
                            child: Transform(
                              transform: Matrix4.identity()
                                ..translate(0.0, 10.0)
                                ..rotateZ(-1.57),
                              child: Container(
                                width: 1,
                                height: 20,
                                decoration: ShapeDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(-0.00, -1.00),
                                    end: Alignment(0, 1),
                                    colors: [Colors.white, Color(0x00D9D9D9)],
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Custom method to build icon with completion status
                    Row(
                      children: [
                        TabIconCommon(
                            index: 1,
                            iconPath: 'assets/images/onboarding_images/int_lang_icon.svg',
                            onTap: () {
                              controller.selectedIndex.value = 1;
                              controller.currentStep.value = 1;
                            }),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Opacity(
                            opacity: 0.80,
                            child: Transform(
                              transform: Matrix4.identity()
                                ..translate(0.0, 10.0)
                                ..rotateZ(-1.57),
                              child: Container(
                                width: 1,
                                height: 20,
                                decoration: ShapeDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(-0.00, -1.00),
                                    end: Alignment(0, 1),
                                    colors: [Colors.white, Color(0x00D9D9D9)],
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    TabIconCommon(
                        index: 2,
                        iconPath: 'assets/images/onboarding_images/select_topic_icon.svg',
                        onTap: () {
                          controller.selectedIndex.value = 2;
                          controller.currentStep.value = 2;
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: PersonalisationTabView(controller.currentStep.value)),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )),
      ),
    );
  }

  _saveTopic() {
    if (isSavingTopic) return;

    if (!getIt<UserInterestsChangeNotifier>().hasFavorites()) {
      showVanillaToast("Favourite at least one item");
      return;
    }
    setState(() => isSavingTopic = true);

    getIt<UserAccount>().setProfilePersonalized(true).then((_) {
      setState(() => isSavingTopic = false);
      if (widget.isComingFromProfile == true) {
        context.pop();
      } else {
        context.pushReplacement("/");
      }
    }).catchError((errorObj) {
      setState(() => isSavingTopic = false);
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast("Failed to update your profile: ${response?.statusCode}");
      }
    });
  }

  _buildLanguages(Map<String, bool>? map, String title) {
    if (map == null) return const SizedBox(); // Return an empty widget if map is null
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 2.2),
          itemCount: map.length,
          itemBuilder: (context, index) {
            String key = map.keys.elementAt(index);
            isChecked = map[key] ?? false;
            return GestureDetector(
              onTap: () {
                //map[key] = !(map[key] ?? true);
              },
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: map[key] == false
                    ? ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0x235E5E5E).withOpacity(0.07),
                            const Color(0x235E5E5E).withOpacity(0.07),
                            const Color(0x005E5E5E).withOpacity(0.14)
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            // Add border side
                            color: map[key] == true ? Colors.white : Colors.transparent, // Set border color
                            width: 1, // Set border width
                          ),
                        ),
                      )
                    : BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    Center(
                        child: Text(
                      map.keys.elementAt(index),
                      style: GoogleFonts.roboto(
                        color: map[key] == false ? Colors.white : Colors.black,
                      ),
                    )),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Checkbox(
                          activeColor: const Color(0xFF0B57D0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          value: isChecked,
                          onChanged: (value) {
                            map[key] = !(map[key] ?? true);
                          },
                        ))

                    //child: Text("pp")),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.selectedIndex.value = 0;
    controller.currentStep.value = 0;
    controller.completionStatus.value = [false, false, false];
  }
}
