import 'dart:async';

import 'package:dor_companion/app_router.dart';
import 'package:dor_companion/login_view/mobile_number_verify/login_view_controller.dart';
import 'package:dor_companion/mobile/home/view/news_view.dart';
import 'package:dor_companion/mobile/home/view/sports_view.dart';
import 'package:dor_companion/mobile/widgets/live_tv_view.dart';
import 'package:dor_companion/widgets/gradient_background_splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../data/models/user_account.dart';
import '../../injection/injection.dart';
import '../home/view/home_main_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({
    super.key,
  });

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  VideoPlayerController? _controller;
  bool _visible = false;

  final contrl = Get.put(LogInViewController());

  @override
  void initState() {
    super.initState();
    initializeVideo();
    getIt<UserAccount>().setOnHome(false);
    _startShowVideoTimer();
  }

  Future<void> apiCallForPreLoading() async {
    return await getIt<UserAccount>().fetchCustomer();
  }

  initializeVideo() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //_controller = VideoPlayerController.asset("assets/splash_video/splash_intro.mov");
    _controller = VideoPlayerController.asset("assets/splash_video/dor_splash_video.mp4");
    _controller?.initialize().then((_) {
      _controller?.addListener(() {
        if (_controller?.value.position == _controller?.value.duration) {
          // Video has ended, navigate to the desired page
          getIt<AppRouter>().go('/');
        }
      });
      Timer(const Duration(milliseconds: 100), () {
        setState(() {
          _controller?.play();
          _visible = true;
        });
      });
    });
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: _controller != null ? VideoPlayer(_controller!) : null,
    );
  }

  _getBackgroundColor() {
    return Container(color: Colors.transparent //.withAlpha(120),
        );
  }

  _getContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  void _startShowVideoTimer() {
    if (getIt<UserAccount>().isLoggedIn()) {
      apiCallForPreLoading().then((_) {
        _timer = Timer(const Duration(seconds: 2), () {
          callHomeInit();
          // callInitNews();
          // callInitSports();
          // callInit();
        });
      });
    }
    // _timer = Timer(const Duration(seconds: 6), () {
    //   getIt<AppRouter>().go('/');
    //   // contrl.showVideo.value = false;
    //   // _startTextChangeTimer();
    // });
  }

  void _startTextChangeTimer() {
    _timer = Timer(const Duration(milliseconds: 1500), () {
      contrl.showFirstText.value = false;
    });
    _nextSplashScreen();
  }

  void _nextSplashScreen() {
    _timer = Timer(const Duration(milliseconds: 3000), () {
      getIt<AppRouter>().go('/');
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dispose of the timer when the widget is disposed
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _getVideoBackground()
    //     Obx(
    //   () => contrl.showVideo.value
    //       ? _getVideoBackground()
    //       : SafeArea(
    //           child: SingleChildScrollView(
    //             child: GradientBackgroundSplashView(
    //               child: Center(
    //                   child: SizedBox(
    //                 child: contrl.showFirstText.value
    //                     ? Text.rich(
    //                         TextSpan(
    //                           children: [
    //                             const TextSpan(
    //                               text: 'The Ultimate Tv \n',
    //                               style: TextStyle(
    //                                 color: Colors.white,
    //                                 fontSize: 20,
    //                                 fontFamily: 'Roboto',
    //                                 fontWeight: FontWeight.w400,
    //                                 height: 0,
    //                                 letterSpacing: -0.40,
    //                               ),
    //                             ),
    //                             TextSpan(
    //                               text: 'Experience is calling',
    //                               style: GoogleFonts.grandHotel(
    //                                 color: Colors.white,
    //                                 fontSize: 30,
    //                                 fontWeight: FontWeight.w400,
    //                                 height: 0,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       )
    //                     : Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           const Text.rich(
    //                             textAlign: TextAlign.center,
    //                             TextSpan(
    //                               children: [
    //                                 TextSpan(
    //                                   text: 'Welcome to 3Sixty \n',
    //                                   style: TextStyle(
    //                                     color: Colors.white,
    //                                     fontSize: 25,
    //                                     fontFamily: 'Roboto',
    //                                     fontWeight: FontWeight.w600,
    //                                     height: 0,
    //                                     letterSpacing: -0.40,
    //                                   ),
    //                                 ),
    //                                 TextSpan(
    //                                   text: 'Your own Indian TV for the finest experience',
    //                                   style: TextStyle(
    //                                     color: Color(0xFF8F8F8F),
    //                                     fontSize: 10,
    //                                     fontFamily: 'Roboto',
    //                                     fontWeight: FontWeight.w400,
    //                                     height: 0,
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           SizedBox(
    //                             width: 200,
    //                             height: 95,
    //                             child: Container(
    //                               margin: const EdgeInsets.only(bottom: 40),
    //                               child: SvgPicture.asset(
    //                                 "assets/icons/icon_dor.svg",
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //               )),
    //             ),
    //           ),
    //         ),
    // )
    );
  }
}
