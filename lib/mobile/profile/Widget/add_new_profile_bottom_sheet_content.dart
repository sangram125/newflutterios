import 'package:dor_companion/assets.dart';
import 'package:dor_companion/mobile/profile/controller/profile_controller.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddNewProfileBottomSheetContent extends StatefulWidget {
  const AddNewProfileBottomSheetContent({super.key});

  @override
  State<AddNewProfileBottomSheetContent> createState() => _AddNewProfileBottomSheetContentState();
}

class _AddNewProfileBottomSheetContentState extends State<AddNewProfileBottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    final profileCtrl = Get.put(ProfileController());
    bool enableSaveButton = false;
    return StatefulBuilder(builder: (context, setState) {
      return Stack(children: [
        Container(
            width: double.infinity,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const ShapeDecoration(
                color: Color(0xFF171717),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)))),
            child: Column(children: [
              Container(
                  width: 55,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 24),
                  decoration: ShapeDecoration(
                      color: const Color(0xFF4D4D4D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.white),
                    const Text('Add profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontFamily: 'DMSerifDisplay',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.20)),
                    TextButton(
                        onPressed: () async {
                          if (enableSaveButton) {
                            await profileCtrl.createProfile();
                            // if (context.mounted) {
                            //   Navigator.pop(context);
                            // }
                          }
                        },
                        child: Text('Save',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: enableSaveButton ? const Color(0xFF7399F4) : const Color(0xFF808080),
                                fontSize: 14,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.20)))
                  ]),
              const SizedBox(height: 40),
              SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(Assets.assets_images_profile_images_avatar_7_png)),
              const SizedBox(height: 24),
              TextFormField(
                  controller: profileCtrl.nameController,
                  autofocus: true,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.20),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      enableSaveButton = true;
                    } else {
                      enableSaveButton = false;
                    }
                    setState(() {});
                  },
                  inputFormatters: [NoLeadingSpaceFormatter()],
                  decoration: const InputDecoration(
                      label: Text('Profile name',
                          style: TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 12,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF666666)),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF666666)),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF666666)),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      contentPadding: EdgeInsets.only(left: 24)))
            ])),
        Obx(() => profileCtrl.isLoading.value
            ? Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black12,
                child: const Center(child: Loader()))
            : const SizedBox.shrink())
      ]);
    });
  }
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith(' ')) {
      return oldValue;
    }
    return newValue;
  }
}
