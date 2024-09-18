import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/firebase_remote_connfig/firebase_remote_config.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/profile/controller/profile_controller.dart';
import 'package:dor_companion/widgets/common_alert_dialog.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ProfileModificationView extends StatefulWidget {
  final int profileId;

  const ProfileModificationView({super.key, required this.profileId});

  @override
  State<StatefulWidget> createState() => _ProfileModificationState();
}

class _ProfileModificationState extends State<ProfileModificationView> {
  bool saving = false;
  final profileCtrl = Get.find<ProfileController>();
  List<String> imagePaths = [];
  final remoteConfigService = FirebaseRemoteConfigService();

  @override
  void initState() {
    super.initState();
    profileCtrl.fetchProfile(widget.profileId);
    _fetchRemoteConfig();
  }

  Future<void> _fetchRemoteConfig() async {
    await remoteConfigService.initialize();
    setState(() {
      imagePaths = remoteConfigService.getProfileImageUrls();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      SafeArea(
          child: GradientBackground(
              child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
              icon: SvgPicture.asset(Assets.assets_icons_arrow_back_svg,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              onPressed: () => Navigator.pop(context)),
          const Text("Edit Profile", style: AppTypography.addProfile),
          IconButton(
              icon: const Icon(Icons.done, color: Colors.white),
              onPressed: () async => await profileCtrl.saveChanges(context, widget.profileId))
        ]),
        Expanded(child: getBody()),
        if ((profileCtrl.profile?.isRestricted ?? true) == false)
          InkWell(
              onTap: () => CommonAlertDialog.showAlertDialog(
                  context: context,
                  child: CommonAlertDialog.commonDialogContent(
                      context: context,
                      title: 'Are you sure you want to\ndelete profile?',
                      yesText: 'Yes, Delete',
                      onYes: () async {
                        context.pop();
                        int selectedProfileId = getIt<UserAccount>().profileId;
                        await profileCtrl.deleteProfile(profileCtrl.profile!, context, selectedProfileId);
                      },
                      onNo: () => Navigator.pop(context))),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SvgPicture.asset(Assets.assets_icons_delete_svg,
                        width: 22,
                        height: 22,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                    const SizedBox(width: 6),
                    Text('Delete Profile',
                        style: AppTypography.homeViewTitle.copyWith(fontSize: 16, color: Colors.white))
                  ])))
      ]))),
      Obx(() => profileCtrl.isLoading.value
          ? Container(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              color: Colors.black12,
              child: const Center(child: Loader()))
          : const SizedBox.shrink())
    ]));
  }

  Widget getBody() {
    if (saving) {
      return const Center(child: Loader());
    }

    final prof = profileCtrl.profile;
    if (prof == null) {
      return Expanded(
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                  color: Colors.red,
                  child: const Center(
                      heightFactor: 2,
                      child: Text('Failed to fetch profile', style: AppTypography.undefinedTextStyle)))));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(height: 20),
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
                  floatingLabelBehavior: FloatingLabelBehavior.always))),
      const Spacer()
    ]);
  }
}
