import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/about/about.dart';
import 'package:dor_companion/mobile/help_and_support/faq_main_page/faq_widget.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/custom_bottom_sheet.dart';
import 'package:dor_companion/mobile/my_plan/my_plan.dart';
import 'package:dor_companion/mobile/privacy_policy/privacy_policy.dart';
import 'package:dor_companion/mobile/profile/Widget/selection_view.dart';
import 'package:dor_companion/mobile/profile/language_screen/language_controller.dart';
import 'package:dor_companion/mobile/profile/language_screen/languages_view.dart';
import 'package:dor_companion/mobile/profile/profile_views.dart';
import 'package:dor_companion/mobile/profile/settings_view.dart';
import 'package:dor_companion/mobile/terms_and_conditions/terms_and_conditions.dart';
import 'package:dor_companion/mobile/widgets/library_view.dart';
import 'package:dor_companion/widgets/common_alert_dialog.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../data/api/sensy_api.dart';
import '../../utils.dart';
import 'controller/profile_controller.dart';

class ProfileMainScreen extends StatefulWidget {
  const ProfileMainScreen({Key? key}) : super(key: key);

  @override
  State<ProfileMainScreen> createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends State<ProfileMainScreen> {
  final profileCtrl = Get.put(ProfileController());
  AnalyticsEvent eventCall = AnalyticsEvent();
  final controller = Get.put(LanguageController());
  String version = "";

  @override
  void initState() {
    super.initState();
    profileCtrl.fetchData(context);
    getVersion();
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    debugPrint('Version: ${packageInfo.version}');
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
            child: GradientBackground(
                child: Column(children: [
      Container(
          padding: EdgeInsets.only(top: screenHeight * 0.09),
          child: Column(children: [
            Column(children: [
              Stack(alignment: Alignment.center, children: [
                Consumer<UserAccount>(
                    builder: (context, value, child) => Obx(() =>
                        CircleAvatar(radius: 50.0, backgroundImage: AssetImage(buildProfileImage(value)))))
              ]),
              const SizedBox(height: 7)
            ]),
            Align(
                alignment: Alignment.center,
                child: Consumer<UserAccount>(
                    builder: (context, value, child) =>
                        AutoSizeText(value.profileName, style: AppTypography.profileNameText))),
            Align(
                alignment: Alignment.center,
                child: Consumer<UserAccount>(
                    builder: (context, value, child) => Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: AutoSizeText(value.phoneNumber, style: AppTypography.profileMobileNo))))
          ])),
      Column(children: [
        GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenWidth * 0.05),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return SelectionView(
                  title: profileCtrl.menuList.elementAt(index),
                  iconPath: profileCtrl.menuIconList.elementAt(index),
                  onTap: () {
                    switch (index) {
                      case 0:
                        controller.selectedIndex.value = 0;
                        controller.currentStep.value = 0;
                        eventCall.editPreferenceEvent('profile_screen');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileSelectionView(
                                    showEditButton: true, isComingFromProfile: true)));
                        break;
                      case 1:
                        eventCall.switchProfileEvent('profile_screen');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LanguageView(isComingFromProfile: true)));
                        break;
                      case 2:
                        eventCall.libraryEvent('profile_screen');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LibraryView()));
                        break;
                      case 3:
                        eventCall.settingEvent('profile_screen');
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const SettingsView()));
                        break;
                      default:
                        break;
                    }
                  });
            },
            // itemCount: numProfiles,
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 16, mainAxisSpacing: 16, crossAxisCount: 2, childAspectRatio: 1.7))
      ]),
      Stack(children: [
        Row(children: [
          Expanded(
              child: Column(children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                    onTap: () {
                      eventCall.helpAndSupportEvent('profile_screen');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqView()));
                    },
                    leading: SvgPicture.asset(Assets.assets_images_profile_images_help_support_svg),
                    title:
                        const AutoSizeText("Help and Support", style: AppTypography.profileMainViewsTitle))),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white.withOpacity(0.5))),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                    title: GestureDetector(
                        onTap: () => Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const MyPlanScreen())),
                        child: const AutoSizeText("My Plan", style: AppTypography.profileMainViewsTitle)),
                    leading: SvgPicture.asset(Assets.assets_images_profile_images_my_plan_svg),
                    trailing: Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: Obx(() => MouseRegion(
                            onHover: (_) => profileCtrl.isHovered.value = !profileCtrl.isHovered.value,
                            onExit: (_) => profileCtrl.isHovered.value = false,
                            child: InkWell(
                                onTap: () {
                                  eventCall.myRemoteEvent('profile_screen');
                                  getIt<SensyApi>().fetchTvDevices().then((devices) {
                                    if (devices.isEmpty) {
                                      showVanillaToast("Nox paired devices");
                                      return;
                                    }
                                    final deviceId = devices.first.id.toString();
                                    context.push("/remote/$deviceId");
                                  }).catchError((errorObj, stackTrace) {
                                    switch (errorObj.runtimeType) {
                                      case DioException:
                                        final response = (errorObj as DioException).response;
                                        showVanillaToast(
                                            "Failed to retrieve devices: ${response?.statusCode}");
                                        break;
                                      default:
                                        if (kDebugMode) {
                                          print("Non DioException during fetchTvDevices: $errorObj");
                                        }
                                        showVanillaToast("Failed to retrieve devices");
                                    }
                                  });
                                },
                                child: Ink(
                                    decoration: ShapeDecoration(
                                        color: profileCtrl.isHovered.value
                                            ? const Color(0xFF146846)
                                            : const Color(0x3FDA0C15),
                                        shape:
                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                                    child: SvgPicture.asset(Assets.assets_images_profile_images_tv_remote_svg,
                                        colorFilter:
                                            const ColorFilter.mode(Colors.white, BlendMode.srcIn))))))))),
            //my plan
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white.withOpacity(0.5))),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                    title: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomBottomSheet(
                                    content: Column(children: [
                                  MenuItem(
                                      icon: Assets.assets_icons_icon_about_3sixty_svg,
                                      text: 'About Dor',
                                      onTap: () => Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => const AboutScreen()))),
                                  MenuItem(
                                      icon: Assets.assets_icons_icon_privacy_policy_svg,
                                      text: 'Privacy Policy',
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PrivacyPolicy(showSearchIcon: true)))),
                                  MenuItem(
                                      icon: Assets.assets_icons_icon_terms_of_use_svg,
                                      text: 'Terms of use',
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TermsAndConditions(showSearchIcon: true))))
                                ]));
                              },
                              backgroundColor: Colors.transparent,
                              isScrollControlled: false,
                              barrierColor: const Color(0xff00021f).withOpacity(.5));
                        },
                        child: const AutoSizeText("About", style: AppTypography.profileMainViewsTitle)),
                    leading: SvgPicture.asset(Assets.assets_images_profile_images_about_svg))),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white.withOpacity(0.5))),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                    onTap: () {
                      CommonAlertDialog.showAlertDialog(
                          context: context,
                          child: CommonAlertDialog.commonDialogContent(
                              context: context,
                              title: 'Are you sure you want to\nSign Out?',
                              yesText: 'Yes, sign out',
                              onYes: () {
                                Navigator.of(context).pop();
                                profileCtrl.showEditDelete.value = false;
                                getIt<UserAccount>().logout();
                              },
                              onNo: () => Navigator.pop(context)));
                    },
                    leading: SvgPicture.asset(Assets.assets_images_profile_images_sign_out_svg),
                    title: const AutoSizeText("Sign Out", style: AppTypography.profileMainViewsTitle))),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white.withOpacity(0.5))),
            Row(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("version $version", style: AppTypography.lastActiveManageDevicesText))
            ])
          ]))
        ])
      ]),
      const SizedBox(height: 20)
    ]))));
  }

  String buildProfileImage(UserAccount value) {
    try {
      profileCtrl.profileImage.value = profileCtrl.profileImages[value.profiles.first.facadeId % 13];
      for (var element in value.profiles) {
        if (element.id == value.profileId) {
          profileCtrl.profileImage.value = profileCtrl.profileImages[element.facadeId % 13];
        }
      }
      return profileCtrl.profileImage.value;
    } catch (e) {
      debugPrint('e-- $e');
    }
    return Assets.assets_images_app_logos_icon_edit_png;
  }
}
