import 'dart:async';
import 'dart:io';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/login_view/otp_veerification_screen/otp_view.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

import '../../data/models/models.dart';
import '../../utils.dart';
import '../otp_veerification_screen/otp_verification.dart';

enum LoginPageStatus { MOBILE_NUMBER, OTP_VERIFICATION, PROFILE_VERIFICATION }

class LogInViewController extends GetxController {
  dynamic countryCode = "+91";
  final currentStatus = LoginPageStatus.MOBILE_NUMBER.obs;
  RxBool loading = false.obs;

  TextEditingController mobNumController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final otpController = TextEditingController();

  TextEditingController box1 = TextEditingController();
  TextEditingController box2 = TextEditingController();
  TextEditingController box3 = TextEditingController();
  TextEditingController box4 = TextEditingController();
  TextEditingController box5 = TextEditingController();
  TextEditingController box6 = TextEditingController();

  var OTPtry = 0;

  final FocusNode _focusNode = FocusNode();

  Rx<String> mobNum = ''.obs;
  Rx<String> name = ''.obs;
  Rx<String> title = "Login".obs;
  Rx<String> subTitle = "We are excited to welcome you back".obs;

  RxBool isPostingNumber = false.obs;
  RxBool isVerifyingOtp = false.obs;
  RxBool isSigningUp = false.obs;
  RxBool hasVerifiedOtp = false.obs;
  RxBool showerror = false.obs;
  RxBool isProfileVerified = false.obs;

  Rx<String> mobNumError = ''.obs;
  Rx<String> otpError = ''.obs;
  Rx<String>? firstNameError;
  Rx<String>? lastNameError;

  RxBool profileExists = false.obs;
  AccessToken? accessToken;
  RxInt countdown = 30.obs;
  StreamController<int> countdownController = StreamController<int>.broadcast();
  Timer? timer;
  bool isCountdownStarted = false;
  RxBool isPrivacyPolicyChecked = false.obs;
  RxBool showFirstText = true.obs;
  RxBool showVideo = true.obs;

  Stack buildNameField(
      BuildContext context, String label, TextEditingController controller) {
    return Stack(alignment: Alignment.centerRight, children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
          child: TextField(
              toolbarOptions: const ToolbarOptions(
                  copy: false, paste: false, cut: false, selectAll: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                LengthLimitingTextInputFormatter(100)
              ],
              controller: controller,
              keyboardType: TextInputType.text,
              enabled: name.isEmpty,
              style: TextStyle(
                  color: name.isNotEmpty
                      ? Colors.white
                      : Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.4)),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 25),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(5)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.onBackground),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Theme.of(context).colorScheme.error),
                      borderRadius: BorderRadius.circular(5)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Theme.of(context).colorScheme.error),
                      borderRadius: BorderRadius.circular(5)),
                  labelStyle: TextStyle(color: name.isNotEmpty ? Colors.white : Theme.of(context).colorScheme.onPrimary.withOpacity(0.4)),
                  labelText: label,
                  helperText: ' ',
                  errorText: label == "FIRST NAME" ? firstNameError?.value : lastNameError?.value,
                  prefixText: "",
                  prefixStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7), fontSize: 16)))),
      Visibility(
          visible: name.isNotEmpty,
          child: const Padding(
              padding: EdgeInsets.only(right: 34),
              child: Align(alignment: Alignment.centerRight, child: Loader()))),
      Visibility(
          visible: !name.isNotEmpty,
          child: IconButton(
              padding: const EdgeInsets.only(right: 36),
              onPressed: editNumber,
              icon: const Icon(Icons.edit)))
    ]);
  }

  String getSubmitButtonLabel() {
    if (mobNum.isNotEmpty) {
      if (hasVerifiedOtp.value) {
        return "Proceed";
      } else if (isVerifyingOtp.value) {
        return 'Verifying';
      } else {
        return 'Verify';
      }
    } else {
      if (isPostingNumber.value) {
        return 'Submitting';
      } else {
        return 'Next';
      }
    }
  }

  void requestOtp(BuildContext context) async {
    try {
      loading.value = true;
      if (mobNumController.text.isNotEmpty) {
        final tempMobileNum = mobNumController.text;
        if (tempMobileNum.isEmpty) {
          mobNumError.value = "Please Enter Mobile Number";
        }
        if (tempMobileNum.isEmpty ||
            tempMobileNum.length != 10 ||
            !isPositiveNumber(tempMobileNum)) {
          return;
        }
      }
      otpController.clear();
      isPostingNumber.value = true;
      mobNumError.value = "";
      otpError.value = "";
      MobileNumber number = MobileNumber(
          countryCode: countryCode, number: mobNumController.text.trim());
      isProfileVerified.value = false;
      try {
        getIt<SensyApi>().requestCrmOtp(number).then((value) {
          loading.value = false;
          isPostingNumber.value = false;
          renderOtpField(context);
        });
      } catch (e) {
        loading.value = false;
        isPostingNumber.value = false;
        mobNumError.value = "Failed to submit, try again";
      }
    } catch (e) {
      print(e);
    }
  }

  clearAllFields() {
    otpController.clear();
    box1.clear();
    box2.clear();
    box3.clear();
    box4.clear();
    box5.clear();
    box6.clear();
  }

  void renderOtpField(BuildContext context) {
    clearAllFields();
    resetCountdown();
    Future.delayed(Duration.zero, () {
      showModalBottomSheet<void>(
          isScrollControlled: true,
          isDismissible: false,
          backgroundColor: const Color(0x490B0F47),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SafeArea(
                  child: SizedBox(
                      height: double.infinity,
                      child: VerifyOtpWidget(
                          isVerifyingOtp: otpError.value == "" ? true : false,
                          number: mobNumController.text,
                          countdownController: countdownController,
                          focusNode: _focusNode,
                          onOTPSubmitted: () => submit(context),
                          onRequestOtpResetCountdown: () {
                            clearAllFields();
                            resetCountdown();
                            resendOtp(context);
                          },
                          onVerifyOtp: (value) {
                            if (value.length >= 1 && value.length != 6) {
                              FocusScope.of(context).nextFocus();
                            }
                            if (value.length > 2) {
                              FocusScope.of(context).previousFocus();
                              box1.text = value[0];
                              box2.text = value[1];
                              box3.text = value[2];
                              box4.text = value[3];
                              box5.text = value[4];
                              box6.text = value[5];
                            }
                          })));
            });
          });
    });
    isPostingNumber.value = false;
  }

  void submit(BuildContext context) {
    if (box1.text != "" &&
        box2.text != "" &&
        box3.text != "" &&
        box4.text != "" &&
        box5.text != "" &&
        box6.text != "") {
      otpController.text =
          box1.text + box2.text + box3.text + box4.text + box5.text + box6.text;
      print('in submit method ${otpController.text}');
      verifyOtp(context);
    } else {
      if (box1.text != "" &&
          box2.text != "" &&
          box3.text != "" &&
          box4.text != "" &&
          box5.text != "") {
        otpController.text =
            box1.text + box2.text + box3.text + box4.text + box5.text;
        verifyOtp(context);
      }
    }
  }

  void resetCountdown() {
    countdown.value = 30;
    startCountDown();
  }

  void startCountDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value == 0) {
        timer.cancel();
      } else {
        countdown.value = countdown.value - 1;
      }
    });
  }

  void resendOtp(BuildContext context) async {
    final tempMobileNum = mobNumController.text;
    if (tempMobileNum.isEmpty ||
        tempMobileNum.length != 10 ||
        !isPositiveNumber(tempMobileNum)) {
      return;
    }
    isPostingNumber.value = true;
    mobNumError.value = "";
    otpError.value = "";
    otpController.text = "";
    box1.text = "";
    box2.text = "";
    box3.text = "";
    box4.text = "";
    box5.text = "";
    box6.text = "";
    FocusScope.of(context).requestFocus(_focusNode);
    MobileNumber number =
        MobileNumber(countryCode: countryCode, number: tempMobileNum);
    getIt<SensyApi>().requestCrmOtp(number).then((value) {
      isPostingNumber.value = false;
      isPostingNumber.value = false;
      mobNum.value = tempMobileNum;
    }).catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          isPostingNumber.value = false;
          mobNumError.value =
              "Failed to submit, try again: ${response?.statusCode}";
      }
    });
  }

  void verifyOtp(BuildContext context) async {
    final tempOtp = otpController.text;
    if (tempOtp.isEmpty || !isPositiveNumber(tempOtp)) {
      return;
    }

    showModalBottomSheet<void>(
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: const Color(0x490B0F47),
        context: context,
        builder: (BuildContext context) {
          return const SafeArea(
              child: SizedBox(
                  height: double.infinity, child: OtpVerificationWidget()));
        });

    isVerifyingOtp.value = true;
    otpError.value = "";

    MobileNumber number = MobileNumber(
        countryCode: countryCode,
        number: mobNum.value,
        name: name.value,
        otp: otpController.text);

    try {
      final accessToken = await getIt<SensyApi>().verifyCrmOtp(number);
      profileExists.value = accessToken.profilesExist;
      debugPrint("profileExists ${profileExists.toString()}");

      OTPtry++;
      String version = "";
      String platform = "";
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;

      if (Platform.isIOS) {
        platform = "iOS";
      } else if (Platform.isAndroid) {
        platform = "Android";
      }

      // Handle device-specific information (device model can be fetched here if needed)
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String deviceModel = 'Unknown';

      // Request location permissions and get location
      final hasPermission = await _handlePermission();
      if (hasPermission) {
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        Constants.lat = position.latitude.toString();
        Constants.long = position.longitude.toString();
        Constants.mobile = LoginPageStatus.MOBILE_NUMBER.obs.toString();
        debugPrint('Location: ${position.latitude}, ${position.longitude}');
      } else {
        // Handle the case where location permissions are not granted
        if (await Geolocator.isLocationServiceEnabled() == false) {
        } else if (await Geolocator.checkPermission() ==
            LocationPermission.deniedForever) {
          openAppSettings();
        } else {}
      }

      if (!accessToken.profilesExist) {
        currentStatus.value = LoginPageStatus.PROFILE_VERIFICATION;
      }
      hasVerifiedOtp.value = true;
      OTPtry = 0;
      Navigator.pop(context);
      Navigator.pop(context);
      if (profileExists.value) {
        await getIt<UserAccount>().loginUser(accessToken);
        debugPrint("login");
      } else {
        this.accessToken = accessToken;
      }
    } catch (errorObj) {
      if (errorObj is DioException) {
        final response = errorObj.response;
        if (kDebugMode) {
          print("Error code ${response?.statusCode}, ${response.toString()}");
        }

        if (response?.statusCode == 400 && !hasVerifiedOtp.value) {
          Fluttertoast.showToast(msg: "Invalid OTP");
          otpController.clear();
          box1.clear();
          box2.clear();
          box3.clear();
          box4.clear();
          box5.clear();
          box6.clear();
          Navigator.pop(context);
        }
        isVerifyingOtp.value = false;
        showerror.value = true;
        otpError.value =
            "Failed to verify OTP, try again. Status: ${response?.statusCode}";
      }
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  void signUp() {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;

    if (firstName.isEmpty || lastName.isEmpty) {
      firstNameError?.value = (firstName.isEmpty ? "Cannot be empty!" : null)!;
      lastNameError?.value = (lastName.isEmpty ? "Cannot be empty!" : null)!;
      return;
    }

    isSigningUp.value = true;
    lastNameError = null;
    firstNameError = null;

    getIt<UserAccount>().setAccessToken(accessToken!);
    getIt<SensyApi>()
        .nameCustomer(CustomerName(firstName: firstName, lastName: lastName))
        .then((_) {
      isSigningUp.value = false;
      getIt<UserAccount>().loginUser(accessToken!);
      debugPrint("signedUp successfully!!!!!!!!!");
    }).catchError((Object errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          if (kDebugMode) {
            print("Error code ${response?.statusCode}, ${response.toString()}");
            getIt<UserAccount>().loginUser(accessToken!);
          }
          isVerifyingOtp.value = false;
          otpError.value =
              "Failed to verify OTP, try again. Status: ${response?.statusCode}";
      }
    });
  }

  void editNumber() {
    mobNumError.value = "";
    mobNum.value = "";
    name.value = "";
    otpError.value = "";
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    otpController.dispose();
    countdownController.close();
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    super.dispose();
  }

  void updateOtp(String otpCode) {
    box1.text = otpCode[0];
    box2.text = otpCode[1];
    box3.text = otpCode[2];
    box4.text = otpCode[3];
    box5.text = otpCode[4];
    box6.text = otpCode[5];
    otpController.text = otpCode;
  }

  Future<String> getNetworkType() async {
    ConnectivityResult connectivityResult =
        (await Connectivity().checkConnectivity()) as ConnectivityResult;

    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        return 'Wi-Fi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.none:
        return 'No Network';
      default:
        return 'Unknown';
    }
  }

  void updateLoader(bool val) {
    loading.value = val;
    update();
  }
}
