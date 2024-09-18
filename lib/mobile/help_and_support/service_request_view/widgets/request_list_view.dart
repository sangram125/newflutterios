import 'package:dor_companion/data/api/api_dio_class.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/get_issue_item_model.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/raise_a_ticket_controller.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/widgets/close_ticket_card.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/widgets/open_ticket_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/user_account.dart';

class RequestListView extends StatelessWidget {
  final List<Issue>  issueList;


   RequestListView({super.key,required this.issueList});

  @override
  Widget build(BuildContext context) {
    List<Issue>  issueListReversed = issueList.reversed.toList();
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount:issueListReversed.length,
      itemBuilder: (context, index) {
        return issueListReversed[index].status=='Closed'?
        ServiceRequestCard(issueList: issueListReversed[index],)
            :OpenTicketWidget(issueList: issueListReversed[index],onTapBottomSheet:  CloseTicketScreen(onTap: () {
          postCloseTicket(context,index);
        },issueList:  issueListReversed[index],),);
      },
    );
  }
  void postCloseTicket(BuildContext context,int index) async {
    RaiseATicketController controller=Get.put(RaiseATicketController());
    final getIt = GetIt.instance;
    final DateTime now = DateTime.now();
    final String openingDate = DateFormat('yyyy-MM-dd').format(now);
    final String openingTime = DateFormat('HH:mm:ss.SSSSSS').format(now);

    try {
      await ApiService().closeTicket
        (resolutionBy:issueList[index].resolutionBy??'' ,
          resolutionDetails: issueList[index].resolutionDetails??'',
          resolutionDate: issueList[index].resolutionDetails??openingDate,
          resolutionTime: openingTime,
          customerResolutionTime: issueList[index].userResolutionTime??'',
          ticketId:issueList[index].name??'' ,description:controller.closeTicketReason.text ,
          customer:getIt<UserAccount>().customer!
              .phoneNumber.toString() ,subject:issueList[index].subject??'' ).then((_)async{
        Navigator.pop(context);
        controller.closeTicketReason.text='';
        showToast('Ticket Closed Successfully');
      } );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to create ticket: $e');
      }
    }
  }
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP, // Position at the top
      timeInSecForIosWeb: 2,
      backgroundColor:  const Color(0xFF0E1466),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
