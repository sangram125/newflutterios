import 'dart:async';

import 'package:dor_companion/app_router.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum LoginStatus { mobileNumber, otp, loading }

class LoginVm extends ChangeNotifier {
  final mobileNumberController = TextEditingController();
  final otpController = TextEditingController();
  bool agreeToTerms = false;
  var otpTry = 0;

  LoginStatus currentStatus = LoginStatus.mobileNumber;

  bool _enableButton = false;

  bool get enableButton => _enableButton;

  bool _countDownRunning = true;

  bool get countDownRunning => _countDownRunning;

  int _countDownValue = 30;

  get countDownValue => _countDownValue;

  Timer? _timer;

  void setCountDownRunning(bool value) {
    _countDownRunning = value;
    notifyListeners();
  }

  void startTimer() {
    _countDownValue = 30;
    setCountDownRunning(true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countDownValue == 0) {
        setCountDownRunning(false);
        timer.cancel();
      } else {
        _countDownValue--;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void setAgreeToTerms(bool value) {
    agreeToTerms = value;
    if (mobileNumberController.text.length == 10 && agreeToTerms) {
      _enableButton = true;
    } else {
      _enableButton = false;
    }
    notifyListeners();
  }

  void onChangeMobileNumber(String value) {
    mobileNumberController.text = value;
    if (value.isNotEmpty && value.length == 10 && agreeToTerms) {
      _enableButton = true;
    } else {
      _enableButton = false;
    }
    notifyListeners();
  }

  void updateLoginStatus(LoginStatus status) {
    currentStatus = status;
    if (status == LoginStatus.otp) {
      startTimer();
    }
    notifyListeners();
  }

  void otpRequest() {
    try {
      getIt<SensyApi>()
          .requestCrmOtp(MobileNumber(countryCode: '+91', number: mobileNumberController.text))
          .then((value) {
        currentStatus = LoginStatus.otp;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void submitOtp() {
    try {
      currentStatus = LoginStatus.loading;
      notifyListeners();
      MobileNumber number = MobileNumber(
          countryCode: '+91', number: mobileNumberController.text, name: '', otp: otpController.text);
      getIt<SensyApi>().verifyOtp(number).then((accessToken) async {
        otpTry++;

        // Request location permissions and get location
        final hasPermission = await _handlePermission();
        if (hasPermission) {
          final position = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
          Constants.lat = position.latitude.toString();
          Constants.long = position.longitude.toString();
          Constants.mobile = mobileNumberController.text.toString();
          debugPrint('Location: ${position.latitude}, ${position.longitude}');
        } else {
          if (await Geolocator.isLocationServiceEnabled() == false) {
          } else if (await Geolocator.checkPermission() == LocationPermission.deniedForever) {
            openAppSettings();
          } else {}
        }
        otpTry = 0;
        Navigator.pop(getIt<AppRouter>().routerDelegate.navigatorKey.currentContext!);
        if (accessToken.profilesExist) {
          await getIt<UserAccount>().loginUser(accessToken);
        } else {
          /// profile not exist
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      currentStatus = LoginStatus.otp;
      notifyListeners();
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
}
