import 'dart:convert';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:dor_companion/app_router.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/home/view/home_main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileVm extends ChangeNotifier {
  List<String> profileImages = [];
  List<Profile> profiles = [];
  int numProfiles = 0;
  bool isEdit = false;
  bool isLoading = false;
  bool profileLoaded = false;
  late var customer = Customer(
      phoneCountryCode: "",
      phoneNumber: "",
      mobileNumber: "",
      profiles: [],
      crmUrl: "",
      sms_contact_id: "",
      sms_access_token: "");

  Future<void> fetchData(BuildContext context) async {
    final images = await initProfileImages(context);
    customer = getIt<UserAccount>().customer!;
    profileImages = images;
    profiles = List<Profile>.from(customer.profiles);
    var kidsProfileIndex = profiles.indexWhere((profile) => profile.isRestricted == true);
    if (kidsProfileIndex != -1) {
      var kidsProfile = profiles.removeAt(kidsProfileIndex);
      profiles.add(kidsProfile); // Add the "Kids" profile to the end
    }
    numProfiles = profiles.length;
    debugPrint("profile length $numProfiles");
    profileLoaded = getIt<UserAccount>().isProfileLoaded();
    notifyListeners();
  }

  Future<List<String>> initProfileImages(BuildContext context) async {
    final manifestContents = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContents);
    return manifestMap.keys
        .where((element) => element.contains('profile_images/avatar_'))
        .toList(growable: false);
  }

  void profileItemLongPressed(int? profileId, bool modifiable) {
    final tempProfileId = profileId;
    if (tempProfileId != null && modifiable) {
      HapticFeedback.lightImpact();
      getIt<AppRouter>().push("/profile/$tempProfileId");
    }
  }

  void profileItemTapped(int? profileId, bool isComingFromProfile) {
    var eventProps = {
      'Latitude': Constants.lat,
      'Longitude': Constants.long,
      'Mobile number': Constants.mobile,
      'Login Method': 'Mobile Number login',
      'Network Type': Constants.networkType,
      'Time of Login': CleverTapPlugin.getCleverTapDate(DateTime.now()),
      'Failed Login Attempts': ''
    };

    CleverTapPlugin.recordEvent("Logged in", eventProps);
    final tempProfileId = profileId;
    if (tempProfileId == null) {
      getIt<AppRouter>().push("/newProfile");
      return;
    }

    isLoading = true;
    getIt<UserAccount>()
        .setProfile(tempProfileId)
        .then((_) => {
              if (isComingFromProfile)
                {_preloadApi(), isLoading = false, getIt<AppRouter>().go("/"), getIt<AppRouter>().pop()}
              else
                {_preloadApi(), isLoading = false, getIt<AppRouter>().go("/")}
            })
        .catchError((Object errorObj) {
      isLoading = false;
      debugPrint("_setProfile() modifiable 2 $errorObj");
    });
  }

  Future<void> _preloadApi() async {
    callHomeInit();
  }
}
