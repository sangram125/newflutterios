// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
      channel_id: json['channel_id'] as String,
      channel_logo: json['channel_logo'] as String,
      channel_name: json['channel_name'] as String,
      channel_slug: json['channel_slug'] as String,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      language: json['language'] as String,
      lowercase_keywords: (json['lowercase_keywords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      playback_stream: json['playback_stream'] as String,
      process_stream: json['process_stream'] as String,
      summary: json['summary'] as String,
      timestamp: json['timestamp'] as String,
      topic: json['topic'] as String,
      transcript: json['transcript'] as String,
      words: (json['words'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'channel_id': instance.channel_id,
      'channel_logo': instance.channel_logo,
      'channel_name': instance.channel_name,
      'channel_slug': instance.channel_slug,
      'keywords': instance.keywords,
      'language': instance.language,
      'lowercase_keywords': instance.lowercase_keywords,
      'playback_stream': instance.playback_stream,
      'process_stream': instance.process_stream,
      'summary': instance.summary,
      'timestamp': instance.timestamp,
      'topic': instance.topic,
      'transcript': instance.transcript,
      'words': instance.words,
    };
