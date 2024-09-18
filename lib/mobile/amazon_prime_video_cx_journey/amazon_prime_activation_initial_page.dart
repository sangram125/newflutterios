import 'package:auto_size_text/auto_size_text.dart';
import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/data/models/models.dart';
import 'package:dor_companion/firebase_analytics/firebase_analytics.dart';
import 'package:dor_companion/mobile/profile/controller/profile_controller.dart';
import 'package:dor_companion/mobile/profile/language_screen/language_controller.dart';
import 'package:dor_companion/widgets/gradient_background_amazon_prime_initial_page.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AmazonPrimeInitialScreen extends StatefulWidget {
  final BuildContext context;
  final ChatActionMeta? chatAction;
  AmazonPrimeInitialScreen({Key? key, this.chatAction, required this.context})
      : super(key: key);

  @override
  State<AmazonPrimeInitialScreen> createState() =>
      _AmazonPrimeInitialScreenState();
}

class _AmazonPrimeInitialScreenState extends State<AmazonPrimeInitialScreen> {
  AnalyticsEvent eventCall = AnalyticsEvent();
  @override
  void initState() {
    super.initState();
  }
  void _launchURL(String uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackgroundAmazonPrimeInitialPage(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: CircleAvatar(
                        backgroundColor: const Color(0xFF1D1E39),
                        child: SvgPicture.asset(
                          'assets/icons/arrow_back.svg',
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(
                      20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                            'assets/images/amazon_prime/Amazon prime.svg'),
                        const SizedBox(
                          height: 20,
                        ),
                        const AutoSizeText(
                          'Prime Lite with dor',
                          style: AppTypography.amazonPrimeInitialScreenTitle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const AutoSizeText(
                          'Enjoy latest movies, TV shows, award-winning Amazon originals and free one-day delivery.',
                          style: AppTypography.amazonPrimeInitialScreenSubTitle,
                          maxLines: 3,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: const AutoSizeText(
                            'Watch on 2 devices\n(TV/Mobile) in HD (720p)',
                            style:
                                AppTypography.amazonPrimeInitialScreenSubTitle,
                            maxLines: 2,
                          ),
                          leading: Image.asset(
                              'assets/images/amazon_prime/popcorn_new.png'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: const AutoSizeText(
                            'Free 1-day\ndelivery',
                            style:
                                AppTypography.amazonPrimeInitialScreenSubTitle,
                            maxLines: 2,
                          ),
                          leading: Image.asset(
                              'assets/images/amazon_prime/delivery_prime.png'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                _launchURL(widget.chatAction!.activationUrl ?? "");
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Set your desired border radius here
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.white.withOpacity(0.9599999785423279),
                                ), // Set desired color
                              ),
                              child: const Text(
                                'Activate',
                                style: AppTypography.amazonPrimeActivateButton,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
