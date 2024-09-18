import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

String? devicesID;

class DistroApiProvider {
  Future<Map<String, dynamic>> trackingPixel({required String eventName, String durl = ''}) async {
    String randomNumber = DateTime.now().millisecondsSinceEpoch.toString();
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    devicesID = Platform.isAndroid ? deviceInfo.data['id'] : deviceInfo.data['utsname'];
    String seasonsID = '442';
    String actionID = durl;
    actionID = actionID.contains("__APP_BUNDLE__")
        ? actionID.replaceAll("__APP_BUNDLE__", Uri.encodeComponent("tv.dorplay.companion"))
        : actionID;
    actionID = actionID.contains("__DEVICE_ID__")
        ? actionID.replaceAll("__DEVICE_ID__", Uri.encodeComponent(devicesID ?? ''))
        : actionID;
    actionID = actionID.contains("__APP_CATEGORY__")
        ? actionID.replaceAll("__APP_CATEGORY__", Uri.encodeComponent("entertainment"))
        : actionID;
    actionID = actionID.contains("__APP_DOMAIN__")
        ? actionID.replaceAll("__APP_DOMAIN__", Uri.encodeComponent("https://dorplay.tv/"))
        : actionID;
    actionID = actionID.contains("__STORE_URL__")
        ? actionID.replaceAll("__STORE_URL__",
            Uri.encodeComponent("https://play.google.com/store/apps/details?id=tv.dorplay.companion"))
        : actionID;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    actionID = actionID.contains("__APP_VERSION__")
        ? actionID.replaceAll("__APP_VERSION__", Uri.encodeComponent(packageInfo.version))
        : actionID;
    actionID = actionID.contains("__CACHE_BUSTER__")
        ? actionID.replaceAll("__CACHE_BUSTER__", Uri.encodeComponent(randomNumber))
        : actionID;

    /// Initialize Ip Address
    var ipAddress = IpAddress(type: RequestType.json);

    /// Get the IpAddress based on requestType.
    dynamic data = await ipAddress.getIpAddress();

    actionID = actionID.contains("__CLIENT_IP__")
        ? actionID.replaceAll("__CLIENT_IP__", Uri.encodeComponent(data['ip'].toString()))
        : actionID;

    // actionID = actionID.contains("__USER_AGENT__") ?actionID.replaceAll("__USER_AGENT__", Uri.encodeComponent(deviceInfo.data['model'].toString() + "/" + (Platform.isAndroid ? "Android ":"iOS ") + deviceInfo.data['version']['release'].toString())):'';
    actionID = actionID.contains("__LIMIT_AD_TRACKING__")
        ? actionID.replaceAll("__LIMIT_AD_TRACKING__", Uri.encodeComponent("0"))
        : actionID;

    actionID = Uri.encodeComponent(actionID);
    String daiAssetKey = actionID;
    // String daiAssetKey = '0Zhrslv7S0qgwRWRV3ZV8g';
    String appName = 'dorplay';
    String contentProvider = '22697';
    String showsID = '417';
    String episodesID = '11065';
    String guid = generateRandomGuid();

    String url = "https://i.jsrdn.com/i/1.gif?"
        "dpname=dorplay"
        "&r=$randomNumber"

        /// A random number
        "&e=$eventName"

        /// vplay, ff, vs1, vs2, etc.
        "&u=$devicesID"

        /// Device specific ID
        "&i=$guid"

        /// dai_session_id
        "&v=$guid"

        /// dai_asset_key
        "&f=$daiAssetKey"
        "&m=$appName"

        /// App Name
        "&p=$contentProvider"

        /// The "content_provider" value from the feed
        "&show=$showsID"

        ///The show’s "id" element from the feed
        "&ep=$episodesID";

    if (eventName == 'vplay') {
      String url = "https://i.jsrdn.com/i/1.gif?"
          "dpname=dorplay"
          "&r=$randomNumber"

          /// A random number
          "&e=$eventName"

          /// vplay, ff, vs1, vs2, etc.
          "&u=$devicesID"

          /// Device specific ID
          "&i=$guid"

          /// dai_session_id
          "&v=$guid"

          /// dai_asset_key
          "&f=$actionID"
          "&m=$appName"

          /// App Name
          "&p=$contentProvider"

          /// The "content_provider" value from the feed
          "&show=$showsID"

          ///The show’s "id" element from the feed
          "&ep=$episodesID";
      commonProvider(url: url);

      /// The episode’s "id" element from the feed
    } else {
      url = "https://i.jsrdn.com/i/1.gif?"
          "dpname=dorplay"
          "&r=$randomNumber"
          "&e=$eventName"
          "&u=$devicesID"
          "&i=$eventName"
          "&v=$eventName"
          "&f=$daiAssetKey"
          "&m=$appName"
          "&p="
          "&show="
          "&ep=";
      commonProvider(url: url);

      /// The episode’s "id" element from the feed
    }

    return <String, dynamic>{
      'devicesID': devicesID,
      'seasonsID': seasonsID,
      'daiAssetKey': durl,
      'appName': appName,
      'contentProvider': contentProvider,
      'showsID': showsID,
      'episodesID': episodesID,
      'guid': guid,
    };
  }

  Future<dynamic> commonProvider({
    required String url,
    name,
  }) async {
    final hasInternet = await checkInternet();
    if (hasInternet == true) {
      try {
        print('----------Distro_url----------------');
        print(url);
        print('----------Distro_url----------------');
        final response = await http.get(
          Uri.parse(url),
        );
        if (response.statusCode == 200) {
          log(response.statusCode.toString(), name: name);
          log(response.body, name: name);
          return json.decode(response.body);
        } else if (response.statusCode == 101 || response.statusCode == 102) {
          // Show Error
          CustomSnackBar.showCustomSnackbar(
              toastType: ToastType.error, message: 'Something Went Wrong Please Try Again!!');
          return null;
        } else if (response.statusCode == 401) {
          // BlockUserByAdmin().blocked();
          return null;
        } else if (response.statusCode == 404) {
          //for if there is no data found or something went wrong
          CustomSnackBar.showCustomSnackbar(
              toastType: ToastType.error, message: 'Something Went Wrong Please Try Again!!');
          return null;
        } else {
          return json.decode(response.body);
        }
      } on SocketException catch (e) {
        CustomSnackBar.showCustomSnackbar(
            toastType: ToastType.error, message: 'Something Went Wrong Please Try Again!!');
        throw Exception('Internet Not Connected');
      } on FormatException catch (e) {
        throw Exception('Bad response format');
      } catch (exception) {
        return null;
      }
    } else {
      CustomSnackBar.showCustomSnackbar(
          toastType: ToastType.error, message: 'Something Went Wrong Please Try Again!!');
      return null;
    }
  }

  String generateRandomGuid() {
    final rand = math.Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    // Set version to 4
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    // Set variant to 10
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  Future<bool?> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      } else {
        print('else of connected');
      }
    } on SocketException catch (e) {
      print('not connected');
      return false;
    }
    return null;
  }
}

enum ToastType { error, warning, success, info }

class CustomSnackBar {
  static void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static void showCustomSnackbar(
      {required ToastType? toastType,
      String? title,
      required String message,
      Widget? messageText,
      Duration duration = const Duration(seconds: 2),
      Color? backgroundColor,
      Color? textColor = Colors.black}) {
    print('error----------------------------------------');
    print(message);
    print('error----------------------------------------');
  }
}
