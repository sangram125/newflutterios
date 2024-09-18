import 'package:json_annotation/json_annotation.dart';

import 'channel_model.dart';
 // Import the Channel class

part 'live_news_model.g.dart';
@JsonSerializable()
class Cluster {
  final List<Channel> channels;
  final int label;
  final int size;
  final String topic;

  Cluster({
    required this.channels,
    required this.label,
    required this.size,
    required this.topic,
  });

  factory Cluster.fromJson(Map<String, dynamic> json) => _$ClusterFromJson(json);

  Map<String, dynamic> toJson() => _$ClusterToJson(this);
}