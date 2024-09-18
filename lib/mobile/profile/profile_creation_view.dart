import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/firebase_remote_connfig/firebase_remote_config.dart';
import 'package:dor_companion/mobile/profile/controller/profile_controller.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProfileCreationView extends StatelessWidget {
  const ProfileCreationView({super.key});

  @override
  Widget build(BuildContext context) {
    AnalyticsEvent eventCall = AnalyticsEvent();

    final profileCtrl = Get.put(ProfileController());
    return Stack(children: [
      Scaffold(
          body: SafeArea(
              child: GradientBackground(
                  child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
              icon: SvgPicture.asset(Assets.assets_icons_arrow_back_svg,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              onPressed: () {
                profileCtrl.nameController.clear();
                Navigator.pop(context);
              }),
          const Text("Add profile", style: AppTypography.addProfile),
          IconButton(
              icon: const Icon(Icons.done, color: Colors.white),
              onPressed: () {
                if (profileCtrl.nameController.text.isNotEmpty) {
                  eventCall.addNewProfileEvent("update_profile_screen");
                  profileCtrl.createProfile();
                }
              })
        ]),
        const ProfileCreationBody()
      ])))),
      Obx(() => profileCtrl.isLoading.value
          ? Container(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              color: Colors.black12,
              child: const Center(child: Loader()))
          : const SizedBox.shrink())
    ]);
  }
}

class ProfileCreationBody extends StatefulWidget {
  const ProfileCreationBody({super.key});

  @override
  State createState() => _ProfileCreationBodyState();
}

class _ProfileCreationBodyState extends State<ProfileCreationBody> {
  AnalyticsEvent eventCall = AnalyticsEvent();
  final profileCtrl = Get.put(ProfileController());
  final remoteConfigService = FirebaseRemoteConfigService();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(children: [const SizedBox(height: 30), buildNameField()]));
  }

  buildNameField() {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24),
              child: TextFormField(
                  controller: profileCtrl.nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 25),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: const Color(0xffa8c7fa).withOpacity(.4)),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: Color(0xffa8c7fa)),
                          borderRadius: BorderRadius.circular(8)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Theme.of(context).colorScheme.error),
                          borderRadius: BorderRadius.circular(8)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.error),
                          borderRadius: BorderRadius.circular(5)),
                      labelStyle: const TextStyle(color: Colors.white),
                      labelText: 'Name',
                      helperText: ' ',
                      errorText: profileCtrl.nameError.isNotEmpty ? profileCtrl.nameError.value : null,
                      prefixStyle: AppTypography.profileModificationView,
                      floatingLabelBehavior: FloatingLabelBehavior.always)))
        ]));
  }
}
