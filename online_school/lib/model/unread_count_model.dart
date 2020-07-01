import 'package:json_annotation/json_annotation.dart';
part 'unread_count_model.g.dart';

@JsonSerializable()
class UnreadCountModel {
  num code;
  String msg;
  num data;
  UnreadCountModel({
    this.code,
    this.msg,
    this.data
  });

  factory UnreadCountModel.fromJson(Map<String, dynamic> json) => _$UnreadCountModelFromJson(json);
  Map<String, dynamic> toJson() => _$UnreadCountModelToJson(this);
}