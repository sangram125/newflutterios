
import 'dart:async';

import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/raise_a_ticket_controller.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/service_request_view.dart';
import 'package:dor_companion/mobile/help_and_support/widgets/contact_us_menu_card.dart';
import 'package:dor_companion/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactUsMenuList extends StatelessWidget {
   ContactUsMenuList({Key? key}) : super(key: key);
  final RaiseATicketController controller = Get.put(RaiseATicketController());
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(()=>
          ContactUsMenuCard(
            isWhatsapp:controller.isWhatsAppTap.value,
            description: 'Find a team member to talk to',
            icon: 'assets/icons/whatsapp.svg',
            title: 'WhatsApp us',
            onTap: () async {
             print("login starts");
             //_launchWhatsApp();
             controller.isWhatsAppTap.value = true;
             await controller.Whatsapplogin();
             controller.isWhatsAppTap.value = false;
            },
          ),
        ),
        _buildDottedLine(),
        ContactUsMenuCard(
          isWhatsapp:false,
          description: 'Raise a service request',
          icon: 'assets/icons/Ticket.svg',
          title: 'Service request',
          onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ServiceRequestsPage(),
                ),
              );
          },
        ),
        const SizedBox(
          height: 24,
        )
      ],
    );
  }

  Widget _buildDottedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: CustomPaint(
        size: const Size(double.infinity, 1),
        painter: DottedLinePainter(),
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(scheme: 'mailto', path: Constants.emailIId);
    _launchURL(emailUri);
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: Constants.contactNumber);
    _launchURL(phoneUri);
  }

  void _launchWhatsApp() async {
    final Uri whatsappUri = Uri(scheme: 'https', path: Constants.whatsAppLink);

    _launchURL(whatsappUri);
  }

  void _launchURL(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
}
