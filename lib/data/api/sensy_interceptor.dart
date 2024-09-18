import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/login_view/mobile_number_verify/login_view_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getx;
import 'package:injectable/injectable.dart';

import '../models/languages.dart';
import '../models/user_account.dart';

@injectable
class SensyInterceptor extends Interceptor {
  final UserAccount userAccount;

  SensyInterceptor(this.userAccount);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (kDebugMode) {
      print("${DateTime.now()} Request to path ${options.path}");
    }

    // Base headers
    options.headers["accept"] = "application/json";

    // Auth data
    options.headers["x-api-key"] = "api-key-8451df3c-axb7-4034";
    options.headers["Authorization"] = "Token ${userAccount.token}";
    options.headers["X-Client-Token"] = userAccount.clientToken;

    // Device data
    options.headers["X-Device-Fingerprint"] = userAccount.deviceFingerprint;
    options.headers["X-Device-Manufacturer"] = userAccount.deviceManufacturer;
    options.headers["X-Device-Model"] = userAccount.deviceModel;
    options.headers["X-Device-Product"] = userAccount.deviceProduct;

    // App data
    options.headers["X-App-Version-Name"] = "1.0.43";
    options.headers["X-App-Version-Code"] = "46";

    if (options.path.contains("/detail/page/home")) {
      options.queryParameters.putIfAbsent(
          "languages",
          () =>
              getIt<FavoriteLanguagesChangeNotifier>().getFavoriteLanguages());
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print("${DateTime.now()} Response from ${response.requestOptions.path}");
      print("${DateTime.now()} Response from ${response.data}");
    }
    return handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("Handler : $handler");
    if (err.response?.statusCode == 401) {
      getx.Get.find<LogInViewController>().updateLoader(false);
      var res = err.response;
      // Handle 401 error here
      if (err.response?.statusCode == 401 &&
          err.requestOptions.path.contains(ApiEndpoints.requestCrmOtp)) {
        Fluttertoast.showToast(
          msg: "Please activate your DOR TV",
          toastLength: Toast.LENGTH_LONG, // Show toast for 5 seconds
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

// Re-show the toast after 5 seconds (Toast.LENGTH_LONG default duration)
        Timer(Duration(seconds: 5), () {
          Fluttertoast.showToast(
            msg: "Please activate your DOR TV",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        });
      }
      if (kDebugMode) {}

      // Perform actions like refreshing the token or redirecting to login
      // Example: Redirect to login or show an error message
      // Note: Actual implementation depends on your app's architecture
    }

    // Forward the error to the next handler
    return handler.next(err);
  }
}
