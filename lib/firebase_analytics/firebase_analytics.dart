import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsEvent {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void logevent({required Map<String, dynamic> parameters, required String eventName}) async {

    await analytics.logEvent(
        parameters: parameters,
        name: eventName
    );
    print("log event ---${parameters}");
  }

  void scrollEvent(String screenName){

    logevent(
        parameters: {
      "screen_name" : screenName
    },
        eventName: "scroll_event");

  }

  void bannerClickEvent(String screenName){

    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "banner_click_event");

  }

  void exploreOTTEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "explore_ott_event");
  }

  void movieClickEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "movie_click_event");
  }

  void watchNowEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "watch_now_event");
  }

  void watchLaterEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "watch_later_event");
  }

  void addToFavoriteEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "add_to_favorite_event");
  }

  void shareEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "share_event");
  }
//live tv events
  void languageEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "language_event");
  }

  void filterEventLiveTv(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "filter_event");
  }
//profile screen events
  void switchProfileEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "switch_profile_event");
  }

  void editPreferenceEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "edit_preference_event");
  }
  void libraryEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "library_event");
  }

  void settingEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "setting_event");
  }

  void helpAndSupportEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "help_and_support_event");
  }

  void myRemoteEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "my_remote_event");
  }

  //update profile screen
  void changeProfileEvent(String screenName) {
    logevent(
        parameters: {
          "screen_name": screenName
        },
        eventName: "change_profile_event");
  }

    void editProfileEvent(String screenName){
      logevent(
          parameters: {
            "screen_name" : screenName
          },
          eventName: "edit_profile_event");
    }

  void addNewProfileEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "add_new_profile_event");
  }

  //media detail notification and search click
  void movieDetailNotificationEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "movie_detail_notification_event");
  }

  void movieDetailSearchEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "movie_detail_search_event");
  }

  void languagePreferenceEvent(String screenName){

    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "language_preference_event");

  }

  //home screen app bar
  void notificationEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "notification_event");
  }

  void searchEvent(String screenName){
    logevent(
        parameters: {
          "screen_name" : screenName
        },
        eventName: "search_event");
  }

}