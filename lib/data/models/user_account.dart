import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/data/models/user_interests.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../injection/injection.dart';
import '../../utils.dart';
import '../api/sensy_api.dart';
import 'languages.dart';


@lazySingleton
class UserAccount extends ChangeNotifier {
  final SharedPreferences _sharedPreferences;
  bool _initialized = false;
  String _clientToken = "";
  Customer? _customer;
  String _token = "";
  int _profileId = -1;
  String _profileName = "";
  bool _isPersonalized = false;
  bool _isRestricted = true;
  String _deviceFingerprint = "";
  String _deviceManufacturer = "";
  String _deviceModel = "";
  String _deviceProduct = "";
  final String _version = "";
  final String _buildNumber = "";
  String? _currentRoute;
  bool _isCompletedOnboarding = false;
  bool _isOnHome = false;

  bool isInitialized() => _initialized;

  String get clientToken => _clientToken;

  bool isLoggedIn() => _clientToken.isNotEmpty;

  Customer? get customer => _customer;

  String get phoneNumber => _customer?.phoneNumber ?? "";

  String get mobileNumber => _customer?.mobileNumber ?? "";

  List<Profile> get profiles => _customer?.profiles ?? [];

  int get profileId => _profileId;

  String get token => _token;

  bool isProfileLoaded() => isLoggedIn() && _profileId > 0 && _token.isNotEmpty;

  String get profileName => _profileName;

  setProfileName(String value) async {
    _profileName = value;
    _fetchCustomer();
    notifyListeners();
  }

  String? get currentRoute => _currentRoute;

  setCurrentRoute(String? value) {
    _currentRoute = value;
  }

  bool isPersonalized() => _isPersonalized;

  bool get isRestricted => _isRestricted;

  // bool isSubscribed() => (_customer?.activePlans ?? []).isNotEmpty;

  String get deviceFingerprint => _deviceFingerprint;

  String get deviceManufacturer => _deviceManufacturer;

  String get deviceModel => _deviceModel;

  String get deviceProduct => _deviceProduct;

  String get version => _version;

  String get buildNumber => _buildNumber;

  bool isCompletedOnboarding() {
    _isCompletedOnboarding = _sharedPreferences.getBool("isCompletedOnboarding") ?? false;
    return _isCompletedOnboarding;
  }

  bool isOnHome() {
    _isOnHome = _sharedPreferences.getBool("isHome") ?? false;
    return _isOnHome;
  }

  setIsCompletedOnboarding(bool value) async {
    _isCompletedOnboarding = await _sharedPreferences.setBool("isCompletedOnboarding", value);
    notifyListeners();
  }

  setOnHome(bool value) async {
    _isOnHome = await _sharedPreferences.setBool("isHome", value);
    notifyListeners();
  }

  UserAccount(this._sharedPreferences) {
    launch();
  }

  void launch() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      final deviceData = await deviceInfo.webBrowserInfo;
      _deviceModel = deviceData.browserName.name;
    } else if (Platform.isAndroid) {
      final deviceData = await deviceInfo.androidInfo;
      _deviceFingerprint = deviceData.fingerprint;
      _deviceManufacturer = deviceData.manufacturer;
      _deviceModel = deviceData.model;
      _deviceProduct = deviceData.product;
    } else if (Platform.isIOS) {
      final deviceData = await deviceInfo.iosInfo;
      //_deviceFingerprint = deviceData.fingerprint ?? "";
      _deviceManufacturer = "Apple";
      _deviceModel = deviceData.model ?? "";
      //_deviceProduct = deviceData.product ?? "";
    }

   // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // _version = packageInfo.version;
   // _buildNumber = packageInfo.buildNumber;

    _clientToken = _sharedPreferences.getString("client_token") ?? "";
    try {
      _profileId = _sharedPreferences.getInt("profile_id") ?? -1;
    } on TypeError catch (e) {
      // Migration to integer type for profile_id
      final profIdString = _sharedPreferences.getString("profile_id") ?? "";
      await _sharedPreferences.remove("profile_id");
      if (profIdString.isNotEmpty) {
        final profId = int.tryParse(profIdString);
        if (profId != null) {
          _profileId = profId;
          await _sharedPreferences.setInt("profile_id", profId);
        }
      }
      if (kDebugMode) {
        print(e);
      }
    }

    if (isLoggedIn()) {
      _fetchCustomer()
          .then((_) => setProfile(_profileId, notify: false))
          .catchError((Object errorObj) {
        switch (errorObj.runtimeType) {
          case DioException:
            final response = (errorObj as DioException).response;
            showVanillaToast("Failed to fetch your details, "
                "try logging in again: ${response?.statusCode}");
            logout();
        }
      }).whenComplete(() {
        _initialized = true;
        notifyListeners();
      });
    } else {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> _fetchCustomer() {
    return getIt<SensyApi>().fetchCustomer().then((customer) {
      _customer = customer;
    });
  }

  fetchCustomer() {
    print("fetch customer");
    return getIt<SensyApi>().fetchCustomer().then((customer) {
      _customer = customer;
    });
  }

  void setAccessToken(AccessToken accessToken){
    _clientToken = accessToken.toString();
  }

  Future<void> loginUser(AccessToken accessToken) async {
    _clientToken = accessToken.toString();
    await _sharedPreferences.setString("client_token", _clientToken);
    await _sharedPreferences.setString("qr_url", accessToken.qrUrl);
    if (kDebugMode) {
      print("Profiles exist: ${accessToken.profilesExist}");
    }
    return _fetchCustomer().then((_) {
      notifyListeners();
    }).catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print("Please log in again: ${response?.statusCode}");
          logout();
      }
    });
  }

  Future<void> createProfile(String name) {
    return getIt<SensyApi>().createProfile(name).then(_setNewProfile);
  }

  Future<void> _setNewProfile(Profile profile) {
    return _fetchCustomer()
        .then((_) => _clearLanguages())
        .then((_) => _clearInterests())
        .then((_) => setProfile(profile.id))
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print("Please log in again: ${response?.statusCode}");
          logout();
      }
    });
  }

  Future<void> setProfile(int profileId, {bool notify = true}) {
    return _setProfile(profileId).then((_) {
      if (notify) notifyListeners();
    }).catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case CustomerException:
          final message = (errorObj as CustomerException).message;
          if (message.isNotEmpty) {
            showVanillaToast(message);
          }
          logout();
          break;
        case ProfileException:
          final message = (errorObj as ProfileException).message;
          if (message.isNotEmpty) {
            showVanillaToast(message);
          }
          switchOutOfProfile();
      }
    });
  }

  Future<void> _setProfile(int profileId) async {
    final tempCustomer = _customer;
    if (tempCustomer == null) {
      if (kDebugMode) {
        print("_customer was null");
      }
      return Future.error(const CustomerException(
          "Failed to fetch your details, try logging in again"));
    }

    Profile? profile;
    for (final tempProfile in tempCustomer.profiles) {
      if (tempProfile.id == profileId) {
        profile = tempProfile;
        break;
      }
    }

    if (profile == null) {
      return Future.error(const ProfileException(""));
    }

    if (profile.token.isEmpty) {
      return Future.error(const ProfileException(
          "Your profile encountered an error, select another"));
    }

    if (!kIsWeb) {
      FirebaseCrashlytics.instance.setUserIdentifier(profileId.toString());
    }

    _profileId = profile.id;
    await _sharedPreferences.setInt("profile_id", _profileId);
    _token = profile.token;
    _profileName = profile.name;
    _isPersonalized = profile.isPersonalized;
    _isRestricted = profile.isRestricted;

    return getIt<SensyApi>()
        .fetchClientToken()
        .then(_setProfileClientToken)
        .then((_) => _loadLanguages())
        .then((_) => _loadInterests())
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast("Could not switch to profile, "
              "try switching again: ${response?.statusCode}");
          break;
        default:
          if (kDebugMode) {
            print("Non DioException during switchProfile: $errorObj");
          }
          showVanillaToast("Could not switch to profile, try switching again");
      }
      return switchOutOfProfile();
    });
  }

  Future<void> _setProfileClientToken(ClientToken clientToken) async {
    _clientToken = clientToken.clientToken;
    await _sharedPreferences.setString("client_token", clientToken.clientToken);
  }

  Future<void> _loadLanguages() {
    return getIt<FavoriteLanguagesChangeNotifier>().setupLanguages(
      rethrowErrors: true,
    );
  }
  Future<void> setToken() async{
    return  getIt<SensyApi>()
        .fetchClientToken()
        .then(_setProfileClientToken);
  }

  Future<void> _loadInterests() {
    return getIt<UserInterestsChangeNotifier>()
        .setupInterests(notifyChanges: false);
  }

  // Future<void> checkActiveSubscription() {
  //   return getIt<SensyApi>().fetchCustomer().then((customer) {
  //     if (!listEquals(customer.activePlans, _customer?.activePlans)) {
  //       _customer = customer;
  //       notifyListeners();
  //     }
  //   });
  // }

  // Future<bool> checkForSubscription() {
  //   // if (isSubscribed()) return Future.value(true);
  //   // return _fetchCustomer().then((_) {
  //   //   if (isSubscribed()) {
  //   //     notifyListeners();
  //   //     return Future.value(true);
  //   //   }
  //     return Future.value(false);
  //   }).catchError((_) {
  //     return Future.value(false);
  //   });
  // }

  Future<void> setProfilePersonalized(bool personalized) {
    return getIt<SensyApi>()
        .setProfilePersonalized(_profileId.toString(), personalized)
        .then((_) => _fetchCustomer())
        .then((_) => setProfile(_profileId))
        .catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          print("Please log in again: ${response?.statusCode}");
          logout();
      }
    });
  }

  _clearLanguages() {
    getIt<FavoriteLanguagesChangeNotifier>()
        .clearFavoriteLanguages(notify: false);
  }

  _clearInterests() {
    getIt<UserInterestsChangeNotifier>().clearInterests(notify: false);
  }

  Future<void> switchOutOfProfile({bool notify = true}) async {
    _clearInterests();
    _clearLanguages();

    _profileId = -1;
    await _sharedPreferences.remove("profile_id");
    _token = "";
    _profileName = "";
    _isPersonalized = false;
    _isRestricted = true;

    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.setUserIdentifier("");
    }

    if (notify) notifyListeners();
  }

  Future<void> deleteProfile(int profileId) {
    return getIt<SensyApi>().deleteProfile(profileId.toString()).then((_) {
      return _fetchCustomer().then((_) {

        if (this.profileId == profileId) {
          return switchOutOfProfile();
        }

        notifyListeners();
      });
    }).catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          if (kDebugMode) {
            print("Please log in again: ${response?.statusCode}");
          }
          logout();
      }
    });
  }

  Future<void> logout() async {
    await switchOutOfProfile(notify: false);
    _customer = null;
    _clientToken = "";
    await _sharedPreferences.remove("client_token");
    notifyListeners();
  }

  notify() {
    // Wrap nofifyListeners() as it is annotated as protected
    notifyListeners();
  }

  @override
  String toString() {
    return "MobileNumber: $phoneNumber"
        " UserAccount. Token: $_token"
        " ClientToken: $_clientToken"
        " ProfileID: $_profileId"
        " ProfileName: $_profileName"
        " isRestricted: $_isRestricted";
  }
}

class CustomerException implements Exception {
  final String message;

  const CustomerException(this.message);

  @override
  String toString() {
    return "CustomerException: $message";
  }
}

class ProfileException implements Exception {
  final String message;

  const ProfileException(this.message);

  @override
  String toString() {
    return "ProfileException: $message";
  }
}
