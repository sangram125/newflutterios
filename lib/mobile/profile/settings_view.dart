import 'package:dio/dio.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/profile/Widget/manage_devices.dart';
import 'package:dor_companion/mobile/profile/Widget/switch_button.dart';
import 'package:dor_companion/utils.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../widgets/appbar.dart';
import 'controller/profile_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
          child: GradientBackground(
              child: SettingsBody())),
    );
  }
}

class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  final profileCtrl = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              //eventCall.myRemoteEvent('profile_screen');
              getIt<SensyApi>().fetchTvDevices().then((devices) {
                if (devices.isEmpty) {
                  showVanillaToast("No paired devices");
                  return;
                }
                List<TvDevice> tvDevices = devices;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageDevices(
                              tvDevices: tvDevices,
                            )));
                // context.push("/remote/$deviceId");
              }).catchError((errorObj, stackTrace) {
                switch (errorObj.runtimeType) {
                  case DioException:
                    final response = (errorObj as DioException).response;
                    showVanillaToast(
                        "Failed to retrieve devices: ${response?.statusCode}");
                    break;
                  default:
                    if (kDebugMode) {
                      print(
                          "Non DioException during fetchTvDevices: $errorObj");
                    }
                    showVanillaToast("Failed to retrieve devices");
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.white.withOpacity(0.10000000149011612),
                  ),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/manage_device.svg',
                    // Adjust the height as needed
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        "Manage Devices",
                        style: AppTypography.settingsViewTitle,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.white.withOpacity(0.10000000149011612),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/images/profile_images/settings_new.svg',
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Parental Controls",
                              style: AppTypography.settingsViewTitle,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Restrict 18+ content",
                              style: AppTypography.settingViewSubTitle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => SwitchButton(
                    switchValue: profileCtrl.parentalControl.value,
                    onTap: () {
                      profileCtrl.parentalControl.value =
                          !profileCtrl.parentalControl.value;
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
