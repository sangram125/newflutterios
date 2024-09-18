// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_cluster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListCluster _$ListClusterFromJson(Map<String, dynamic> json) => ListCluster(
      cluster: (json['cluster'] as List<dynamic>)
          .map((e) => Cluster.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListClusterToJson(ListCluster instance) =>
    <String, dynamic>{
      'cluster': instance.cluster,
    };
