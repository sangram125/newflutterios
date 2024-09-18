import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Constants {
  static const String defaultErrorMessage = "Something went wrong!";
  static const String deeplinkLaunchError = "Error launching deeplink!";
  static const String noCompatibleAppForDeeplink =
      "Could not find an app that can handle deeplink! Taking to play store..";
  static const String watchOnActionLabelPrefix = "Watch on";
  static const String playStoreDeeplinkCompatibilityError =
      "Can't launch play store!";
  static const String playStoreDeeplinkError = "Error laucnhing play store";

  ///Global variables for events.
  static String networkType = "";
  static String lat = "";
  static String long = "";
  static String mobile = "";

  static const List<String> trendingList = [
    "Oppenheimer",
    "Stranger things",
    "Bigboss",
  ];

  static const List<String> browseAllMovie = [
    "Best of Bollywood",
    "Spine Chilling Horror",
    "Historical Epics",
  ];
  static const emailIId = 'care@3sixtytv.com';
  static const contactNumber = '+919088360360';
  static const whatsAppLink = 'wa.me/+919088360360';
}

class MediaRowContentTypes {
  static final peopleTypes = [
    people,
    peopleInScenes,
    peopleInPortraits,
    peopleImages,
  ];

  static const int defaultType = 0;
  static const int broadcast = 20;
  static const int channel = 21;
  static const int people = 22;
  static const int peopleInScenes = 27;
  static const int peopleInPortraits = 28;
  static const int peopleImages = 29;
  static const int availableApps = 30;
  static const int apps = 34;
  static const int settings = 37;
  static const int youtube = 24;
  static const int appFilters = 116;
}

class AppTypography {
  static const String fontFamilyString = 'Raleway';
  static const TextStyle headline1 = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Raleway');
  static const TextStyle bodyText1 =
      TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Raleway');

  static const TextStyle addProfile = TextStyle(
    fontSize: 18,
    //color: Theme.of(context).colorScheme.onBackground,
    fontFamily: 'Raleway',
    decorationThickness: 700,
  );

  static const TextStyle undefinedTextStyle = TextStyle(
    fontFamily: 'Raleway',
  );

  static TextStyle profileModificationView = TextStyle(
    color: Colors.white.withOpacity(0.7),
    fontFamily: 'Raleway',
  );

  static TextStyle profileModificationViewWhiteColor = const TextStyle(
    color: Colors.white,
    fontFamily: 'Raleway',
  );

  static const TextStyle profileMainViews = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
  );

  static const TextStyle profileMainViewsTitle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 0,
  );

  static const TextStyle settingsViewTitle = TextStyle(
    color: Color(0xFFF2F2F2),
    fontSize: 17,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );

  static TextStyle settingsViewSubTitle = TextStyle(
      fontSize: 18,
      color: Colors.white.withOpacity(0.8),
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w400);

  static TextStyle languageViewTitle = const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle languageViewLangPreference = TextStyle(
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
  );

  static const settingViewDoItLater = TextStyle(
      color: Colors.white,
      fontSize: 14,
      decorationThickness: 1,
      fontFamily: 'Raleway',
      decoration: TextDecoration.underline);

  static const TextStyle settingViewLangSymbol = TextStyle(
    color: Colors.black,
    fontSize: 32,
    fontFamily: 'Raleway',
  );

  static const TextStyle settingViewLangName = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontFamily: 'Raleway',
  );

  static const TextStyle homeViewTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Raleway',
  );

  static const TextStyle fontSizeChanges = TextStyle(
    fontSize: 16,
    fontFamily: 'Raleway',
  );

  static TextStyle addToWatchListFilters = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w400,
  );

  static TextStyle addToWatchListFilterIndex = TextStyle(
    color: Colors.white, //background: #FFFFFF80;
    fontSize: 14.sp,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w400,
  );

  static TextStyle addToWatchListButton = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
  );

  static TextStyle mediaItemTitle = TextStyle(
      color: Colors.white,
      fontSize: 20.sp,
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w600);

  static TextStyle mediaItemSubTitle = TextStyle(
    color: Colors.white.withOpacity(0.80),
    //background: #FFFFFF80;
    fontSize: 13.sp,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle customTextButton = TextStyle(
    fontSize: 16.0,
    color: Colors.white,
    fontFamily: 'Raleway',
    decorationThickness: 700,
  );

  static const TextStyle dpadView = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Raleway',
    color: Color(0xEEFFFFFF),
  );

  static const TextStyle liveTvViewTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Raleway',
  );

  static TextStyle fontSizeValue(double size) => TextStyle(
        fontSize: size,
        fontFamily: 'Raleway',
      );

  static const TextStyle keyTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Raleway',
  );

  static const TextStyle loginPageSignUp = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: 'Raleway',
  );

  static const TextStyle loginText = TextStyle(
    color: Colors.blue,
    fontSize: 16,
    fontFamily: 'Raleway',
  );

  static const TextStyle submitTextLogInPage = TextStyle(
    color: Colors.white,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );

  static const TextStyle mediaDetailViewErrorMsg = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Raleway',
  );

  static const TextStyle onBoardingViewSkipText = TextStyle(
      //color: Theme.of(context).colorScheme.onPrimary,
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Raleway',
      decoration: TextDecoration.underline);

  static const TextStyle onBoardingViewLargeFontTitle = TextStyle(
    //color: Theme.of(context).colorScheme.onPrimary,
    color: Colors.black,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
  );

  static const TextStyle onBoardingViewSmallFontTitle = TextStyle(
    //color: Theme.of(context).colorScheme.onPrimary,
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Raleway',
  );

  static const TextStyle whiteColorText = TextStyle(
    color: Colors.white,
    fontFamily: 'Raleway',
  );

  static const TextStyle indexText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: 'Raleway',
  );

  static const TextStyle questionText = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 20,
    color: Colors.white, // Text color
  );

  static TextStyle questionTextSubTitle = TextStyle(
    fontSize: 14,
    fontFamily: 'Raleway',
    color: Colors.white.withOpacity(0.8), // Text color
  );

  static const TextStyle submitbutton = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: 'Raleway', // Text color
  );

  static const TextStyle skipButtonTextRecommendationView = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontFamily: 'Raleway', // Text color
  );

  static TextStyle watchListText = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    fontFamily: 'Raleway',
  );

  static TextStyle createNewText = TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Raleway',
      color: const Color(0xFF3158CE));

  static TextStyle watchList1Text = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    fontFamily: 'Raleway',
  );

  static const TextStyle errorOccuredText = TextStyle(
    fontSize: 18,
    color: Colors.red,
    fontFamily: 'Raleway',
  );

  static TextStyle addNewTextWatlist = TextStyle(
    color: Colors.white.withOpacity(0.80),
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    fontFamily: 'Raleway',
  );

  static TextStyle remoteTextHomePage = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: 'Raleway',
    color: Colors.white,
  );

  static const TextStyle rowViewTitle = TextStyle(
    fontFamily: fontFamilyString,
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
  );

  static const TextStyle mediaHeaderTitle = TextStyle(
    fontFamily: fontFamilyString,
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
  );

  static const TextStyle mediaHeaderWatchLaterTitle = TextStyle(
      fontFamily: fontFamilyString,
      fontWeight: FontWeight.w300,
      fontSize: 20.0);

  static const TextStyle mediaHeaderAddToWatchListTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamilyString,
  );

  static const TextStyle mediaHeaderTitleText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamilyString,
  );

  static const TextStyle mediaHeaderTitleImageText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    fontFamily: fontFamilyString,
  );

  static const TextStyle mediaHeaderExpandableText = TextStyle(
    fontSize: 14,
    fontFamily: fontFamilyString,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle mediaHeaderActionButtonText = TextStyle(
    fontSize: 12,
    fontFamily: fontFamilyString,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle mediaIteTitle = TextStyle(
    fontSize: 16.0,
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamilyString,
  );

  static const TextStyle mediaRowTitle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      fontFamily: fontFamilyString);

  static const TextStyle mediaRowViewAllText = TextStyle(
    color: Colors.white,
    backgroundColor: Colors.transparent,
    fontFamily: fontFamilyString,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static const TextStyle profileNameText = TextStyle(
    color: Color(0xFFF2F2F2),
    fontSize: 24,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 0,
    letterSpacing: -0.40,
  );

  static const TextStyle profileMobileNo = TextStyle(
    color: Color(0xFFABABAB),
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 0,
  );

  static const TextStyle profileViewMainTitle = TextStyle(
    color: Color(0xFFF2F2F2),
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  static const TextStyle settingViewSubTitle = TextStyle(
    color: Color(0xFF8F8F8F),
    fontSize: 13,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 0,
  );

  static const TextStyle manageDevicesText = TextStyle(
    color: Color(0xFFE2E2E2),
    fontSize: 17,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 0,
  );

  static const TextStyle lastActiveManageDevicesText = TextStyle(
    color: Color(0xFF8F8F8F),
    fontSize: 13,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 0,
  );

  static const TextStyle logOutManageDevices = TextStyle(
    color: Color(0xFF5AC8F5),
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 0,
  );

  static const TextStyle devicesTitleManageDevices = TextStyle(
    color: Color(0xFFE2E2E2),
    fontSize: 17,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 0,
  );

  static TextStyle activateTvTitle = TextStyle(
    color: Colors.white.withOpacity(0.9599999785423279),
    fontSize: 17,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 0,
  );

  static const TextStyle activateTvSubTitle = TextStyle(
    color: Color(0xFF545454),
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 0,
  );

  static TextStyle activateTvCode = TextStyle(
    color: Colors.white.withOpacity(0.9599999785423279),
    fontSize: 24,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 0,
    letterSpacing: 4,
  );

  static const TextStyle signInOnTvText = TextStyle(
    color: Colors.black,
    fontSize: 17,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 0,
  );

  static const TextStyle signInOnTvCancelText = TextStyle(
    color: Colors.white,
    fontSize: 17,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 0,
  );
  static const TextStyle signInOnTvBottomText = TextStyle(
    color: Color(0xFF545454),
    fontSize: 13,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle amazonPrimeInitialScreenTitle = TextStyle(
    color: Color(0xFFF2F2F2),
    fontSize: 21.07,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle amazonPrimeInitialScreenSubTitle = TextStyle(
    color: Color(0xFFE2E2E2),
    fontSize: 14.05,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );

  static const amazonPrimeActivateButton = TextStyle(
    color: Colors.black,
    fontSize: 14.92,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 0,
  );

  static const TextStyle amazonPrimeTermsAndConditionsText = TextStyle(
    color: Color(0xFFABABAB),
    fontSize: 11.41,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    letterSpacing: 0.18,
  );

  static const TextStyle amazonPrimeMyPlanActivateButton = TextStyle(
    color: Color(0xFFC7C7C7),
    fontSize: 14.05,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,

  );
  static const TextStyle liteWithDorTextPrime =TextStyle(
    color: Color(0xFF8F8F8F),
    fontSize: 11.41,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle amazonPrimeText =TextStyle(
  color: Color(0xFFE2E2E2),
  fontSize: 14.92,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w600,
  );
}

class FirebaseRemoteConfigKeys {
  static const String watchNowPeople = 'watch_now_people';
}
