import 'package:dor_companion/data/models/constants.dart';
import 'package:dor_companion/mobile/amazon_prime_video_cx_journey/amazon_prime_activation_initial_page.dart';
import 'package:dor_companion/widgets/appbar.dart';
import 'package:dor_companion/widgets/gradient_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({super.key});
  @override
  MyPlanScreenState createState() => MyPlanScreenState();
}

class MyPlanScreenState extends State<MyPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GradientBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.00, 1.00),
                    end: Alignment(0, -1),
                    colors: [Color(0xFF232548), Color(0xFF2F3262)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.53),
                  ),
                ),
                child: ListTile(
                  leading: SvgPicture.asset(
                      "assets/images/amazon_prime/Prime_video.svg"), // Example leading icon
                  title: const Text(
                    "Amazon Prime",
                    style: AppTypography.amazonPrimeText,
                  ),
                  subtitle: const Text(
                    "Lite with dor",
                    style: AppTypography.liteWithDorTextPrime,
                  ),
                  trailing: TextButton(
                    child: const Text(
                      "Activate",
                      style: AppTypography.amazonPrimeMyPlanActivateButton,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AmazonPrimeInitialScreen(context: context)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
