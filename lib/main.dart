import 'dart:io';

import 'package:dor_companion/firebase_options.dart';
import 'package:dor_companion/firebase_remote_connfig/firebase_remote_config.dart';
import 'package:dor_companion/injection/injection.dart';
import 'package:dor_companion/mobile/screens/no_internet.dart';
import 'package:dor_companion/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart' as url_strategy;
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'data/models/languages.dart';
import 'data/models/user_account.dart';
import 'data/models/user_interests.dart';

Future<void> main() async {
  var appToken = "";
  if (Platform.isIOS) {
    appToken = 'AA8f23f54a2fe2f826b9fa9601e80979f14338cd59-NRMA';
  } else if (Platform.isAndroid) {
    appToken = 'AA7b304c9144202991c0d9952b85fbffe1c44e75c7-NRMA';
  }

  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ConnectivityService());

  await configureInjection();
    runApp(const MyApp());



  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseRemoteConfigService().initialize();
  if (!kIsWeb) {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    /* Pass all uncaught asynchronous errors that aren't handled by the
     Flutter framework to Crashlytics */
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
      return true;
    };
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  url_strategy.usePathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => getIt<UserAccount>()),
        ChangeNotifierProvider(
            create: (_) => getIt<FavoriteLanguagesChangeNotifier>()),
        ChangeNotifierProvider(
            create: (_) => getIt<UserInterestsChangeNotifier>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0A0F46);
    const onPrimary = Color(0xFFEAEAEA);
    const secondary = Color(0xFF182073);
    const onSecondary = Color(0xFFEAEAEA);
    const background = Color(0xFF010521);
    const onBackground = Color(0xFFEAEAEA);
    const tertiary = Color(0xFFDC0000);
    const error = Colors.red;
    const onError = Colors.white;
    const primaryContainer = Color(0xFF101433);
    const errorContainer = Color(0xFF101433);
    const cursorColor = Colors.white;
    const selectionColor = Colors.white30;
    const selectionHandleColor = Color(0xFF2C3C85);
    const iconColor = Colors.white70;

    final router = getIt<AppRouter>();

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        final connectivityService = Get.find<ConnectivityService>();
        return Obx(() => connectivityService.isOnline.value
            ? GetMaterialApp.router(
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
          title: 'Dor',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'Raleway',
              colorScheme: const ColorScheme.dark(
                primary: primary,
                onPrimary: onPrimary,
                secondary: secondary,
                onSecondary: onSecondary,
                surface: background,
                onSurface: onBackground,
                background: background,
                onBackground: onBackground,
                tertiary: tertiary,
                error: error,
                onError: onError,
                primaryContainer: primaryContainer,
                errorContainer: errorContainer,
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: cursorColor,
                selectionColor: selectionColor,
                selectionHandleColor: selectionHandleColor,
              ),
              scaffoldBackgroundColor: background,
              iconTheme: const IconThemeData(color: iconColor),
              dialogTheme: const DialogTheme(
                backgroundColor: secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              )),
        )
            :  const MaterialApp(
          debugShowCheckedModeBanner: false,
              home: NoInternet(),
            ));
      },
    );
  }
}
