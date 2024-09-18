import 'package:dor_companion/data/models/live_news_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_cluster.g.dart';

@JsonSerializable()
class ListCluster{
  final List<Cluster> cluster;
  ListCluster({
    required this.cluster
  });
  factory ListCluster.fromJson(Map<String, dynamic> json) => _$ListClusterFromJson(json);

  Map<String, dynamic> toJson() => _$ListClusterToJson(this);


}
ListCluster deserializeListCluster(Map<String, dynamic> json) =>
    ListCluster.fromJson(json);