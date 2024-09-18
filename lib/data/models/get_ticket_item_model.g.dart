// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_ticket_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NameList _$NameListFromJson(Map<String, dynamic> json) => NameList(
      data: (json['data'] as List<dynamic>)
          .map((e) => Name.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NameListToJson(NameList instance) => <String, dynamic>{
      'data': instance.data,
    };

Name _$NameFromJson(Map<String, dynamic> json) => Name(
      name: json['name'] as String,
    );

Map<String, dynamic> _$NameToJson(Name instance) => <String, dynamic>{
      'name': instance.name,
    };
