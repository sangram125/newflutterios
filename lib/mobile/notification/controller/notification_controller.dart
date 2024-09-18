import 'dart:developer';
import 'package:dor_companion/data/models/NotificationModel.dart'
    as notification;
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../data/api/sensy_api.dart';
import '../../../data/models/models.dart';
import '../../../injection/injection.dart';

class NotiifationController extends GetxController {
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

  RxBool isLoading = false.obs;
  notification.NotificationModel notificationModel =
      notification.NotificationModel();
  final Dio _dio = Dio();
  Future<void> fetchCustomer() {
    return getIt<SensyApi>().fetchCustomer().then((customert) {
      customer.value = customert;
    });
  }

  Future fetchNotifications(String customerid, String customerToken) async {
    print("cusid $customerid");
    log("custokne $customerToken");
    isLoading.value = false;
    final response = await _dio.get(
        options: Options(headers: {"Authorization": "Bearer $customerToken"}),
        "https://sandbox.crm.com/self-service/v2/contacts/$customerid/communications");

    print("object ${response.data}");
    if (response.statusCode == 200) {
      isLoading.value = true;
      notificationModel =
          notification.NotificationModel.fromJson(response.data);
      print("response model $notificationModel");
      // setState(() {});
    } else {
      isLoading.value = false;
    }
  }
}
