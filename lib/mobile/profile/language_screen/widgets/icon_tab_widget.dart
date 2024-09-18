import 'package:dor_companion/mobile/profile/language_screen/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TabIconCommon extends StatelessWidget {
  final int index;
  final String iconPath;
  final Function() onTap;
  final GetxController? tanController;
  final String? tabName;

  TabIconCommon(
      {required this.index,
      required this.iconPath,
      required this.onTap,
      super.key, this.tanController, this.tabName});
  LanguageController controller = Get.put(LanguageController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          onTap();
          // controller.selectedIndex.value = index;
          // controller.currentStep.value = index; // Update current step
        },
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: SvgPicture.asset(
                iconPath, // Top image
                fit: BoxFit.fill,
                color: controller.selectedIndex.value == index ||
                        controller.completionStatus[index]
                    ? Colors.white
                    : Colors.grey,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(height: 8,),
            if(tabName!=null)...[
              Text(
                tabName!,
                style: TextStyle(
                  color: controller.completionStatus[index]? const Color(0xFFC7C7C7):
                  const Color(0xFF757575),
                  fontSize: 8,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
