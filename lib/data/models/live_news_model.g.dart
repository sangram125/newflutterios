// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cluster _$ClusterFromJson(Map<String, dynamic> json) => Cluster(
      channels: (json['channels'] as List<dynamic>)
          .map((e) => Channel.fromJson(e as Map<String, dynamic>))
          .toList(),
      label: json['label'] as int,
      size: json['size'] as int,
      topic: json['topic'] as String,
    );

Map<String, dynamic> _$ClusterToJson(Cluster instance) => <String, dynamic>{
      'channels': instance.channels,
      'label': instance.label,
      'size': instance.size,
      'topic': instance.topic,
    };
