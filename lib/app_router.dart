import 'dart:developer';

import 'package:dor_companion/mobile/amazon_prime_video_cx_journey/amazon_prime_activation_initial_page.dart';
import 'package:dor_companion/mobile/profile/language_screen/language_controller.dart';
import 'package:dor_companion/mobile/profile/profile_main_views.dart';
import 'package:dor_companion/mobile/screens/personalization_view.dart';
import 'package:dor_companion/mobile/screens/movie_detail_view.dart';
import 'package:dor_companion/screens/home_page.dart';
import 'package:dor_companion/screens/video_player_view.dart';
import 'package:dor_companion/widgets/video_player_live.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:showcaseview/showcaseview.dart';
import 'data/api/sensy_api.dart';
import 'data/models/search_suggestions.dart';
import 'web/screens/gen_ai_search_view.dart';
import 'data/models/languages.dart';
import 'data/models/models.dart';
import 'data/models/user_account.dart';
import 'injection/injection.dart';
import 'mobile/profile/language_screen/languages_view.dart';
import 'login_view/mobile_number_verify/login_view.dart';
import 'mobile/screens/media_detail_view.dart';
import 'onboarding_view/onboarding_view.dart';
import 'mobile/screens/personalization_view.dart';
import 'mobile/profile/profile_creation_view.dart';
import 'mobile/profile/personalization_screen/edit_preference/profile_modification_view.dart';
import 'mobile/profile/profile_views.dart' as mobile_profile_views;
import 'mobile/screens/remote_view.dart';
import 'mobile/profile/settings_view.dart';
import 'mobile/screens/splash_view.dart';
import 'mobile/screens/support_view.dart';
import 'responsive.dart';

import 'web/screens/login_view.dart' as web_login_view;
import 'web/screens/media_detail_view.dart' as web_media_detail_view;
import 'web/screens/personalization_view.dart' as web_personalization_view;
import 'web/screens/profile_creation_view.dart' as web_profile_creation_view;
import 'web/screens/profile_modification_view.dart' as web_profile_mod_view;
import 'web/screens/profile_views.dart' as web_profile_views;

@lazySingleton
class AppRouter extends GoRouter {
  AppRouter(UserAccount userAccount)
      : super(
          refreshListenable: userAccount,
          debugLogDiagnostics: true,
          routes: <GoRoute>[
            !userAccount.isCompletedOnboarding() ?
             GoRoute(
              path: '/',
              name: 'home',
              builder: (BuildContext context, GoRouterState state) =>
                   ShowCaseWidget(
                      blurValue: 1,
                      builder: (context) =>  HomePage(),
                      autoPlayDelay: const Duration(seconds: 3),
                     ),
            ):  GoRoute(
              path: '/',
              name: 'home',
              builder: (BuildContext context, GoRouterState state) =>  HomePage(),
            ),
            GoRoute(
                path: '/splash',
                builder: (BuildContext context, GoRouterState state) =>
                    const SplashView()),
            GoRoute(
              path: '/onBoarding',
              builder: (BuildContext context, GoRouterState state) {
                return const OnBoardingView();
              },
            ),
            GoRoute(
              path: '/login',
              builder: (BuildContext context, GoRouterState state) =>
                  ResponsiveWidget.isSmallScreen(context)
                      ? const LoginView()
                      : const web_login_view.LoginView(),
            ),
            GoRoute(
              path: '/profiles',
              builder: (BuildContext context, GoRouterState state) =>
                  ResponsiveWidget.isLargeScreen(context)
                      ? const web_profile_views.ProfileSelectionView()
                      : const mobile_profile_views.ProfileSelectionView(showEditButton: true,
                    isComingFromProfile: false,),
            ),
            GoRoute(
              path: '/profile/:profileId',
              builder: (BuildContext context, GoRouterState state) {
                final profIdString = state.pathParameters["profileId"];
                if (profIdString?.isEmpty ?? true) {
                  throw Exception("Invalid profile ID");
                }
                final profileId = int.parse(profIdString!);
                return kIsWeb
                    ? web_profile_mod_view.ProfileModificationView(
                        profileId: profileId)
                    : ProfileModificationView(profileId: profileId);
              },
            ),
            GoRoute(
              path: '/newProfile',
              builder: (BuildContext context, GoRouterState state) => kIsWeb
                  ? const web_profile_creation_view.ProfileCreationView()
                  : const ProfileCreationView(),
            ),
            GoRoute(
              path: '/languages',
              builder: (BuildContext context, GoRouterState state) =>
                  const LanguageView(),
            ),
            GoRoute(
              path: '/personalization',
              builder: (BuildContext context, GoRouterState state) =>
                  ResponsiveWidget.isLargeScreen(context)
                      ? const web_personalization_view.PersonalizationView()
                      : PersonalizationView(),
            ),
            // GoRoute(
            //   path: '/subscriptions',
            //   builder: (BuildContext context, GoRouterState state) =>
            //       const SubscriptionPlanView(),
            // ),
            // GoRoute(
            //     path: '/plans',
            //     builder: (BuildContext context, GoRouterState state) {
            //       final planData = state.extra as PlanData;
            //       final subscriptionPrices = planData.pricePoints;
            //       final id = planData.id;
            //       final idSlug = planData.slugId;
            //       debugPrint(
            //           "***************** plans : ${subscriptionPrices?.length}");
            //       if (subscriptionPrices != null) {
            //         return SelectSubscriptionPlan(
            //             subscriptionPlan: subscriptionPrices,
            //             id: id,
            //             idSlug: idSlug);
            //       }
            //       return const SelectSubscriptionPlan(
            //         subscriptionPlan: [],
            //         id: 0,
            //         idSlug: "",
            //       );
            //     }),
            GoRoute(
              path: '/settings',
              builder: (BuildContext context, GoRouterState state) =>
                  const SettingsView(),
            ),
            // GoRoute(
            //   path: '/genai',
            //   builder: (BuildContext context, GoRouterState state) {
            //   String  resultString = state.extra as String;
            //   return GenAISearchView( resultString:resultString,);
            //   }
            // ),
            GoRoute(
              path: '/genai',
              builder: (BuildContext context, GoRouterState state) => GenAISearchView(
                sensyApi: getIt<SensyApi>(),
                searchSuggestion: getIt<SearchSuggestions>(),
              ),
            ),
            GoRoute(
              path: '/support',
              builder: (BuildContext context, GoRouterState state) {
                return const SupportView();
              },
            ),
            GoRoute(
              path: '/movieDetail',
              builder: (BuildContext context, GoRouterState state) {
                final standardPromotion = state.extra as StandardPromotion?;
                log("message");
                log(standardPromotion?.image ?? "emty");

                if (standardPromotion != null) {
                  return MovieDetailView(
                    standardPromotion: standardPromotion,
                  );
                }
                throw Exception("Invalid Data");
              },
            ),
            GoRoute(
              path: '/detail/:itemType/:itemID',
              builder: (BuildContext context, GoRouterState state) {
                final itemType = state.pathParameters["itemType"];
                String? itemId = state.pathParameters["itemID"];
                if ((itemType?.isEmpty ?? true) || (itemId?.isEmpty ?? true)) {
                  throw Exception("Invalid itemType and itemID");
                }
                itemId = MediaItem.getItemIDFromURLParam(itemId!);
                print("----------runtimeType-------------");
                print(state.extra.runtimeType);
                print("----------runtimeType-------------");
                MediaHeader? header;
                if(state.extra.runtimeType == MediaHeader){
                  header = state.extra as MediaHeader?;
                }else{
                  header = state.extra == null ? null : MediaHeader.fromJson(state.extra as Map<String, dynamic>);
                }
                return ResponsiveWidget.isLargeScreen(context)
                    ? web_media_detail_view.MediaDetailView(
                        itemType: itemType!,
                        itemId: itemId,
                        header: header,
                      )
                    : MediaDetailView(
                        itemType: itemType!,
                        itemId: itemId,
                        header: header,
                      );
              },
            ),
            GoRoute(
              path: '/remote/:deviceId',
              builder: (BuildContext context, GoRouterState state) {
                final deviceId = state.pathParameters["deviceId"];
                if (deviceId?.isEmpty ?? true) {
                  throw Exception("Invalid Device ID for RemoteView");
                }
                return RemoteView(deviceId: deviceId!);
              },
            ),
            GoRoute(
              name: 'video',
              path: '/video',
              builder: (BuildContext context, GoRouterState state) {
                Map? data = state.extra as Map?;
                final videoAction = data?['action'];
                final mediaItem = data?['mediaItem'];
                if (videoAction == null) {
                  throw Exception("videoAction was null");
                }
                return VideoPlayerView(videoAction: videoAction,mediaItem: mediaItem);
              },
            ),
            GoRoute(
              path: '/amazonSubscription',
              builder: (BuildContext context, GoRouterState state) {
                final data = state.extra as ChatActionMeta;
                return AmazonPrimeInitialScreen(chatAction: data, context: context,);
              },
            ),
            GoRoute(
              path: '/videoLiveNews',
              builder: (BuildContext context, GoRouterState state) {
                Map? data = state.extra as Map?;
                final url = data?['url'];
                final title = data?['title'];
                if (url == null) {
                  throw Exception("video url was null");
                }
                return VideoPlayerLiveNewsView(url: url,title: title);
              },
            ),
          ],
          // observers: [NewRelicNavigationObserver()],
          redirect: (context, state) {
            final languages = getIt<FavoriteLanguagesChangeNotifier>();
            final languageController = Get.put(LanguageController());

            final isInitialized = userAccount.isInitialized();
            final isGoingToSplash = state.matchedLocation == "/splash";

            final isCompletedOnBoarding = userAccount.isCompletedOnboarding();
            final isGoingToOnBoardingView =
                state.matchedLocation == "/onBoarding";

            final isLoggedIn = userAccount.isLoggedIn();
            final isGoingToLoginView = state.matchedLocation == "/login";

            final isProfileLoaded = userAccount.isProfileLoaded();
            final isGoingToProfileSelection =
                state.matchedLocation == "/profiles";

            final isLanguageSet = languages.getFavoriteLanguages().isNotEmpty;
            final isGoingToLanguages = state.matchedLocation == "/languages";

            final isProfilePersonalized = userAccount.isPersonalized();
            final isGoingToPersonalization =
                state.matchedLocation == "/languages" ||
                    state.matchedLocation == "/personalization";

            // final isSubscribed = userAccount.isSubscribed();
            // final isGoingToSubscriptionsView =
            //     state.matchedLocation == "/subscriptions" ||
            //         state.matchedLocation == "/plans" ||
            //         state.matchedLocation == '/' ||
            //         state.matchedLocation.contains("/detail/plan");

            final isDetailShow = userAccount.isOnHome();

            if (!isInitialized && !isGoingToSplash) {
              userAccount.setCurrentRoute(state.matchedLocation);
              return "/splash";

            } else if (!isInitialized && isGoingToSplash) {
              return null;
            }
            // else if (isInitialized && userAccount.currentRoute != null) {
            //   String? route = userAccount.currentRoute;
            //   userAccount.setCurrentRoute(null);
            //   return route;
            // }
            else if (isInitialized && isGoingToSplash) {
             // return "/";
            }
            // else if (!isCompletedOnBoarding && !isGoingToOnBoardingView) {
            //   return "/onBoarding";
            // }
            else if (!isCompletedOnBoarding && isGoingToOnBoardingView) {
              return null;
            } else if (isCompletedOnBoarding && isGoingToOnBoardingView) {
              return "/";
            } else if (!isLoggedIn && !isGoingToLoginView) {
              return "/login";
            } else if (!isLoggedIn && isGoingToLoginView) {
              return null;
            } else if (isLoggedIn && isGoingToLoginView) {
              return "/";
            }
            else if(state.matchedLocation == '/newProfile' || state.matchedLocation.startsWith('/profile/')){
              return null;
            }
            else if (!isProfileLoaded && !isGoingToProfileSelection) {
              return "/profiles";
            }
            else if (!isProfileLoaded && isGoingToProfileSelection) {
              return null;
            } else if (!isLanguageSet && !isGoingToLanguages) {
              return "/languages";
            } else if (isGoingToLanguages) {
              return null;
            } else if (!isProfilePersonalized && !isGoingToPersonalization) {
              languageController.selectedIndex.value = 2;
              languageController.currentStep.value = 2;
              languageController.completionStatus.value =[true, true,true];
              return "/languages";
            } else if (!isProfilePersonalized && isGoingToPersonalization) {
              return null;
            }
            // else if(!isSubscribed && isDetailShow){
            //   return "/subscriptions";
            // }else if (!isSubscribed && !isGoingToSubscriptionsView) {
            //   return "/subscriptions";
            // } else if (!isSubscribed && isGoingToSubscriptionsView) {
            //   return null;
            // }
            return null;
          },
        );
}
