import 'package:dio/dio.dart';
import 'package:dor_companion/utils.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/appbar.dart';
import 'controller/notification_controller.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final notifiCtrl = Get.put(NotiifationController());
  // notification.NotificationModel notificationModel =
  //     notification.NotificationModel();
  // Customer? _customer;
//  bool isLoading = false;
  final List<Map<String, dynamic>> dummyData = [
    {
      'image': 'https://via.placeholder.com/150',
      'name': 'Item 1',
      'description': 'Description for Item 1',
    },
    {
      'image': 'https://via.placeholder.com/150',
      'name': 'Item 2',
      'description': 'Description for Item 2',
    },
    {
      'image': 'https://via.placeholder.com/150',
      'name': 'Item 3',
      'description': 'Description for Item 3',
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    notifiCtrl.fetchCustomer().then((value) {
      notifiCtrl
          .fetchNotifications(notifiCtrl.customer.value!.sms_contact_id,
              notifiCtrl.customer.value!.sms_access_token)
          .catchError((errorObj) {
        switch (errorObj.runtimeType) {
          case DioException:
            final response = (errorObj as DioException).response;
            showVanillaToast(
                "Failed to fetch notifications: ${response?.statusCode}");
            break;
          default:
            if (kDebugMode) {
              print(
                  "Encountered unknown error of type ${errorObj.runtimeType}");
            }
        }
        // setState(() {
        notifiCtrl.isLoading.value = false;
        // });
      });
    }).catchError((errorObj) {
      switch (errorObj.runtimeType) {
        case DioException:
          final response = (errorObj as DioException).response;
          showVanillaToast(
              "Failed to fetch notifications : ${response?.statusCode}");
          break;
        default:
          if (kDebugMode) {
            print("Encountered unknown error of type ${errorObj.runtimeType}");
          }
      }
      // setState(() {
      notifiCtrl.isLoading.value = false;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: Obx(() => !notifiCtrl.isLoading.value
            ? const Center(child: Loader())
            : ListView.builder(
                itemCount: notifiCtrl.notificationModel.content!.length,
                itemBuilder: (context, index) {
                  //  final item = dummyData[index];
                  return Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        "assets/images/login_images/frame_logo.png", // Bottom image
                        fit: BoxFit.cover,
                      ),
                      title: Text(notifiCtrl
                          .notificationModel.content![index].subject!),
                      subtitle: Text(notifiCtrl
                          .notificationModel.content![index].subtitle!),
                    ),
                  );
                },
              )));
  }
}
