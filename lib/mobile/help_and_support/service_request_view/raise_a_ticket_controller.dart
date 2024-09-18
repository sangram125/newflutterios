import 'dart:convert';
import 'dart:ffi';

import 'package:dor_companion/data/api/api_dio_class.dart';
import 'package:dor_companion/data/api/sensy_api.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/get_issue_item_model.dart';
import 'package:dor_companion/data/models/user_account.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/help_and_support/service_request_view/service_request_view.dart';
import 'package:dor_companion/mobile/profile/language_screen/language_controller.dart';
import 'package:dor_companion/mobile/profile/profile_main_views.dart';
import 'package:dor_companion/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/get_ticket_item_model.dart';
class RaiseATicketController extends GetxController {
  RxBool isSaving = false.obs;
  RxList<bool> completionStatus = [false, false, false].obs;
  RxBool isLocalLanguageSaved = false.obs;
  bool isSkipPressed = false;
  Rx<String> selectedCategory = ''.obs;
  Rx<String> selectedType = ''.obs;
  Rx<String> selectedItem = ''.obs;
  final issueDetails = ''.obs;
  final closeTicketDetails = ''.obs;
  final TextEditingController textController = TextEditingController();
  final TextEditingController closeTicketReason = TextEditingController();
  RxList<Name> categories = <Name>[].obs;
  RxList<Name> ticketType = <Name>[].obs;
  RxList<Name> ticketItem = <Name>[].obs;
  RxBool isLoading = false.obs;
  List<Issue> issueList = [];
  RxBool isLoadingForIssueList = false.obs;
  String crnNo = '';
  RxBool isWhatsAppTap = false.obs;
  List<Issue> sameIssueList = [];
  bool isSameIssuePresent = false;
  List<dynamic> wikiArticlesaList = [];
  bool isWikiArticleExpanded = false;
  @override
  void onInit() {
    super.onInit();
    fetchCategoryApi();
    textController.addListener(() {
      issueDetails.value = textController.text;
    });
    closeTicketReason.addListener(() {
      closeTicketDetails.value = closeTicketReason.text;
    });
  }

  void fetchCategoryApi() async {
    List<Name> data =
    await ApiService().fetchCategoryData();
    categories.value = data;
    if (kDebugMode) {
      print('Category API: ${data[0].name}');
    }
    update();
  }

  void fetchTypeApi({String? filter}) async {
    List<Name> data =
    await ApiService().fetchTicketTypeData(filter: filter);
    ticketType.value = data;
    if (kDebugMode) {
      print('Ticket Type API: Success');
    }
    update();
  }

  void fetchItemApi({String? filter}) async {
    List<Name> data =
    await ApiService().fetchTicketItemData(filter: filter);
    ticketItem.value = data;
    if (kDebugMode) {
      print('Ticket Item API: Success');
    }
    update();
  }

  void getIssueList() async {
    isLoadingForIssueList.value = true;
    List<Issue> data = await ApiService()
        .getIssueList(
        mobileNumber: crnNo);

    issueList = data;

    isLoadingForIssueList.value = false;
    if (kDebugMode) {
      //print('Issue API: ${data[0].name}');
    }
  }

  void getCustomer() async {
    List<dynamic> data = await ApiService()
        .getCustomer(
        mobileNumber: getIt<UserAccount>().customer!.phoneNumber.toString());
    if(data.isNotEmpty) {
      crnNo = data[0]['name'];
      getIssueList();
    }else{
      issueList=[];
    }

  }
  void getSameIssue() async {
    isLoadingForIssueList.value = true;
    List<Issue> data = await ApiService()
        .getSameIssue(
        mobileNumber: crnNo,customTicketItem: selectedItem.value);

    sameIssueList = data;
    if(data.isNotEmpty){
      isSameIssuePresent = true;
    }
    else{
      isSameIssuePresent = false;
    }
    isLoadingForIssueList.value = false;
  }

  void getWikiArticles() async {
    List<dynamic> data = await ApiService()
        .getWikiArticles(
        mobileNumber: crnNo,customTicketItem: selectedItem.value);
    if(data.isNotEmpty) {
      wikiArticlesaList = data;
    }
    else{
      wikiArticlesaList = [];
    }
  }
  @override
  void onClose() {
    textController.dispose();
    closeTicketReason.dispose();
    super.onClose();
  }

  String? validateIssueDetails(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please describe the issue';
    }
    return null;
  }

  postCreateTicket(BuildContext context) async {
    LanguageController languageController = Get.put(LanguageController());
    final getIt = GetIt.instance;
    final DateTime now = DateTime.now();
    final String openingDate = DateFormat('yyyy-MM-dd').format(now);
    final String openingTime = DateFormat('HH:mm:ss.SSSSSS').format(now);
    try {
      await ApiService().createIssue(
        subject: '${selectedCategory.value} - ${selectedType
            .value} - ${selectedItem.value}',
        customer: crnNo,
        status: 'Open',
        issueSource: 'Companion App',
        ticketItem: selectedItem.value,
        description: issueDetails.value,
        openingDate: openingDate,
        openingTime: openingTime,
      ).then((_) async {
        Navigator.pop(context, MaterialPageRoute(builder:
            (context) =>
        const ServiceRequestsPage()));
        selectedItem.value = '';
        selectedType.value = '';
        selectedCategory.value = '';
        issueDetails.value = '';
        languageController.currentStep.value = 0;
        languageController.selectedIndex.value = 0;
        textController.text = '';
        languageController.completionStatus.value = [false, false, false];
        showToast('Ticket Created Successfully');
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
      // Position at the top
      timeInSecForIosWeb: 2,
      backgroundColor: const Color(0xFF0E1466),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  void _launchURL(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
  Future<void> Whatsapplogin() async {
    final getIt = GetIt.instance;
    try {
     var data =  await ApiService().whatsAppLogin();
     if (data['JWTAUTH'] != null) {
       String userName = getIt<UserAccount>().profileName.toString();

       var msgData =  await ApiService().sendingMessageToWhatsApp(data['JWTAUTH'],getIt<UserAccount>().customer!
           .mobileNumber.toString(), userName);
       if(msgData['message'] == 'message received successfully'){
           final Uri whatsappUri = Uri(scheme: 'https', path: Constants.whatsAppLink);
           _launchURL(whatsappUri);
       }
     } else {
       showVanillaToast('Please try again later!');
     }
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }
}
