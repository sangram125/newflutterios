import 'package:dor_companion/data/api/api_dio_class.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/get_issue_item_model.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/raise_a_ticket_controller.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/widgets/open_ticket_widget.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/widgets/request_list_view.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/help_support_header_widget.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'raise_ticket_progress_tab.dart';
import 'widgets/close_ticket_card.dart';
import 'widgets/filter_chip_widget.dart';

class ServiceRequestsPage extends StatefulWidget {
  const ServiceRequestsPage({super.key});

  @override
  ServiceRequestsPageState createState() => ServiceRequestsPageState();
}

class ServiceRequestsPageState extends State<ServiceRequestsPage> {
  int _selectedIndex = 0;



  @override
  void initState() {
    super.initState();
    controller.getCustomer();
    //controller.getIssueList();

  }

  void _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  RaiseATicketController controller =  Get.put(RaiseATicketController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackground(
          child: Column(
            children: [
              const HelpAndSupportHeaderWidget(title: 'Service Requests'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilterChipWidget(
                        index: 0,
                        label: 'All',
                        isSelected: _selectedIndex == 0,
                        onSelected: _onSelected),
                    const SizedBox(width: 8),
                    FilterChipWidget(
                        index: 1,
                        label: 'Active tickets',
                        isSelected: _selectedIndex == 1,
                        onSelected: _onSelected),
                    const SizedBox(width: 8),
                    FilterChipWidget(
                        index: 2,
                        label: 'Closed tickets',
                        isSelected: _selectedIndex == 2,
                        onSelected: _onSelected),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() => controller.isLoadingForIssueList.value
                    ? const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                )
                    : IndexedStack(
                  index: _selectedIndex,
                  children: [
                    RequestListView(issueList: controller.issueList),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: controller.issueList.reversed.length,
                        itemBuilder: (context, index) => controller.issueList.reversed.elementAt(index).status == 'Open'
                            ? OpenTicketWidget(
                          issueList: controller.issueList.reversed.elementAt(index),
                          onTapBottomSheet: CloseTicketScreen(
                            onTap: () {
                              postCloseTicket(context, index);
                            },
                            issueList: controller.issueList[index],
                          ),
                        )
                            : const SizedBox(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: controller.issueList.reversed.length,
                        itemBuilder: (context, index) => controller.issueList.reversed.elementAt(index).status == 'Closed'
                            ? ServiceRequestCard(issueList: controller.issueList.reversed.elementAt(index))
                            : const SizedBox(),
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RaiseATicketProgressTab(),
            ),
          );
        },
        label: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/Ticket.svg',
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Raise a ticket',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void postCloseTicket(BuildContext context, int index) async {
    RaiseATicketController controller = Get.put(RaiseATicketController());
    final getIt = GetIt.instance;
    final DateTime now = DateTime.now();
    final String openingDate = DateFormat('yyyy-MM-dd').format(now);
    final String openingTime = DateFormat('HH:mm:ss.SSSSSS').format(now);

    try {
      await ApiService().closeTicket(
        resolutionBy: controller.issueList[index].resolutionBy ?? '',
        resolutionDetails: controller.issueList[index].resolutionDetails ?? '',
        resolutionDate: controller.issueList[index].resolutionDetails ?? openingDate,
        resolutionTime: openingTime,
        customerResolutionTime: controller.issueList[index].userResolutionTime ?? '',
        ticketId: controller.issueList[index].name ?? '',
        description: controller.closeTicketReason.text,
        customer: getIt<UserAccount>().customer!.phoneNumber.toString(),
        subject: controller.issueList[index].subject ?? '',
      ).then((_) async {
        Navigator.pop(context);
        controller.closeTicketReason.text = '';
        showToast('Ticket Closed Successfully');
      });
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
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: const Color(0xFF0E1466),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}


