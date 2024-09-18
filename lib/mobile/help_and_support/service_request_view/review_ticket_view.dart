import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/get_issue_item_model.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/raise_a_ticket_controller.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/service_request_view.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/widgets/open_ticket_widget.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/widgets/raise_ticket_button.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/widgets/rich_text_widget.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/contact_us_menu_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RaiseTicketStep3Screen extends StatefulWidget {
  const RaiseTicketStep3Screen({super.key});

  @override
  State<RaiseTicketStep3Screen> createState() => _RaiseTicketStep3ScreenState();
}

class _RaiseTicketStep3ScreenState extends State<RaiseTicketStep3Screen> {
  final RaiseATicketController controller = Get.put(RaiseATicketController());

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String openingDate = DateFormat('d MMMM yyyy').format(now);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Review ticket',
                            style: TextStyle(
                              color: Color(0xFFA8C7FA),
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.25,
                            ),
                          ),
                          Row(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'dor TV 55’ 2024',
                                    style: TextStyle(
                                      color: Color(0xFFE2E2E2),
                                      fontSize: 11,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  Text(
                                    'OS Version 11.1',
                                    style: TextStyle(
                                      color: Color(0xFF8F8F8F),
                                      fontSize: 10,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const RichTextWidget(
                                      label: 'Plan',
                                      value: '6999/- INR Combo 2',
                                    ),
                                    RichTextWidget(
                                      label: 'User ID',
                                      value: getIt<UserAccount>().profileId.toString(),
                                    ),
                                    const RichTextWidget(
                                      label: 'Serial number',
                                      value: '9923847238273',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 29),
                            child: CustomPaint(
                              size: const Size(double.infinity, 1),
                              painter: DottedLinePainter(),
                            ),
                          ),
                          if (controller.selectedCategory.value.isNotEmpty &&
                              controller.selectedItem.value.isNotEmpty &&
                              controller.selectedType.value.isNotEmpty) ...[
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.10),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    controller.selectedCategory.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.languageViewTitle.copyWith(fontSize: 10),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.10),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                      ),
                                      child: Text(
                                        controller.selectedItem.value,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.languageViewTitle.copyWith(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              controller.selectedType.value,
                              style: const TextStyle(
                                color: Color(0xFFE2E2E2),
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.issueDetails.value,
                              style: const TextStyle(
                                color: Color(0xFF8F8F8F),
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: CustomPaint(
                                size: const Size(double.infinity, 1),
                                painter: DottedLinePainter(),
                              ),
                            ),
                          ],
                          Text(
                            openingDate,
                            style: const TextStyle(
                              color: Color(0xFFC7C7C7),
                              fontSize: 11,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  controller.wikiArticlesaList.isEmpty? SizedBox.shrink():const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(" Recommended Solution",style: TextStyle(
                        color: Color(0xFFE2E2E2),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.wikiArticlesaList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ExpansionPanelList(
                            expandIconColor: const Color(0xFFABABAB),
                            elevation: 0,
                            expansionCallback: (int panelIndex, bool isExpanded) {
                              setState(() {
                                controller.isWikiArticleExpanded = !controller.isWikiArticleExpanded;
                                // _filteredTopics[index].isExpanded =
                                // !_filteredTopics[index].isExpanded;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                headerBuilder: (BuildContext context, bool isExpanded) {
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      controller.wikiArticlesaList.elementAt(index)['title'],
                                      style: AppTypography.keyTextStyle.copyWith(fontSize: 14, color: const Color(0xFFABABAB)),
                                    ),
                                  );
                                },
                                body: Align(
                                  alignment: Alignment.centerLeft,
                                  child: HtmlWidget(
                                    controller.wikiArticlesaList.elementAt(index)['content'],
                                    //style: AppTypography.mediaHeaderTitleText.copyWith(fontSize: 12, color: const Color(0xFF8F8F8F)),
                                  ),
                                ),
                                isExpanded:controller.isWikiArticleExpanded,
                                backgroundColor: Colors.transparent,
                                canTapOnHeader: true,
                              ),
                            ],
                          ),
                          if (index != 4)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Divider(
                                color: Color(0xFF2C2C2C),
                                height: 1,
                                thickness: 1,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  controller.isSameIssuePresent ?Container(
                    width: double.infinity,
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.report_problem_outlined, size: 40),
                      title: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'There is an existing ticket in the same issue.',
                              style: TextStyle(
                                color: Color(0xFFABABAB),
                                fontSize: 12,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ): const SizedBox.shrink(),
                  const SizedBox(height: 10),
                  ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.sameIssueList.length,
                    shrinkWrap: true, // Ensures the ListView takes up only the space it needs
                    physics: const NeverScrollableScrollPhysics(), // Disables scrolling inside the ListView
                    itemBuilder: (context, index) {
                      return OpenTicketWidget(
                        issueList: controller.sameIssueList[index],
                        onTapBottomSheet: CloseTicketScreen(
                          onTap: () {
                            // controller.postCloseTicket(context, index);
                          },
                          issueList: controller.sameIssueList[index],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // RaiseTicketButton remains fixed at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaiseTicketButton(
                isReviewed: true,
                isSameIssuePresent: controller.isSameIssuePresent,
                onPressed: () async {
                  await controller.postCreateTicket(context);
                  controller.getIssueList();
                },
                text: 'Raise Ticket',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
