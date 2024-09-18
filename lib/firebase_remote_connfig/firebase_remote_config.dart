import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class FirebaseRemoteConfigKeys {
  static const String watchNowPeople = 'watch_now_people';
  static const String aboutThreeSixty = 'about_three_sixty';
  static const String selectProfileImage = 'profile_image_urls';

}

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService._()
      : _remoteConfig = FirebaseRemoteConfig.instance;

  static FirebaseRemoteConfigService? _instance;

  factory FirebaseRemoteConfigService() =>
      _instance ??= FirebaseRemoteConfigService._();

  final FirebaseRemoteConfig _remoteConfig;

  Future<void> initialize() async {
    try {
      await _remoteConfig.ensureInitialized();
      await _remoteConfig.fetchAndActivate();
    } catch (exception) {
      if (kDebugMode) {
        print('Error fetching remote config: $exception');
      }
    }
  }

  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  String getWatchNowPeople() {
    return getString(FirebaseRemoteConfigKeys.watchNowPeople);
  }

  String getAboutThreeSixty(){
    return getString(FirebaseRemoteConfigKeys.aboutThreeSixty);
  }
  List<String> getProfileImageUrls() {
    final jsonStr = getString(FirebaseRemoteConfigKeys.selectProfileImage);
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    final List<dynamic> images = json['images'];
    return List<String>.from(images);
  }

}



class ImageURLs {
  final List<String> images;

  ImageURLs({required this.images});

  factory ImageURLs.fromJson(Map<String, dynamic> json) {
    return ImageURLs(
      images: List<String>.from(json['images']),
    );
  }
}
