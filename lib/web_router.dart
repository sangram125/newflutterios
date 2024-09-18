import 'dart:developer';

import 'package:dor_companion/mobile/profile/personalization_screen/edit_preference/profile_modification_view.dart';
import 'package:dor_companion/mobile/screens/personalization_view.dart';
import 'package:dor_companion/mobile/screens/movie_detail_view.dart';
import 'package:dor_companion/screens/video_player_view.dart';
import 'package:dor_companion/widgets/error_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'data/models/languages.dart';
import 'data/models/models.dart';
import 'data/models/user_account.dart';
import 'injection/injection.dart';
import 'login_view/mobile_number_verify/login_view.dart';
import 'mobile/profile/profile_creation_view.dart';
import 'mobile/profile/language_screen/languages_view.dart';
import 'mobile/screens/media_detail_view.dart';
import 'onboarding_view/onboarding_view.dart';
import 'mobile/profile/profile_views.dart' as mobile_profile_views;
import 'mobile/screens/remote_view.dart';
import 'mobile/profile/settings_view.dart';
import 'mobile/screens/splash_view.dart';
import 'mobile/screens/support_view.dart';
import 'responsive.dart';
import 'screens/home_page.dart';
import 'web/screens/login_view.dart' as web_login_view;
import 'web/screens/media_detail_view.dart' as web_media_detail_view;
import 'web/screens/personalization_view.dart' as web_personalization_view;
import 'web/screens/profile_creation_view.dart' as web_profile_creation_view;
import 'web/screens/profile_modification_view.dart' as web_profile_mod_view;
import 'web/screens/profile_views.dart' as web_profile_views;
// import 'web/screens/subscription_views.dart' as web_subscription_views;

@lazySingleton
class WebRouter extends GoRouter {
  WebRouter(UserAccount userAccount)
      : super(
          refreshListenable: userAccount,
          debugLogDiagnostics: true,
          routes: <GoRoute>[
            GoRoute(
              path: '/',
              name: 'home',
              builder: (BuildContext context, GoRouterState state) =>
                   HomePage(),
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
                      ? web_profile_views.ProfileSelectionView(
                          key: UniqueKey(),
                        )
                      : mobile_profile_views.ProfileSelectionView(
                          key: UniqueKey()),
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
                      :  const PersonalizationView(),
            ),
            // GoRoute(
            //   path: '/subscriptions',
            //   builder: (BuildContext context, GoRouterState state) =>
            //       ResponsiveWidget.isLargeScreen(context)
            //           ? const web_subscription_views.SubscriptionPlanView()
            //           : const SubscriptionPlanView(),
            // ),
            // GoRoute(
            //     path: '/plans',
            //     builder: (BuildContext context, GoRouterState state) {
            //       final subscriptionPlan = state.extra as SubscriptionPlan;
            //       final subscriptionPrices = subscriptionPlan.price_points;
            //       final id = subscriptionPlan.id;
            //       final idSlug = subscriptionPlan.idSlug;
            //       debugPrint(
            //           "***************** plans : ${subscriptionPrices.length}");
            //       return ResponsiveWidget.isLargeScreen(context)
            //           ? web_subscription_plan.SelectSubscriptionPlan(
            //               subscriptionPrices: subscriptionPrices,
            //               id: id,
            //               idSlug: idSlug)
            //           : SelectSubscriptionPlan(
            //               subscriptionPlan: subscriptionPrices,
            //               id: id,
            //               idSlug: idSlug);
            //     }),
            GoRoute(
              path: '/settings',
              builder: (BuildContext context, GoRouterState state) =>
                  const SettingsView(),
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

                final header = state.extra as MediaHeader?;
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
              path: '/video',
              builder: (BuildContext context, GoRouterState state) {
                final videoAction = state.extra as ChatAction?;
                if (videoAction == null) {
                  throw Exception("videoAction was null");
                }
                return VideoPlayerView(videoAction: videoAction);
              },
            )
          ],
          errorBuilder: (context, state) =>
              CustomError(errorDetails: state.error.toString()),
          redirect: (context, state) {
            final languages = getIt<FavoriteLanguagesChangeNotifier>();

            final isInitialized = userAccount.isInitialized();
            print("ismatch ${state.matchedLocation}");
            print("isInit $isInitialized");
            final isGoingToSplash = state.matchedLocation == "/splash";

            final isCompletedOnBoarding = userAccount.isCompletedOnboarding();
            print("isOn $isCompletedOnBoarding");

            final isLoggedIn = userAccount.isLoggedIn();
            print("islog $isLoggedIn");
            final isGoingToLoginView = state.matchedLocation == "/login";

            final isProfileLoaded = userAccount.isProfileLoaded();
            print('App Router -- isProfileLoaded > $isProfileLoaded');
            final isGoingToProfileSelection =
                state.matchedLocation == "/profiles";
            print(
                'App Router -- isGoingToProfileSelection > $isGoingToProfileSelection');
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

            // if (!isInitialized && !isGoingToSplash) {
            //   print("hhhh ${state.matchedLocation}");
            //   // userAccount.setCurrentRoute(state.matchedLocation);
            //   return "/splash";
            // } else
            // if (!isInitialized && isGoingToSplash) {
            //   return null;
            // }
            // else if (isInitialized && userAccount.currentRoute != null) {
            //      print("current ${state.matchedLocation}");
            //   String? route = userAccount.currentRoute;
            //    print("currenttttt ${route}");
            //   userAccount.setCurrentRoute(null);
            //   return route;
            // } else
            // if (isInitialized && isGoingToSplash) {
            //   return "/";
            // } else
            //  if (!isCompletedOnBoarding && !isGoingToOnBoardingView) {
            //   return "/onBoarding";
            // } else if (!isCompletedOnBoarding && isGoingToOnBoardingView) {
            //   return null;
            // } else if (isCompletedOnBoarding && isGoingToOnBoardingView) {
            //   return "/";
            //} else
            if (!isInitialized) {
              return "/splash";
            } else if (!isLoggedIn && !isGoingToLoginView) {
              return "/login";
            } else if (!isLoggedIn && isGoingToLoginView) {
              return null;
            } else if (isLoggedIn && isGoingToLoginView) {
              return "/";
            } else if (!isProfileLoaded && !isGoingToProfileSelection) {
              return "/profiles";
            } else if (!isProfileLoaded && isGoingToProfileSelection) {
              return null;
            } else if (isProfileLoaded && isGoingToSplash && isLanguageSet) {
              return '/';
            } else if (!isLanguageSet && !isGoingToLanguages) {
              return "/languages";
            } else if (isGoingToLanguages) {
              return null;
            } else if (!isProfilePersonalized && !isGoingToPersonalization) {
              return "/personalization";
            } else if (!isProfilePersonalized && isGoingToPersonalization) {
              return null;
            }
            // else if (!isSubscribed && !isGoingToSubscriptionsView) {
            //   return "/";
            // } else if (!isSubscribed && isGoingToSubscriptionsView) {
            //   return null;
            // }
            return null;
          },
        );
}
