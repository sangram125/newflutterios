import 'package:dor_companion/mobile/help_and_support/service_request_view/raise_a_ticket_controller.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/help_support_header_widget.dart';
import 'package:dor_companion/mobile/profile/language_screen/language_controller.dart';
import 'package:dor_companion/mobile/profile/language_screen/widgets/icon_tab_widget.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'widgets/raise_ticket_tab_item.dart';

class RaiseATicketProgressTab extends StatefulWidget {
  final bool isComingFromProfile;
  const RaiseATicketProgressTab({super.key, this.isComingFromProfile = false});

  @override
  State<RaiseATicketProgressTab> createState() =>
      RaiseATicketProgressTabState();
}

class RaiseATicketProgressTabState extends State<RaiseATicketProgressTab> {
  RaiseATicketController controller = Get.put(RaiseATicketController());
  LanguageController languageController = Get.put(LanguageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: Obx(() =>
             Column(
              children: [
                HelpAndSupportHeaderWidget(title: 'Raise Ticket',
                onPressed: (){
                  if(languageController.currentStep.value == 1){
                    languageController.currentStep.value = 0;
                    languageController.selectedIndex.value = 0;
                  } else if(languageController.currentStep.value == 2){
                    languageController.currentStep.value = 1;
                    languageController.selectedIndex.value = 1;
                  } else {
                    context.pop();
                    controller.selectedItem.value='';
                    controller.selectedType.value='';
                    controller.selectedCategory.value='';
                    controller.issueDetails.value='';
                    // controller.category.value= '';
                    // controller.issueType.value = '';
                    // controller.issueItem.value = '';
                    languageController.currentStep.value = 0;
                    languageController.selectedIndex.value = 0;
                    controller.textController.text='';
                    languageController.completionStatus.value = [false, false, false];
                  }
                }),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              TabIconCommon(
                                 tabName:'Select category',
                                  index: 0,
                                  iconPath: "assets/icons/select_catagory.svg",
                                  onTap: () {
                                    languageController.selectedIndex.value = 0;
                                    languageController.currentStep.value = 0;
                                  }),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              height: 1,
                              width: 40,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin:Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [Colors.white,Colors.grey, Color(0x00D9D9D9)],
                                  )
                              ),
                            ),
                          )
                        ],
                      ),

                      // Custom method to build icon with completion status
                      Row(
                        children: [
                          TabIconCommon(
                            tabName: 'Describe problem',
                              index: 1,
                              iconPath:
                                  'assets/icons/tv_issue.svg',
                              onTap: () {
                                languageController.selectedIndex.value = 1;
                                languageController.currentStep.value = 1;
                              }),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              height: 1,
                              width: 40,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin:Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [Colors.white, Color(0x00D9D9D9)],
                                )
                              ),
                            ),
                          )
                        ],
                      ),

                      TabIconCommon(
                        tabName: 'Review',
                          index: 2,
                          iconPath:
                              'assets/icons/Ticket.svg',
                          onTap: () {
                            languageController.selectedIndex.value = 2;
                            languageController.currentStep.value = 2;
                          }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(child: RaiseTicketTabItem(languageController.currentStep.value))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
