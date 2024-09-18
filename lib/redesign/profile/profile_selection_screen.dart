import 'package:dor_companion/assets.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/redesign/profile/profile_vm.dart';
import 'package:dor_companion/widgets/profile_gradient_border.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileSelectionScreen extends StatefulWidget {
  final bool isComingFromProfile;
  final bool showEditButton;

  const ProfileSelectionScreen({super.key, this.isComingFromProfile = false, this.showEditButton = false});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  late ProfileVm profileVm;

  @override
  void initState() {
    profileVm = ProfileVm();
    WidgetsBinding.instance.addPostFrameCallback((_) => profileVm.fetchData(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => profileVm,
        child: Scaffold(
            bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                  onTap: () {}, child: SvgPicture.asset(Assets.assets_images_profile_images_edit_button_svg)),
              const SizedBox(height: 100)
            ]),
            backgroundColor: Colors.black,
            body: Column(children: [
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
              Consumer<ProfileVm>(
                  builder: (context, profileVm, child) => GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 70, 0, 0),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final customer = profileVm.customer;
                        if (index >= profileVm.numProfiles) {
                          return profileVm.isEdit == false
                              ? ProfileItemView(customer.mobileNumber, null, null,
                                  const Icon(Icons.add, size: 55), false, widget.isComingFromProfile)
                              : null;
                        }
                        debugPrint("Profile = ${profileVm.profiles[index].name}");
                        final profileImage = profileVm.profileImages[profileVm.profiles[index].facadeId % 13];
                        return ProfileItemView(
                            customer.mobileNumber,
                            profileVm.profiles[index].id,
                            profileVm.profiles[index].name,
                            Image.asset(profileImage, // Bottom image
                                fit: BoxFit.fill),
                            profileVm.profileLoaded,
                            widget.isComingFromProfile);
                      },
                      itemCount: profileVm.numProfiles > 4
                          ? 5
                          : profileVm.profileLoaded
                              ? profileVm.numProfiles + 1
                              : profileVm.numProfiles + 1,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 0, mainAxisSpacing: 0, crossAxisCount: 2, childAspectRatio: 1.0)))
            ])));
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
    AnalyticsEvent eventCall = AnalyticsEvent();
    return Consumer<ProfileVm>(
        builder: (context, profileVm, child) => Align(
            alignment: Alignment.center,
            child: GestureDetector(
                onTap: () async {
                  final Trace trace = FirebasePerformance.instance.newTrace('profile-change');
                  trace.start();
                  if (profileVm.isEdit) {
                    eventCall.editProfileEvent('update_profile_screen');
                  } else {
                    eventCall.changeProfileEvent('update_profile_screen');
                  }
                  profileVm.isEdit
                      ? profileVm.profileItemLongPressed(profileId, true)
                      : profileVm.profileItemTapped(profileId, isComingFromProfile);
                  profileVm.isEdit = false;
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
                                  color: profileVm.isEdit && profileId != null
                                      ? const Color(0x0001074d).withOpacity(0.6)
                                      : Colors.transparent),
                              Visibility(
                                  visible: profileVm.isEdit,
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
                                      decoration:
                                          BoxDecoration(color: const Color(0x00ffffff).withOpacity(0.1)),
                                      child: Center(
                                          child: Stack(alignment: Alignment.center, children: [
                                        image,
                                        Container(
                                            color: profileVm.isEdit && profileId != null
                                                ? const Color(0x0001074d).withOpacity(0.6)
                                                : Colors.transparent),
                                        Visibility(
                                            visible: profileVm.isEdit && profileId != null,
                                            child: SvgPicture.asset(
                                                Assets.assets_images_profile_images_edit_svg,
                                                fit: BoxFit.contain))
                                      ]))))),
                      const SizedBox(height: 16),
                      Text(profileName ?? "Add New", style: AppTypography.addProfile)
                    ]))));
  }
}
