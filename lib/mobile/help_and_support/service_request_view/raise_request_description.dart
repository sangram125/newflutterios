import 'package:dor_companion/mobile/help_and_support/service_request_view/raise_a_ticket_controller.dart';
import 'package:dor_companion/mobile/profile/language_screen/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/raise_ticket_button.dart';

class RaiseTicketStep2Screen extends StatelessWidget {
  const RaiseTicketStep2Screen({super.key});



  @override
  Widget build(BuildContext context) {
    final RaiseATicketController controller = Get.put(RaiseATicketController());

    return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  // key: controller.formKeyForStepTwo,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explain the problem',
                        style: TextStyle(
                          color: Color(0xFFE2E2E2),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Obx(() {
                        return
                    TextFormField(
                          controller: controller.textController,
                          maxLength: 250,
                          decoration: InputDecoration(
                            counterText: '${controller.issueDetails.value.length}/${250}',
                            hintText: 'Write detailed description...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    width: 1.50, color: Color(0x66A8C7FA))),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Color(0x66A8C7FA), width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Color(0x66A8C7FA), width: 1.5),
                            ),
                          ),
                          maxLines: 10,
                          validator: controller.validateIssueDetails,
                        );
                      }
                      ),
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
                  if(controller.issueDetails.value == ''){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Color(0xFF0E1466),
                      content: Text(
                        "Please Enter Description",
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
                  }else {
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
    languageController.completionStatus[languageController.currentStep.value - 1] = true;
        if(languageController.currentStep.value == 2){
          languageController.completionStatus[languageController.currentStep.value - 1] = true;
          languageController.completionStatus[languageController.currentStep.value - 2] = true;
        }
  }
}
