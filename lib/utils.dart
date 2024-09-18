import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  cancel() {
    _timer?.cancel();
  }
}

showVannillaToast(BuildContext context, String msg) {
  Color color = Theme.of(context).highlightColor;

  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      fontSize: 16.0);
}

showVanillaToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
}

bool isPositiveNumber(String? s) {
  if (s == null || s.isEmpty) {
    return false;
  }
  final val = double.tryParse(s);
  return val != null && val > 0;
}

class ConnectivityService extends GetxService {
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      debugPrint('result ---- $result');
      isOnline.value = result.first != ConnectivityResult.none;
    });
  }
}
