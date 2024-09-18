import 'package:json_annotation/json_annotation.dart';

part 'get_ticket_item_model.g.dart';

@JsonSerializable()
class NameList {
  final List<Name> data;

  NameList({required this.data});

  factory NameList.fromJson(Map<String, dynamic> json) => _$NameListFromJson(json);
  Map<String, dynamic> toJson() => _$NameListToJson(this);
}

Name deserializeName(Map<String, dynamic> json) =>
    Name.fromJson(json);

List<Name> deserializeNameList(List<Map<String, dynamic>> json) =>
    json.map((e) => Name.fromJson(e)).toList();

@JsonSerializable()
class Name {
  @JsonKey(name: 'name')
  final String name;

  Name({required this.name});

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);
  Map<String, dynamic> toJson() => _$NameToJson(this);
}
