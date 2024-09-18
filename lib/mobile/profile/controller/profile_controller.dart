import 'dart:convert';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:dio/dio.dart';
import 'package:dor_companion/app_router.dart';
import 'package:dor_companion/data/api/distro_api.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/mobile/home/view/news_view.dart';
import 'package:dor_companion/mobile/home/view/sports_view.dart';
import 'package:dor_companion/mobile/widgets/live_tv_view.dart';
import 'package:dor_companion/utils.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/models.dart';
import '../../../data/models/user_account.dart';
import '../../../injection/injection.dart';
import '../../home/view/home_main_view.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxString profileImage = "".obs;
  RxInt numProfiles = 0.obs;
  RxBool newMovies = true.obs,
      rewardsOffers = false.obs,
      parentalControl = false.obs;
  Rx<Customer?> customer = Customer(
          phoneCountryCode: "",
          phoneNumber: "",
          mobileNumber: "",
          profiles: [],
          // activePlans: [],
          crmUrl: "",
          sms_contact_id: "",
          sms_access_token: "")
      .obs;
  RxList<String> profileImages = <String>[].obs;
  List<Profile>? profiles = <Profile>[].obs;
  RxBool profileLoaded = false.obs;
  Profile? profile;

  final nameController = TextEditingController();
  RxBool saving = false.obs;
  RxBool isCreatingProfile = false.obs;
  RxString nameError = ''.obs;
  RxBool isEdit = false.obs;
  RxBool showEditDelete = false.obs;
  List<String> menuList = [
    "Switch Profile",
    "My Preference",
    "My Watchlist",
    "Settings"
  ];
  List<String> menuIconList = [
    "assets/images/profile_images/switch_users.svg",
    "assets/images/profile_images/preference.svg",
    "assets/images/profile_images/library_icon.svg",
    'assets/images/profile_images/settings_new.svg'
  ];
  RxBool isHovered = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  fetchData(BuildContext context) async {
    final profileImages = await initProfileImages(context);
    customer.value = getIt<UserAccount>().customer;
    this.profileImages.value = profileImages;
    profiles = List<Profile>.from(customer.value!.profiles);
    var kidsProfileIndex =
        profiles?.indexWhere((profile) => profile.isRestricted == true);
    if (kidsProfileIndex != -1) {
      var kidsProfile = profiles?.removeAt(kidsProfileIndex!);
      profiles?.add(kidsProfile!); // Add the "Kids" profile to the end
    }
    numProfiles.value = profiles!.length;
    print("profile length ${numProfiles.value}");
    profileLoaded.value = getIt<UserAccount>().isProfileLoaded();
  }

  Future<List<String>> initProfileImages(BuildContext context) async {
    final manifestContents =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContents);
    return manifestMap.keys
        .where((element) => element.contains('profile_images/avatar_'))
        .toList(growable: false);
  }

  void profileItemTapped(int? profileId, bool isCommingFromProfile) {
    var eventProps = {
      'Latitude': Constants.lat,
      'Longitude': Constants.long,
      'Mobile number': Constants.mobile,
      'Login Method': 'Mobile Number login',
      'Network Type': Constants.networkType,
      'Time of Login': CleverTapPlugin.getCleverTapDate(DateTime.now()),
      'Failed Login Attempts': '',
    };

    CleverTapPlugin.recordEvent("Logged in", eventProps);
    final tempProfileId = profileId;
    if (tempProfileId == null) {
      getIt<AppRouter>().push("/newProfile");
      return;
    }

    isLoading.value = true;

    getIt<UserAccount>()
        .setProfile(tempProfileId)
        .then((_) => {
              if (isCommingFromProfile){
                  _preloadApi(),
                isLoading.value = false,
                  getIt<AppRouter>().go("/"),
                  getIt<AppRouter>().pop()
                }
              else
                {
                  _preloadApi(),
                  isLoading.value = false,
                  getIt<AppRouter>().go("/")
                  // getIt<UserAccount>().setOnHome(true)
                }
            })
        .catchError((Object errorObj) {
      isLoading.value = false;
      debugPrint("_setProfile() modifiable 2 $errorObj");
      switch (errorObj.runtimeType) {
        default:
      }
    });
  }

  Future<void> _preloadApi() async {
    callHomeInit();
    // callInitNews();
    // callInitSports();
    //callInit();
  }

  void profileItemLongPressed(int? profileId, bool modifiable) {
    final tempProfileId = profileId;
    if (tempProfileId != null && modifiable) {
      HapticFeedback.lightImpact();
      getIt<AppRouter>().push("/profile/$tempProfileId");
    }
  }

  deleteProfile(Profile profile, BuildContext context, int selectedProfileId) {
    isLoading.value = true;
    final id = profile.id;
    final Trace trace = FirebasePerformance.instance.newTrace('delete-profile');
    trace.start();
    getIt<UserAccount>().deleteProfile(id).then((value) {
      isLoading.value = false;
      nameController.clear();
      showVanillaToast('Profile deleted successfully');
      if (selectedProfileId == id) {
        context.go("/");
      } else {
        customer.value = getIt<UserAccount>().customer;
        profiles = customer.value!.profiles;
        numProfiles.value = profiles!.length;
        context.go("/");
       // Navigator.pop(context);
      }
    }).catchError((Object errorObj) {
      isLoading.value = false;
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          debugPrint("Failed to delete profile: ${response?.statusCode}");
          showVanillaToast('Failed to delete profile: ${response?.statusCode}');
          CustomSnackBar.showCustomSnackbar(
              toastType: ToastType.error,
              message: 'Failed to delete profile: ${response?.statusCode}');
          Navigator.pop(context);
      }
    });
    trace.stop();
  }

  Future<void> fetchProfile(int profileId) async {
    customer.value = getIt<UserAccount>().customer;
    // customer = cust;
    print("customer length ${customer!.value!.profiles.length}");
    if (customer.value != null) {
      final profiles =
          customer.value!.profiles.where((profile) => profile.id == profileId);

      final tempProfile = profiles.first;

      profile = tempProfile;

      nameController.text = profile!.name ?? "";
    }
  }

  String? validateName(String name) {
    if (name.isEmpty) return "Name can't be empty";
    if (name.length > 50) return "Name too long, up to 50 characters only";
    RegExp exp = RegExp(r"^[a-zA-Z0-9]+( [a-zA-Z0-9]+)*$");
    if (exp.hasMatch(name)) return null;
    return "Name can contain only alphanumeric characters and spaces";
  }

  saveChanges(BuildContext context, int profileId) {
    final tempProfile = profile;
    if (tempProfile == null) return;

    final newName = nameController.text.trim();

    final errorString = validateName(newName);
    if (errorString != null) {
      showVanillaToast(errorString);
      return;
    }

    if (tempProfile.name == newName) {
      context.pop();
      showVanillaToast("No changes made");
      return;
    }

    saving.value = true;

    getIt<SensyApi>()
        .renameProfile(profileId.toString(), newName)
        .then((value) async {
      await getIt<SensyApi>().fetchCustomer().then((customerDetail) async {
        customer.value = customerDetail;
        profiles = customerDetail.profiles;
      });
      final userAccount = getIt<UserAccount>();

      for (int i = 0; i < userAccount.customer!.profiles.length; i++) {
        if (userAccount.customer!.profiles.elementAt(i).id == profileId) {
          userAccount.setProfileName(newName);
        }
      }
      showVanillaToast("Profile updated successfully");
      context.go("/");
      //context.pop();
    }).catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print("Failed to update profile: ${response?.statusCode}");
      }
    });
  }

  createProfile() {
    isLoading.value = true;
    final tempName = nameController.text;
    final tempNameError = validateNameForCreateProfile(tempName);
    print('temp name $tempNameError');
    if (tempNameError != null) {
      // setState(() {

      isCreatingProfile.value = false;
      print('temp name $tempNameError');
      nameError.value = tempNameError;
      print("name error ${nameError.value}");
      // });
      return;
    }
    print("name error ${nameError.value}");
    getIt<UserAccount>().createProfile(tempName).then((_) {
      isLoading.value = false;
      nameController.clear();
      getIt<AppRouter>().go("/");
    }).catchError((Object errorObj) {
      nameController.clear();
      isLoading.value = false;
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          if (kDebugMode) {
            print("Error code ${response?.statusCode}, ${response.toString()}");
          }
          // setState(() {
          isCreatingProfile.value = false;
          nameError.value =
              "Failed to create profile try again: ${response?.statusCode}";
          //});
          break;
        default:
          if (kDebugMode) {
            print("Non DioException during createProfile: $errorObj");
          }
          showVanillaToast("Failed to create profile, try logging in again");
          getIt<UserAccount>().logout();
      }
    });
  }

  String? validateNameForCreateProfile(String name) {
    if (name.isEmpty) return "Name can't be empty";
    if (name.length > 25) return "Name too long, up to 25 characters only";
    RegExp exp = RegExp(r"^[a-zA-Z0-9]+( [a-zA-Z0-9]+)*$");
    if (exp.hasMatch(name)) return null;
    return "Name can contain only alphanumeric characters and spaces";
  }
}
