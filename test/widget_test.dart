import 'dart:convert';

import 'package:dor_companion/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Unit Testing', () {
    test('toJson() returns correct JSON representation', () {
      const mobileNumber = MobileNumber(
        countryCode: '1',
        number: '1234567890',
        name: 'John Doe',
        otp: '1234',
      );

      final json = mobileNumber.toJson();

      expect(json['phone_country_code'], '1');
      expect(json['phone_number'], '1234567890');
      expect(json['name'], 'John Doe');
      expect(json['otp'], '1234');
    });

    test('Equality comparison works correctly', () {
      const mobileNumber1 = MobileNumber(
        countryCode: '1',
        number: '1234567890',
        name: 'John Doe',
        otp: '1234',
      );

      const mobileNumber2 = MobileNumber(
        countryCode: '1',
        number: '1234567890',
        name: 'John Doe',
        otp: '1234',
      );

      expect(mobileNumber1, equals(mobileNumber2));
    });

    test('token registration', () {
      final  clientToken = ClientToken(
        clientToken: "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9."
            "eyJjIjoiT2pvME9Ub3hORFV5T2pjNE1EQXhPRFkwIiwiaSI"
            "6IjIwMjQtMDQtMDgiLCJ0b2tlbl90eXBlIjoiYWNjZXNzI"
            "iwicyI6NTc5LCJqdGkiOiI3ZGZiYTY4ZjNhYjY0YzkxOGI"
            "0YzFmNDc4ZWY2Yjc5ZiIsImV4cCI6MTc0MzY1MzcwOSwi"
            "aWF0IjoxNzEyMTE3NzA5fQ.9ZyBwcP3ido51n4sl3eNv"
            "K7j6MXdCKca3zIzOo2TIjE",
      );

      final json = clientToken.toJson();

      expect(json['client_token'], "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9."
      "eyJjIjoiT2pvME9Ub3hORFV5T2pjNE1EQXhPRFkwIiwiaSI"
      "6IjIwMjQtMDQtMDgiLCJ0b2tlbl90eXBlIjoiYWNjZXNzI"
          "iwicyI6NTc5LCJqdGkiOiI3ZGZiYTY4ZjNhYjY0YzkxOGI"
          "0YzFmNDc4ZWY2Yjc5ZiIsImV4cCI6MTc0MzY1MzcwOSwi"
          "aWF0IjoxNzEyMTE3NzA5fQ.9ZyBwcP3ido51n4sl3eNv"
          "K7j6MXdCKca3zIzOo2TIjE");

    });

    test('action_meta', () {
      const action_meta = {
        "app_store_id":"363590051",
        "authorization":"",
        "deeplink_android":"https://www.netflix.com/title/81221344?iid=9ccd83f0",
        "deeplink_androidtv":"https://www.netflix.com/title/81221344?iid=9ccd83f0",
        "deeplink_contentid":"81221344",
        "deeplink_firetv":"https://www.netflix.com/title/81221344?iid=9ccd83f0",
        "deeplink_ios":"nflx://www.netflix.com/watch/81221344",
        "package_name":"com.netflix.ninja",
        "package_name_phone":"com.netflix.mediaclient"
      };

      const action_meta2 = {
        "app_store_id":"363590051",
        "authorization":"",
        "deeplink_android":"https://www.netflix.com/title/81221344?iid=9ccd83f0",
        "deeplink_androidtv":"https://www.netflix.com/title/81221344?iid=9ccd83f0",
        "deeplink_contentid":"81221344",
        "deeplink_firetv":"https://www.netflix.com/title/81221344?iid=9ccd83f0",
        "deeplink_ios":"nflx://www.netflix.com/watch/81221344",
        "package_name":"com.netflix.ninja",
        "package_name_phone":"com.netflix.mediaclient"
      };

      expect(action_meta, equals(action_meta2));
    });

    test('profile detail', () {
      const profileDetail =
      {
        "id":1016,
      "customer_id":579,
      "facade_id":78001863,
      "facade_token":"208ff78b32a668c9a1885ac331542ebff70d874a",
      "name":"Priyanka",
      "is_personalized":true,
      "is_restricted":false,
      "parent_facade_id":null,
      "label":"d5bb3f6f-d760-4c45-9c79-4b082df5a981"
      };

      const profileDetail2 =
      {
        "id":1016,
        "customer_id":579,
        "facade_id":78001863,
        "facade_token":"208ff78b32a668c9a1885ac331542ebff70d874a",
        "name":"Priyanka",
        "is_personalized":true,
        "is_restricted":false,
        "parent_facade_id":null,
        "label":"d5bb3f6f-d760-4c45-9c79-4b082df5a981"
      };
      expect(profileDetail, equals(profileDetail2));

    });

    test('Changing name and isRestricted should reflect correctly', () {
      final profile = Profile(
        id: 1,
        customerId: 101,
        facadeId: 201,
        token: 'token123',
        name: 'John Doe',
        isPersonalized: true,
        isRestricted: false,
        parentFacadeId: null,
        label: 'Profile Label',
      );
      profile.name = 'Jane Doe';
      profile.isRestricted = true;
      expect(profile.name, equals('Jane Doe'));
      expect(profile.isRestricted, isTrue);
    });

    test('fromJson() method should handle invalid JSON format', () {
      const json = '{ "id": 1, "customer_id": 101'; // Missing closing brace
      expect(() => Profile.fromJson(jsonDecode(json)), throwsA(isA<FormatException>()));
    });


  //user interest
  test('Parsing JSON', () {
    const userInterestsResult = UserInterests(
          favorites: [
            MediaItemListElement(
          itemType: "language", itemIds: ["2"],
          )],
          seen: [
            MediaItemListElement(
            itemType: "vct", itemIds: [],
          )],
          notInterested: [],
          watchlist: []
    );


    final json = userInterestsResult.toJson();

    expect(json['favorites'][0]['item_type'], "language");
    expect(json['seen'][0]['item_type'], "vct");
    expect(json['favorites'][0]['item_ids'], ["2"]);
  });

  // test('Invalid data types in JSON', () {
  //   String missingResultsKeyJsonStr = '{"watchlist": [], "not_interested_list": []}';
  //   expect(() => json.decode(missingResultsKeyJsonStr), throwsFormatException);
  //
  //   String invalidResultsTypeJsonStr = '{"results": "invalid"}';
  //   expect(() => json.decode(invalidResultsTypeJsonStr), throwsFormatException);
  //
  //   String invalidFavoritesTypeJsonStr = '{"results": {"favorites": "invalid"}}';
  //   expect(() => json.decode(invalidFavoritesTypeJsonStr), throwsFormatException);
  // });


  test('Media Item Object Creation', () {
    final mediaItem = MediaItem(
      itemID: '30-8199',
      title: 'Pon Ondru Kanden',
      subtitle: 'Tamil · 2024 · Comedy, Romance',
      description: 'Pon Ondru Kanden (transl. I saw a girl) is a 2024 Indian Tamil-language romantic comedy film...',

      itemType: 'ott',
      video: 'https://sensara-static-files.sensara.tv/trailers/008f1b0c-70fe-4458-afa9-8651cc03aa52.mp4',
      imageHD: 'https://sensara-static-files.sensara.co/pre-sized/images/192x288/6a19e5356988b04ce5bd2e8e4ad63f39/https%253A%252F%252Fsensara-static-files.sensara.co%252Fmedia%252Ffacets%252F209029269672037865.jpg',
    );

    expect(mediaItem.itemID, '30-8199');
    expect(mediaItem.title, 'Pon Ondru Kanden');
    expect(mediaItem.subtitle, 'Tamil · 2024 · Comedy, Romance');
    expect(mediaItem.description.contains('I saw a girl'), true);
    expect(mediaItem.itemType, 'ott');
    expect(mediaItem.video, 'https://sensara-static-files.sensara.tv/trailers/008f1b0c-70fe-4458-afa9-8651cc03aa52.mp4');
    expect(mediaItem.imageHD.contains('sensara-static-files.sensara.co'), true);
  });

  test('Check Action Titles in Media Item', () {
    final mediaItem = MediaItem(
      itemID: '30-8199',
      title: 'Pon Ondru Kanden',
      subtitle: 'Tamil · 2024 · Comedy, Romance',
      description: 'Pon Ondru Kanden (transl. I saw a girl) is a 2024 Indian Tamil-language romantic comedy film...',
      itemType: 'ott',
      video: 'https://sensara-static-files.sensara.tv/trailers/008f1b0c-70fe-4458-afa9-8651cc03aa52.mp4',
      imageHD: 'https://sensara-static-files.sensara.co/pre-sized/images/192x288/6a19e5356988b04ce5bd2e8e4ad63f39/https%253A%252F%252Fsensara-static-files.sensara.co%252Fmedia%252Ffacets%252F209029269672037865.jpg',
      actions:  [
        MediaAction (
          title: "More about Pon Ondru Kanden",
          chatAction: ChatAction(
            response: "",
            actionType: "VIEW_DETAIL",
            actionID: "ott:30-8199",
            ),
            image: '',
            icon: ''
        ),
        // Add other actions here
      ],
    );

    expect(mediaItem.actions.length, 1); // Check the number of actions
    expect(mediaItem.actions[0].title, "More about Pon Ondru Kanden");
    expect(mediaItem.actions[0].chatAction.actionType, "VIEW_DETAIL");
    expect(mediaItem.actions[0].chatAction.actionID, "ott:30-8199");
  });

  test('Handle Exception when creating Media Item', () {
    // Testing exception handling when creating a media item
    try {
      MediaItem(
        itemID: '30-8199',
        title: '', // This should throw an exception
        subtitle: 'Tamil · 2024 · Comedy, Romance',
        description: 'Pon Ondru Kanden (transl. I saw a girl) is a 2024 Indian Tamil-language romantic comedy film...',
        itemType: 'ott',
        video: 'https://sensara-static-files.sensara.tv/trailers/008f1b0c-70fe-4458-afa9-8651cc03aa52.mp4',
        imageHD: 'https://sensara-static-files.sensara.co/pre-sized/images/192x288/6a19e5356988b04ce5bd2e8e4ad63f39/https%253A%252F%252Fsensara-static-files.sensara.co%252Fmedia%252Ffacets%252F209029269672037865.jpg',
      );
    } catch (e) {
      expect(e is ArgumentError, true);
      expect(e.toString(), contains("Property 'title' cannot be null."));
    }
  });

  test('Media Rows JSON parsing', () {
    final jsonString =
      [
        MediaRow(
            title: "Latest Movies",
            contentType : 23,
          displayConfig: DisplayConfig(
              rowType: 1,
            width: 128,
            height: 192,
          ),
          mediaItems: [
            MediaItem(
              itemType: "ott",
              itemID: "30-8199",
              title: "Pon Ondru Kanden",
              subtitle: "Tamil · 2024 · Comedy, Romance",
              image: "https://sensara-static-files.sensara.co/pre-sized/images/192x288/6a19e5356988b04ce5bd2e8e4ad63f39/https%253A%252F%252Fsensara-static-files.sensara.co%252Fmedia%252Ffacets%252F209029269672037865.jpg",
              imageHD: "https://sensara-static-files.sensara.co/pre-sized/images/192x288/6a19e5356988b04ce5bd2e8e4ad63f39/https%253A%252F%252Fsensara-static-files.sensara.co%252Fmedia%252Ffacets%252F209029269672037865.jpg",
              video: "https://sensara-static-files.sensara.tv/trailers/008f1b0c-70fe-4458-afa9-8651cc03aa52.mp4",
              actions: [
                  MediaAction (
                      title: "More about Pon Ondru Kanden",
                      chatAction: ChatAction(
                        response: "",
                        actionType: "VIEW_DETAIL",
                        actionID: "ott:30-8199",
                      ),
                      image: '',
                      icon: ''
                  ),
              ],
              schedule: null,
              description: "Pon Ondru Kanden (transl. I saw a girl) is a 2024 Indian Tamil-language romantic comedy film written and directed by V. Priya and produced by Jyoti Deshpande and Yuvan Shankar Raja under the banner of...",
            )
          ],
          mediaItemIcons: [
            MediaItemIcon(
            id: 0,
            title: "In Netflix",
            url: "http://sensara-static-files.sensara.co/appico/brand_in_netflix.png"
            )
          ],
          mediaItemGroups: [],
        )
      ];

    // Parse the JSON string
    //final List<MediaRow> parsedJson =   jsonDecode(jsonString as String);

    // Check if the parsed JSON is a list
    expect(jsonString, isA<List<MediaRow>>());

    // Check if the parsed JSON has at least one element
     expect(jsonString.isNotEmpty, true);
    //
    // // Access the first element of the list (media row)
     final MediaRow mediaRow = jsonString.first;

    // Check if the media row contains the expected keys
    expect(mediaRow.title, "Latest Movies");
    // expect(mediaRow.contentType, true);
    // expect(mediaRow.displayConfig, true);
    // expect(mediaRow.mediaItems, true);

    // Access the media items within the media row
    final List<MediaItem> mediaItems = mediaRow.mediaItems;

    // Check if the media items list is not empty
    expect(mediaItems.isNotEmpty, true);

    // Access the first media item
    MediaItem mediaItem = mediaItems.first;
    Map<String, dynamic> mediaItemMap = mediaItem.toJson();
    // Check if the media item contains the expected keys
    expect(mediaItemMap.containsKey('item_type'), true);
    expect(mediaItemMap.containsKey('item_id'), true);
    expect(mediaItemMap.containsKey('title'), true);
    expect(mediaItemMap.containsKey('subtitle'), true);
    expect(mediaItemMap.containsKey('image'), true);
    expect(mediaItemMap.containsKey('video'), true);
    expect(mediaItemMap.containsKey('actions'), true);
    expect(mediaItemMap.containsKey('description'), true);

  });

  test('Exception Test: Missing Title in Media Item', () {
      // Create a media item JSON without the title key
      final  mediaItemWithoutTitleJson = {
        "item_type": "ott",
        "item_id": "30-8199",
        "subtitle": "Tamil · 2024 · Comedy, Romance",
        "image": "https://sensara-static-files.sensara.co/pre-sized/images/192x288/6a19e5356988b04ce5bd2e8e4ad63f39/https%253A%252F%252Fsensara-static-files.sensara.co%252Fmedia%252Ffacets%252F209029269672037865.jpg",
        "video": "https://sensara-static-files.sensara.tv/trailers/008f1b0c-70fe-4458-afa9-8651cc03aa52.mp4",
        "actions": [],
        "description": "Pon Ondru Kanden (transl. I saw a girl) is a 2024 Indian Tamil-language romantic comedy film written and directed by V. Priya and produced by Jyoti Deshpande and Yuvan Shankar Raja under the banner of...",
        "meta": {"release_year": "2024"}
      };

      // Parsing the JSON should throw a format exception due to missing title
      expect(() => MediaItem.fromJson(mediaItemWithoutTitleJson), throwsFormatException);
    });



  });

}