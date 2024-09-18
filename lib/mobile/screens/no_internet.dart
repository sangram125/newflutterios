import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: SvgPicture.asset(
              "assets/images/appbar_images/icon_dor_play.svg",
              alignment: Alignment.center,
              width: 98,
              height: 30,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF0F1566),
                const Color(0x0B0F474A).withOpacity(0.39),
              ],
            ),
          ),
          padding: const EdgeInsets.only(bottom: 80,left: 15,right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset(
                "assets/images/nointernet.svg",
                alignment: Alignment.center,
              ),
              const SizedBox(height: 15,),
              const Text(
                "Internet Disconnected!!",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
              const SizedBox(height: 20,),
              const Text("We're sorry, we couldn't connect to the internet.\n"
                  "Please connect to the internet to continue.",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              // GestureDetector(
              //   onTap: (){
              //     Navigator.push(
              //       context, MaterialPageRoute(builder: (context) => HomePage()),
              //     );
              //   },
              //   child: Container(
              //     width: double.infinity,
              //     height: 44,
              //     alignment: Alignment.center,
              //     margin: const EdgeInsets.only(top: 50),
              //     decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(8)
              //     ),
              //     child: const Center(
              //       child: Text(
              //         "Home",
              //         textAlign: TextAlign.center,
              //         style: TextStyle(color: Colors.black,
              //           fontWeight: FontWeight.w500,
              //           fontSize: 16,
              //           fontFamily: 'Roboto',
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
    );
  }
}
