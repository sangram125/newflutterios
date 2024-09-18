import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/profile/language_screen/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'raise_a_ticket_controller.dart';
import 'widgets/drop_down_list_widget.dart';
import 'widgets/raise_ticket_button.dart';
import 'widgets/rich_text_widget.dart';

class RaiseTicketStep1Screen extends StatelessWidget {
  final RaiseATicketController controller = Get.put(RaiseATicketController());

  RaiseTicketStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(0.99, 0.15),
                          end: const Alignment(-0.99, -0.15),
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFF1C1F44)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'dor TV 55’ 2024',
                                style: TextStyle(
                                  color: Color(0xFFE2E2E2),
                                  fontSize: 11,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              const Text('OS Version 11.1',
                                  style: TextStyle(
                                    color: Color(0xFF8F8F8F),
                                    fontSize: 10,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  )),
                              const SizedBox(height: 22),
                              const RichTextWidget(
                                label: 'Plan',
                                value: '6999/- INR Combo 2',
                              ),
                              RichTextWidget(
                                label: 'Phone no',
                                value: getIt<UserAccount>()
                                    .customer!
                                    .phoneNumber
                                    .toString(),
                              ),
                              const RichTextWidget(
                                label: 'Serial number',
                                value: '9923847238273',
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Expanded(
                          //   child: Image.asset(
                          //       "assets/images/profile_images/tv_image.png",
                          //     width: 139,
                          //     height: 96,
                          //   fit: BoxFit.fill,),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Choose a category you need help with',
                      style: TextStyle(
                        color: Color(0xFFE2E2E2),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      return DropdownListPage(
                        categories: controller.categories.value,
                        selectedCategory:
                            controller.selectedCategory.value.isEmpty
                                ? null
                                : controller.selectedCategory.value,
                        onCategoryChanged: (newValue) {
                          controller.selectedType.value = '';
                          controller.selectedItem.value = '';
                          controller.selectedCategory.value = newValue!;
                          controller.fetchTypeApi(filter: newValue);
                        },
                        categoryName: 'Select a category',
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() {
                      return DropdownListPage(
                        categories: controller.ticketType.value,
                        selectedCategory: controller.selectedType.value.isEmpty
                            ? null
                            : controller.selectedType.value,
                        onCategoryChanged: (newValue) {
                          controller.selectedItem.value = '';
                          controller.selectedType.value = newValue!;
                          controller.fetchItemApi(filter: newValue);
                        },
                        categoryName: 'Select Type',
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() {
                      return DropdownListPage(
                        categories: controller.ticketItem.value,
                        selectedCategory: controller.selectedItem.value.isEmpty
                            ? null
                            : controller.selectedItem.value,
                        onCategoryChanged: (newValue) {
                          controller.selectedItem.value = newValue!;
                          controller.getSameIssue();
                          controller.getWikiArticles();
                        },
                        categoryName: 'Select Item',
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaiseTicketButton(
              onPressed: () {
                if (controller.selectedCategory.value.isEmpty &&
                    controller.selectedType.value.isEmpty &&
                    controller.selectedItem.value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Color(0xFF0E1466),
                    content: Text(
                      "Please select the issue you need help with",
                      style: TextStyle(color: Colors.white),
                    ),
                  ));
                } else {
                  nextScreenButton(true, context);
                }
              },
              text: 'Next',
            ),
          ),
        ),
      ],
    );
  }

  nextScreenButton(bool saved, BuildContext context) {
    LanguageController languageController = Get.put(LanguageController());
    languageController.selectedIndex = languageController.selectedIndex + 1;
    languageController.currentStep = languageController.currentStep + 1;
    languageController
        .completionStatus[languageController.currentStep.value - 1] = true;
    if (languageController.currentStep.value == 2) {
      languageController
          .completionStatus[languageController.currentStep.value - 1] = true;
      languageController
          .completionStatus[languageController.currentStep.value - 2] = true;
    }
  }
}
