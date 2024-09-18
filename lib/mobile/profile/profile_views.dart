import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/firebase_analytics/firebase_performance.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/profile/Widget/add_new_profile_bottom_sheet_content.dart';
import 'package:dor_companion/mobile/profile/controller/profile_controller.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:dor_companion/widgets/profile_gradient_border.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
          Obx(() => Scaffold(
              backgroundColor: Colors.black,
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
                InkWell(
                    radius: 30,
                    onTap: () => profileCtrl.isEdit.value = !profileCtrl.isEdit.value,
                    child: profileCtrl.isEdit.value
                        ? SvgPicture.asset(Assets.assets_images_profile_images_done_button_svg)
                        : SvgPicture.asset(Assets.assets_images_profile_images_edit_button_svg)),
                const SizedBox(height: 60)
              ]),
              body: SafeArea(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Select a profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFFE5E5E5),
                        fontSize: 32,
                        fontFamily: 'DMSerifDisplay',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.20)),
                const Text('You can have upto 5 profiles',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 14,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20)),
                const Spacer(),
                Consumer<UserAccount>(
                    builder: (_, __, ___) => ProfileSelectionBody(
                        isComingFromProfile: widget.isComingFromProfile, bottomSheetContext: context)),
                const Spacer(),
              ])))),
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
              padding: const EdgeInsets.fromLTRB(44, 0, 44, 0),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (index >= profileCtrl.numProfiles.value) {
                  return profileCtrl.isEdit.value == false
                      ? ProfileItemView(
                          cust.mobileNumber,
                          null,
                          null,
                          SvgPicture.asset(Assets.assets_images_profile_images_add_profile_image_svg),
                          false,
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
                  : profileId != null
                      ? profileCtrl.profileItemTapped(profileId, isComingFromProfile)
                      : showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              constraints: BoxConstraints(
                                  minHeight: MediaQuery.sizeOf(context).height * 0.85,
                                  maxHeight: MediaQuery.sizeOf(context).height * 0.85),
                              builder: (context) => const AddNewProfileBottomSheetContent())
                          .then((value) => profileCtrl.nameController.clear());
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
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
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
                                        child: SvgPicture.asset(
                                            Assets.assets_images_profile_images_new_edit_icon_svg,
                                            fit: BoxFit.contain))
                                  ]))))),
                  const SizedBox(height: 16),
                  Text(profileName ?? "Add new",
                      style: const TextStyle(
                          color: Color(0xFFE5E5E5),
                          fontSize: 14,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.w400,
                          height: 0.11))
                ])));
  }
}
