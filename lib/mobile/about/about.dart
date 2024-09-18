import 'package:dor_companion/firebase_remote_connfig/firebase_remote_config.dart';
import 'package:dor_companion/widgets/appbar.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final aboutThreeSixty = FirebaseRemoteConfigService().getAboutThreeSixty();
  @override
  void initState() {
    super.initState();
  }

  Future<String> getData() async {
    try {
      return await rootBundle.loadString('assets/txt_files/about_threesixty.txt');
    } catch (e) {
      throw (e.toString());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GradientBackground(
            child: Column(
              children: [
                Text(aboutThreeSixty),
                FutureBuilder(
                  future: getData(), // Call getData function
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If data is loaded, pass it to Html widget
                      return SingleChildScrollView(
                        child: HtmlWidget( snapshot.data as String,)
                      );
                    } else if (snapshot.hasError) {
                      // If an error occurs, display the error message
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else {
                      // Otherwise, display a loading indicator
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

