import 'package:dor_companion/firebase_remote_connfig/firebase_remote_config.dart';
import 'package:dor_companion/widgets/appbar.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrivacyPolicy extends StatefulWidget {
  final bool showSearchIcon;

  const PrivacyPolicy({Key? key, required this.showSearchIcon}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final aboutThreeSixty = FirebaseRemoteConfigService().getAboutThreeSixty();

  @override
  void initState() {
    super.initState();
  }

  Future<String> getData() async {
    try {
      return await rootBundle.loadString('assets/txt_files/privacy_policy.txt');
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(showSearchIcon: widget.showSearchIcon),
        body: SafeArea(
            child: SingleChildScrollView(
                child: GradientBackground(
                    child: Column(children: [
          FutureBuilder(
              future: getData(), // Call getData function
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If data is loaded, pass it to Html widget
                  return SingleChildScrollView(child: HtmlWidget(snapshot.data as String));
                } else if (snapshot.hasError) {
                  // If an error occurs, display the error message
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  // Otherwise, display a loading indicator
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ])))));
  }
}
