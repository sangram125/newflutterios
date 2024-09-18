import 'package:auto_size_text/auto_size_text.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/get_issue_item_model.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/raise_a_ticket_controller.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/contact_us_menu_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'raise_ticket_button.dart';
import 'ticket_progress_tracker.dart';

class OpenTicketWidget extends StatelessWidget{
  final Issue issueList;
  final Widget onTapBottomSheet;


  const OpenTicketWidget({super.key,required this.issueList,
    required this.onTapBottomSheet});

  String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat outputFormat = DateFormat('d MMMM yyyy');
    String formattedDate = outputFormat.format(dateTime);
    print("formated date ${formattedDate}");
    return 'Last update: $formattedDate';
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            border: Border.all(color: const Color(0xFF474747))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                    Expanded(
                      child: AutoSizeText(issueList.subject??'App Not Working',
                        overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                            ),
                                ),
                    ),
                    ],
                  ),
                ),
                // const SizedBox(
                //   width: 12,
                // ),
                // Expanded(
                //   child: Text(
                //     issueList.customTicketItem??'TV is not turning ON',
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //     style: AppTypography.homeViewTitle
                //         .copyWith(fontSize: 12, fontFamily: 'Roboto'),
                //   ),
                // ),
                //const SizedBox(width: 18,),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      )),
                  child: Text(
                    issueList.status??'Open',
                    style: AppTypography.addToWatchListFilters.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),

            Text(
              'ID: ${issueList.name}',
              style: AppTypography.amazonPrimeTermsAndConditionsText.copyWith(
                  fontSize: 9,
                  color: const Color(0xFFABABAB),
                  fontFamily: 'Roboto'),
            ),
            const SizedBox(
              height: 3,
            ),
            if(issueList.openingDate!.isNotEmpty&&
                issueList.openingDate!=null)...[
              Text(
                '${formatDateString(issueList.openingDate??
                    DateTime.now().toString())}',
                style: AppTypography.amazonPrimeTermsAndConditionsText.copyWith(
                    fontSize: 9,
                    color: const Color(0xFFABABAB),
                    fontFamily: 'Roboto'),
              ),
            ],

            //ProgressTracker(),
            const SizedBox(height: 12,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ButtonWithBorder(onPressed: () {
            //       showModalBottomSheet(context: context, builder:
            //       (context) {
            //         return  onTapBottomSheet;
            //       },);
            //     },text: 'Close ticket'),
            //     const SizedBox(width: 8,),
            //     ButtonWithBorder(onPressed: () {
            //     },text: 'Comment'),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class CloseTicketScreen extends StatelessWidget {
  final Issue issueList;
  final Function() onTap;

  const CloseTicketScreen({super.key, required this.issueList, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final RaiseATicketController controller = Get.put(RaiseATicketController());

    return Scaffold(
      backgroundColor: const Color(0xFF040833),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.white.withOpacity(.09),
                      Colors.white.withOpacity(0.07),
                      Colors.white.withOpacity(0),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.white.withOpacity(.10)),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Request Details',
                          style: TextStyle(
                            color: Colors.blue[200],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Text(
                            issueList.status ?? 'Open',
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (issueList.customTicketItem != null &&
                        issueList.customTicketCategory != null &&
                        issueList.customTicketType != null) ...[
                      Text(
                        issueList.customTicketItem ?? '',
                        style: const TextStyle(color: Color(0xFFE2E2E2), fontSize: 14, fontFamily: 'Roboto', fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.10),
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Text(
                              issueList.customTicketCategory ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.10),
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Text(
                              issueList.customTicketType ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      'ID: ${issueList.name}',
                      style: TextStyle(fontSize: 9, color: const Color(0xFFABABAB), fontFamily: 'Roboto'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatDateString(issueList.openingDate ?? DateTime.now().toString()),
                      style: TextStyle(fontSize: 9, color: const Color(0xFFABABAB), fontFamily: 'Roboto'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomPaint(
                        size: const Size(double.infinity, 1),
                        painter: DottedLinePainter(),
                      ),
                    ),
                    const Text(
                      'Reason for closing Ticket',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      return TextFormField(
                        controller: controller.closeTicketReason,
                        maxLength: 60,
                        decoration: InputDecoration(
                          counterText: '${controller.closeTicketDetails.value.length}/60',
                          hintText: 'State Reason',
                          hintStyle: const TextStyle(
                            color: Color(0xFF5E5E5E),
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(width: 1.50, color: Color(0x66A8C7FA)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0x66A8C7FA), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0x66A8C7FA), width: 1.5),
                          ),
                        ),
                        maxLines: 2,
                        validator: controller.validateIssueDetails,
                      );
                    }),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: OutlinedButton(
                        onPressed: onTap,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.05),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Submit and close',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.withOpacity(.5),
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat outputFormat = DateFormat('d MMMM yyyy');
    String formattedDate = outputFormat.format(dateTime);
    return 'Last update: $formattedDate';
  }
}




