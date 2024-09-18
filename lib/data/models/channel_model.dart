import 'package:json_annotation/json_annotation.dart';

part 'channel_model.g.dart';

@JsonSerializable()
class Channel {
  final String channel_id;
  final String channel_logo;
  final String channel_name;
  final String channel_slug;
  final List<String> keywords;
  final String language;
  final List<String> lowercase_keywords;
  final String playback_stream;
  final String process_stream;
  final String summary;
  final String timestamp;
  final String topic;
  final String transcript;
  final List<String> words;

  Channel({
    required this.channel_id,
    required this.channel_logo,
    required this.channel_name,
    required this.channel_slug,
    required this.keywords,
    required this.language,
    required this.lowercase_keywords,
    required this.playback_stream,
    required this.process_stream,
    required this.summary,
    required this.timestamp,
    required this.topic,
    required this.transcript,
    required this.words,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}