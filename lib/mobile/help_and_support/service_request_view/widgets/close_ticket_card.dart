import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/get_issue_item_model.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/contact_us_menu_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceRequestCard extends StatelessWidget {
  final Issue issueList;

  const ServiceRequestCard({super.key, required this.issueList});

  String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat outputFormat = DateFormat('d MMMM yyyy');
    String formattedDate = outputFormat.format(dateTime);
    return 'Last update Date: $formattedDate';
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
                  child: Text(
                    issueList.subject ?? 'TV is not turning ON',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.homeViewTitle
                        .copyWith(fontSize: 12, fontFamily: 'Roboto'),
                  ),
                ),
                const SizedBox(
                  width: 18,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      )),
                  child: Text(
                    'CLOSED',
                    style: AppTypography.addToWatchListFilters.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  'ID: ${issueList.name}',
                  style: AppTypography.amazonPrimeTermsAndConditionsText
                      .copyWith(
                          fontSize: 9,
                          color: const Color(0xFFABABAB),
                          fontFamily: 'Roboto'),
                ),
              ],
            ),
            if (issueList.openingDate!.isNotEmpty &&
                issueList.openingDate != null) ...[
              Text(
                '${formatDateString(issueList.openingDate!)}',
                overflow: TextOverflow.ellipsis,
                style: AppTypography.amazonPrimeTermsAndConditionsText
                    .copyWith(
                    fontSize: 9,
                    color: const Color(0xFFABABAB),
                    fontFamily: 'Roboto'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
