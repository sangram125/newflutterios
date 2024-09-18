import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/data/models/user_interests.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/profile/language_screen/language_controller.dart';
import 'package:dor_companion/mobile/screens/personalization_view.dart';
import 'package:dor_companion/utils.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/view/home_main_view.dart';
import '../../../home/view/news_view.dart';
import '../../../home/view/sports_view.dart';
import '../../../widgets/live_tv_view.dart';

// class PersonalisationTabView extends StatefulWidget {
//   final int step;
//
//   const PersonalisationTabView(this.step, {super.key});
//
//   @override
//   State createState() => _PersonalisationTabViewState();
// }
//
// class _PersonalisationTabViewState extends State<PersonalisationTabView> {
//   final LanguageController controller = Get.put(LanguageController());
//   final AnalyticsEvent eventCall = AnalyticsEvent();
//   bool isSaving = false;
//   bool isSavingTopic = false;
//
//   @override
//   Widget build(BuildContext context) {
//     switch (widget.step) {
//       case 0:
//         return _buildLanguageSelectionView(controller.favoritesMap, "National");
//       case 1:
//         return _buildLanguageSelectionView(controller.internationalFavoritesMap, "International");
//       case 2:
//         return _buildFinalStepView();
//       default:
//         return Column(children: [Container()]);
//     }
//   }
//
//   Widget _buildLanguageSelectionView(Map? languageMap, String title) {
//     return Obx(() => Column(children: [
//           _buildHeader(title),
//           _buildLanguageList(languageMap),
//           _buildNextButton(() async {
//             eventCall.languagePreferenceEvent('language_preference_screen');
//             await controller.save(context);
//             controller.isSkipPressed = false;
//           }),
//           const SizedBox(height: 10)
//         ]));
//   }
//
//   Widget _buildHeader(String title) {
//     return Column(children: [
//       Center(
//           child: Text("Select $title Languages",
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 0.10),
//               textAlign: TextAlign.center)),
//       const SizedBox(height: 5),
//       const Center(
//           child: Text("To get better content suggestions",
//               style: TextStyle(
//                   color: Color(0xFF8F8F8F),
//                   fontSize: 14,
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.w400,
//                   letterSpacing: 0.25),
//               textAlign: TextAlign.center)),
//       const SizedBox(height: 20)
//     ]);
//   }
//
//   Widget _buildLanguageList(Map? map) {
//     if (map == null) return const SizedBox();
//     return Expanded(
//         flex: 6,
//         child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ListView(children: [
//               Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [const SizedBox(height: 20), _buildLanguages(map)])
//             ])));
//   }
//
//   Widget _buildNextButton(VoidCallback onPressed) {
//     return Expanded(
//         flex: 1,
//         child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
//           SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: ElevatedButton(
//                       onPressed: controller.favoritesMap.containsValue(true) ? onPressed : null,
//                       style: ButtonStyle(
//                           shape: WidgetStateProperty.all(
//                               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
//                           backgroundColor: WidgetStateProperty.all(controller.favoritesMap.containsValue(true)
//                               ? Colors.white.withOpacity(0.96)
//                               : const Color(0x115E5E5E))),
//                       child: controller.isSaving.value
//                           ? const Center(child: Loader())
//                           : const Text('Next',
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 17,
//                                   fontFamily: 'Roboto',
//                                   fontWeight: FontWeight.w600)))))
//         ]));
//   }
//
//   Widget _buildFinalStepView() {
//     return Column(children: [
//       const Expanded(child: PersonalizationView()),
//       Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
//             SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: ElevatedButton(
//                         onPressed: _saveTopic,
//                         style: ButtonStyle(
//                             shape: WidgetStateProperty.all(
//                                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
//                             backgroundColor: WidgetStateProperty.all(Colors.white.withOpacity(0.96))),
//                         child: isSavingTopic
//                             ? const Center(child: Loader())
//                             : const Text('Done',
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 17,
//                                     fontFamily: 'Roboto',
//                                     fontWeight: FontWeight.w600)))))
//           ]))
//     ]);
//   }
//
//   Future<void> _saveTopic() async {
//     if (isSavingTopic) return;
//     if (!getIt<UserInterestsChangeNotifier>().hasFavorites()) {
//       showVanillaToast("Favourite at least one item");
//       return;
//     }
//     setState(() => isSavingTopic = true);
//     try {
//       getIt<UserAccount>().setProfilePersonalized(true).then((value) {
//         setState(() => isSavingTopic = false);
//         context.pushReplacement("/");
//         callHomeInit();
//         callInitNews();
//         callInitSports();
//         callInit();
//       });
//     } catch (error) {
//       setState(() => isSavingTopic = false);
//       if (error is DioException) {
//         final response = error.response;
//         showVanillaToast("Failed to update your profile: ${response?.statusCode}");
//       }
//     }
//   }
//
//   Widget _buildLanguages(Map? map) {
//     if (map == null) return const SizedBox();
//
//     return Obx(() {
//       return GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 2.2),
//           itemCount: map.length,
//           itemBuilder: (context, index) {
//             String key = map.keys.elementAt(index);
//             bool isChecked = map[key] ?? false;
//             return GestureDetector(
//                 onTap: () => map[key] = !isChecked,
//                 child: Container(
//                     clipBehavior: Clip.antiAlias,
//                     decoration: BoxDecoration(
//                         color: isChecked ? Colors.white : Colors.transparent,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: isChecked ? Colors.transparent : Colors.white, width: 1)),
//                     child: Stack(children: [
//                       Center(
//                           child: Text(key,
//                               style: GoogleFonts.roboto(color: isChecked ? Colors.black : Colors.white))),
//                       Align(
//                           alignment: Alignment.bottomLeft,
//                           child: Checkbox(
//                               activeColor: const Color(0xFF0B57D0),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                               value: isChecked,
//                               onChanged: (value) {
//                                 map[key] = !(map[key] ?? true);
//                               }))
//                     ])));
//           });
//     });
//   }
// }

class PersonalisationTabView extends StatefulWidget {
  final int step;

  const PersonalisationTabView(this.step, {super.key});

  @override
  State<PersonalisationTabView> createState() => _PersonalisationTabViewState();
}

class _PersonalisationTabViewState extends State<PersonalisationTabView> {
  LanguageController controller = Get.put(LanguageController());

  AnalyticsEvent eventCall = AnalyticsEvent();

  bool isSaving = false;
  bool isSavingTopic = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    switch (widget.step) {
      case 0:
        return Obx(() => Column(children: [
              const Center(
                  child: Text("Select Preferred Languages",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.10,
                      ),
                      textAlign: TextAlign.center)),
              const SizedBox(height: 5),
              const Center(
                  child: Text("To get better content suggestions",
                      style: TextStyle(
                          color: Color(0xFF8F8F8F),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25),
                      textAlign: TextAlign.center)),
              const SizedBox(height: 20),
              Expanded(
                  flex: 6,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              _buildLanguages(controller.favoritesMap, "National")
                            ])
                      ]))),
              Expanded(
                  flex: 1,
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                                onPressed: controller.favoritesMap.containsValue(true)
                                    ? () async {
                                        eventCall.languagePreferenceEvent('language_preference_screen');
                                        await controller.save(context);
                                        controller.isSkipPressed = false;
                                      }
                                    : null,
                                style: controller.favoritesMap.containsValue(true)
                                    ? ButtonStyle(
                                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.0))),
                                        backgroundColor: WidgetStateProperty.all<Color>(
                                            Colors.white.withOpacity(0.9599999785423279)))
                                    : ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(const Color(0x115E5E5E))),
                                child: controller.isSaving.value
                                    ? const Center(child: Loader())
                                    : Text('Next',
                                        style: TextStyle(
                                            color: controller.favoritesMap.containsValue(true)
                                                ? Colors.black
                                                : const Color(0x725E5E5E),
                                            fontSize: 17,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600)))))
                  ])),
              const SizedBox(height: 10)
            ]));
      case 1:
        return Obx(() => Column(children: [
              const Center(
                  child: Text("Select International Languages",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10),
                      textAlign: TextAlign.center)),
              const SizedBox(height: 5),
              const Center(
                  child: Text("To get better content suggestions",
                      style: TextStyle(
                          color: Color(0xFF8F8F8F),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25),
                      textAlign: TextAlign.center)),
              const SizedBox(height: 20),
              Expanded(
                  flex: 6,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              _buildLanguages(controller.internationalFavoritesMap, "International")
                            ])
                      ]))),
              Expanded(
                  flex: 1,
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                                onPressed: () async {
                                  eventCall.languagePreferenceEvent('language_preference_screen');
                                  await controller.save(context);
                                  controller.isSkipPressed = false;
                                },
                                style: ButtonStyle(
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
                                    backgroundColor: WidgetStateProperty.all<Color>(
                                        Colors.white.withOpacity(0.9599999785423279))),
                                child: isSaving
                                    ? const Center(child: Loader())
                                    : controller.isSaving.value
                                        ? const Center(child: Loader())
                                        : const Text('Next',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w600)))))
                  ])),
              const SizedBox(height: 10)
            ]));
      case 2:
        return Column(children: [
          const Expanded(child: PersonalizationView()),
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                            onPressed: () async => await _saveTopic(),
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.white.withOpacity(0.9599999785423279))),
                            child: isSavingTopic
                                ? const Center(child: Loader())
                                : controller.isSaving.value
                                    ? const Center(child: Loader())
                                    : const Text('Done',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600)))))
              ]))
        ]);
      default:
        return Column(children: [Container()]);
    }
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
      context.pushReplacement("/");
      callHomeInit();
      // callInitNews();
      // callInitSports();
      // callInit();
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
    return Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      map[key] = !(map[key] ?? true);
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
                                    ]),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                        // Add border side
                                        color: map[key] == true ? Colors.white : Colors.transparent,
                                        // Set border color
                                        width: 1)))
                            : BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Stack(children: [
                          Center(
                              child: Text(map.keys.elementAt(index),
                                  style: GoogleFonts.roboto(
                                      color: map[key] == false ? Colors.white : Colors.black))),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Checkbox(
                                  activeColor: const Color(0xFF0B57D0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  value: isChecked,
                                  onChanged: (value) {
                                    map[key] = !(map[key] ?? true);
                                  }))
                        ])));
              })
        ]));
  }
}
