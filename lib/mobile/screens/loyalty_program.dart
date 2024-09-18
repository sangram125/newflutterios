import 'package:dor_companion/data/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoyaltyProgram extends StatefulWidget {
  const LoyaltyProgram({Key? key}) : super(key: key);

  @override
  State<LoyaltyProgram> createState() => _LoyaltyProgramState();
}

class _LoyaltyProgramState extends State<LoyaltyProgram> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white.withOpacity(0.2),
            padding: const EdgeInsets.only(top: 50, left: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: SvgPicture.asset(
                      "assets/images/home_images/arrow_right_alt.svg",
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child:  Text(
                      "Loyalty program",
                      style:
                          AppTypography.fontSizeValue(24),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child:  Text(
                      "Lorem Ipsum dolor seit ameit",
                      style:
                      AppTypography.fontSizeValue(13),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          // Set the desired background color
                          borderRadius: BorderRadius.circular(
                              7.0), // Set the desired border radius
                        ),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/login_images/watch_time.png',
                              // Replace with your image file path
                              width: 20.0, // Adjust the width as needed
                              height: 20.0, // Adjust the height as needed
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child:  Text(
                                "Watchtime     5hr",
                                style: AppTypography.fontSizeValue(14),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          // Set the desired background color
                          borderRadius: BorderRadius.circular(
                              7.0), // Set the desired border radius
                        ),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/login_images/point_earned.png',
                              // Replace with your image file path
                              width: 20.0, // Adjust the width as needed
                              height: 20.0, // Adjust the height as needed
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child:  Text(
                                "Points earned 10",
                                style: AppTypography.fontSizeValue(14),
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // InkWell(
          //   onTap: (){
          //     context.push("/subscriptions");
          //   },
          //   child: Container(
          //     margin: EdgeInsets.all(15),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: Text(
          //             "Redeem pointss",
          //             style: TextStyle(fontSize: 16),
          //           ),
          //         ),
          //         Icon(Icons.arrow_forward),
          //       ],
          //     ),
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.yellow,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/login_images/bulb_light.png',
                          height: 26,
                          width: 26, // Adjust the height as needed
                        ),
                        const Text("Pro tip", style: AppTypography.undefinedTextStyle,),
                      ],
                    ),
                  ),
                ),
                //Switch to premium membership to earn more points in short time
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: const EdgeInsets.all(5),
                      child: const Text(
                          "Switch to premium membership to earn more points in short time",
                          style: AppTypography.undefinedTextStyle)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
