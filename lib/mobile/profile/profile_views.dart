import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/profile/controller/profile_controller.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:dor_companion/widgets/profile_gradient_border.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../data/models/models.dart';
import '../../data/models/user_account.dart';

class ProfileSelectionView extends StatefulWidget {
  final bool showEditButton;
  final bool isComingFromProfile;

  const ProfileSelectionView({super.key, this.showEditButton = false, this.isComingFromProfile = false});

  @override
  State<ProfileSelectionView> createState() => ProfileSelectionViewState();
}

class ProfileSelectionViewState extends State<ProfileSelectionView> {
  @override
  Widget build(BuildContext context) {
    final profileCtrl = Get.put(ProfileController());
    return PerformanceTrackedWidget(
        widgetName: 'profile-selection-view',
        child: Stack(children: [
          Scaffold(
              body: SafeArea(
                  child: GradientBackground(
                      child: Obx(() => Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Visibility(
                                      visible: widget.isComingFromProfile,
                                      maintainSize: true,
                                      maintainState: true,
                                      maintainAnimation: true,
                                      child: IconButton(
                                          onPressed: () => context.pop(),
                                          icon: SvgPicture.asset(Assets.assets_icons_arrow_back_svg,
                                              colorFilter:
                                                  const ColorFilter.mode(Colors.white, BlendMode.srcIn)))),
                                  const Text("Who's watching?", style: AppTypography.bodyText1),
                                  Visibility(
                                      visible: widget.showEditButton,
                                      child: TextButton(
                                          onPressed: () =>
                                              profileCtrl.isEdit.value = !profileCtrl.isEdit.value,
                                          child: profileCtrl.isEdit.value
                                              ? const Icon(Icons.close, color: Colors.white, size: 24)
                                              : SvgPicture.asset(
                                                  Assets.assets_images_profile_images_edit_svg)))
                                ])),
                            Consumer<UserAccount>(
                                builder: (_, __, ___) => ProfileSelectionBody(
                                    isComingFromProfile: widget.isComingFromProfile,
                                    bottomSheetContext: context))
                          ]))))),
          Obx(() {
            debugPrint('isLoading: isLoading = ${profileCtrl.isLoading.value}');
            return Visibility(
                visible: profileCtrl.isLoading.value,
                child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black12,
                    child: const Center(child: Loader())));
          })
        ]));
  }
}

class ProfileSelectionBody extends StatefulWidget {
  final bool isComingFromProfile;
  final BuildContext bottomSheetContext;

  const ProfileSelectionBody({super.key, this.isComingFromProfile = false, required this.bottomSheetContext});

  @override
  State createState() => _ProfileSelectionState();
}

class _ProfileSelectionState extends State<ProfileSelectionBody> {
  Customer? customer;
  late List<String> profileImages;
  List<Profile>? profiles;
  final profileCtrl = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileCtrl.fetchData(context);
  }

  @override
  Widget build(BuildContext context) {
    final cust = profileCtrl.customer.value;
    if (cust == null) {
      return Column(children: [
        Expanded(
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                    color: Colors.red,
                    child: const Center(
                        heightFactor: 2,
                        child: Text('Failed to fetch profiles', style: AppTypography.undefinedTextStyle)))))
      ]);
    }

    return Obx(() => SingleChildScrollView(
            child: Column(children: [
          GridView.builder(
              padding: const EdgeInsets.fromLTRB(24, 70, 0, 0),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (index >= profileCtrl.numProfiles.value) {
                  return profileCtrl.isEdit.value == false
                      ? ProfileItemView(cust.mobileNumber, null, null, const Icon(Icons.add, size: 55), false,
                          widget.isComingFromProfile)
                      : null;
                }
                debugPrint("Profile = ${profileCtrl.profiles![index].name}");
                final profileImage = profileCtrl.profileImages[profileCtrl.profiles![index].facadeId % 13];
                return ProfileItemView(
                    cust.mobileNumber,
                    profileCtrl.profiles![index].id,
                    profileCtrl.profiles![index].name,
                    Image.asset(profileImage, // Bottom image
                        fit: BoxFit.fill),
                    profileCtrl.profileLoaded.value,
                    widget.isComingFromProfile);
              },
              itemCount: profileCtrl.numProfiles.value > 4
                  ? 5
                  : profileCtrl.profileLoaded.value
                      ? profileCtrl.numProfiles.value + 1
                      : profileCtrl.numProfiles.value + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 0, mainAxisSpacing: 0, crossAxisCount: 2, childAspectRatio: 1.0))
        ])));
  }
}

class ProfileLoader extends StatelessWidget {
  const ProfileLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).highlightColor;
    Color highlightColor = Theme.of(context).colorScheme.secondary.withOpacity(0.3);
    return Padding(
        padding: const EdgeInsets.only(left: 25, top: 20, right: 25),
        child: SkeletonGridLoader(
            builder: Container(
                decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(3.0)))),
            items: 4,
            itemsPerRow: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 40,
            period: const Duration(seconds: 2),
            highlightColor: highlightColor,
            baseColor: color,
            direction: SkeletonDirection.ltr));
  }
}

class ProfileItemView extends StatelessWidget {
  final String mobileNumber;
  final int? profileId;
  final String? profileName;
  final Widget image;
  final bool modifiable;
  final bool isComingFromProfile;

  const ProfileItemView(this.mobileNumber, this.profileId, this.profileName, this.image, this.modifiable,
      this.isComingFromProfile,
      {Key? key, required})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileCtrl = Get.put(ProfileController());
    AnalyticsEvent eventCall = AnalyticsEvent();
    return Align(
        alignment: Alignment.center,
        child: GestureDetector(
            onTap: () async {
              final Trace trace = FirebasePerformance.instance.newTrace('profile-change');
              trace.start();
              if (profileCtrl.isEdit.value) {
                eventCall.editProfileEvent('update_profile_screen');
              } else {
                eventCall.changeProfileEvent('update_profile_screen');
              }
              profileCtrl.isEdit.value
                  ? profileCtrl.profileItemLongPressed(profileId, true)
                  : profileCtrl.profileItemTapped(profileId, isComingFromProfile);
              profileCtrl.isEdit.value = false;
              trace.stop();
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profileId == getIt<UserAccount>().profileId
                      ? GradientBorderProfile(
                          child: Center(
                              child: Stack(alignment: Alignment.center, children: [
                          image,
                          Container(
                              color: profileCtrl.isEdit.value && profileId != null
                                  ? const Color(0x0001074d).withOpacity(0.6)
                                  : Colors.transparent),
                          Visibility(
                              visible: profileCtrl.isEdit.value,
                              child: SvgPicture.asset(Assets.assets_images_profile_images_edit_svg,
                                  fit: BoxFit.contain))
                        ])))
                      : SizedBox(
                          width: 110,
                          height: 110,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(34.0),
                              child: Container(
                                  padding: profileId != null
                                      ? const EdgeInsets.all(0.0)
                                      : const EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(color: const Color(0x00ffffff).withOpacity(0.1)),
                                  child: Center(
                                      child: Stack(alignment: Alignment.center, children: [
                                    image,
                                    Container(
                                        color: profileCtrl.isEdit.value && profileId != null
                                            ? const Color(0x0001074d).withOpacity(0.6)
                                            : Colors.transparent),
                                    Visibility(
                                        visible: profileCtrl.isEdit.value && profileId != null,
                                        child: SvgPicture.asset(Assets.assets_images_profile_images_edit_svg,
                                            fit: BoxFit.contain))
                                  ]))))),
                  const SizedBox(height: 16),
                  Text(profileName ?? "Add Profile", style: AppTypography.addProfile)
                ])));
  }
}
