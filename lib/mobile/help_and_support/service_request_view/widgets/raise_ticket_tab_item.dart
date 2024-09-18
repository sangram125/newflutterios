import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/data/models/user_interests.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/raise_a_ticket_controller.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/raise_request_description.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/raise_request_view.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/review_ticket_view.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/service_request_view.dart';
import 'package:dor_companion/mobile/profile/language_screen/language_controller.dart';
import 'package:dor_companion/mobile/screens/personalization_view.dart';
import 'package:dor_companion/utils.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app_router.dart';
import '../../../home/view/home_main_view.dart';
import '../../../home/view/news_view.dart';
import '../../../home/view/sports_view.dart';
import '../../../widgets/live_tv_view.dart';
class RaiseTicketTabItem extends StatefulWidget {
  final int step;

  const RaiseTicketTabItem(this.step, {super.key});

  @override
  State<RaiseTicketTabItem> createState() => RaiseTicketTabItemState();
}

class RaiseTicketTabItemState extends State<RaiseTicketTabItem> {


  AnalyticsEvent eventCall = AnalyticsEvent();

  @override
  Widget build(BuildContext context) {
    switch (widget.step) {
      case 0:
        return RaiseTicketStep1Screen();
      case 1:
        return const RaiseTicketStep2Screen();
      case 2:
        return const RaiseTicketStep3Screen();
      default:
        return Column(
          children: [
            Container(),
          ],
        );
    }
  }
}