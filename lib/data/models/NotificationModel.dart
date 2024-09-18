// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  Paging? paging;
  List<Content>? content;

  NotificationModel({
    this.paging,
    this.content,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        paging: Paging.fromJson(json["paging"]),
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "paging": paging!.toJson(),
        "content": List<dynamic>.from(content!.map((x) => x.toJson())),
      };
}

class Content {
  String? name;
  Channel? channel;
  Language? language;
  Sender? sender;
  Recipient? recipient;
  dynamic subtitle;
  String? subject;
  String? content;
  //Contact? contact;
  String? id;
  State? state;
  bool? isViewed;
  dynamic viewedOn;
  bool? isArchived;
  dynamic clickedOn;
  int? createdOn;
  dynamic inAppImageUrl;
  dynamic messageType;

  Content({
    this.name,
    this.channel,
    this.language,
    this.sender,
    this.recipient,
    this.subtitle,
    this.subject,
    this.content,
    // this.contact,
    this.id,
    this.state,
    this.isViewed,
    this.viewedOn,
    this.isArchived,
    this.clickedOn,
    this.createdOn,
    this.inAppImageUrl,
    this.messageType,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        name: json["name"],
        channel: channelValues.map[json["channel"]],
        language: languageValues.map[json["language"]],
        sender: senderValues.map[json["sender"]],
        recipient: recipientValues.map[json["recipient"]],
        subtitle: json["subtitle"] ?? "",
        subject: json["content"] ?? "",
        content: json["content"],
        //  contact: Contact.fromJson(json["contact"]),
        id: json["id"],
        state: stateValues.map[json["state"]],
        isViewed: json["is_viewed"],
        viewedOn: json["viewed_on"],
        isArchived: json["is_archived"],
        clickedOn: json["clicked_on"],
        createdOn: json["created_on"],
        inAppImageUrl: json["in_app_image_url"],
        messageType: json["message_type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "channel": channelValues.reverse[channel],
        "language": languageValues.reverse[language],
        "sender": senderValues.reverse[sender],
        "recipient": recipientValues.reverse[recipient],
        "subtitle": subtitle,
        "content": subject,
        "content": content,
        //  "contact": contact!.toJson(),
        "id": id,
        "state": stateValues.reverse[state],
        "is_viewed": isViewed,
        "viewed_on": viewedOn,
        "is_archived": isArchived,
        "clicked_on": clickedOn,
        "created_on": createdOn,
        "in_app_image_url": inAppImageUrl,
        "message_type": messageType,
      };
}

enum Channel { EMAIL, SMS }

final channelValues = EnumValues({"EMAIL": Channel.EMAIL, "SMS": Channel.SMS});

class Contact {
  String? id;
  Name? name;
  String? code;

  Contact({
    this.id,
    this.name,
    this.code,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: nameValues.map[json["name"]],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
        "code": code,
      };
}

enum Name { TEJUS_K }

final nameValues = EnumValues({"Tejus K": Name.TEJUS_K});

enum Language { EN }

final languageValues = EnumValues({"EN": Language.EN});

enum Recipient { THE_919886054744, VIKASTHOMBARE009_GMAIL_COM }

final recipientValues = EnumValues({
  "919886054744": Recipient.THE_919886054744,
  "vikasthombare009@gmail.com": Recipient.VIKASTHOMBARE009_GMAIL_COM
});

enum Sender { DOR_PLY, INFO_DORPLAY_TV }

final senderValues = EnumValues(
    {"DORPly": Sender.DOR_PLY, "Info@dorplay.tv": Sender.INFO_DORPLAY_TV});

enum State { COMPLETED }

final stateValues = EnumValues({"COMPLETED": State.COMPLETED});

class Paging {
  int? page;
  int? size;
  int? total;

  Paging({
    this.page,
    this.size,
    this.total,
  });

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
        page: json["page"],
        size: json["size"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "size": size,
        "total": total,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
