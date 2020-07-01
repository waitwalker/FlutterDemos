import 'package:json_annotation/json_annotation.dart';
part 'message_detail_model.g.dart';

@JsonSerializable()
class MessageDetailModel {
  num code;
  String msg;
  DataEntity data;
  MessageDetailModel({
    this.code,
    this.msg,
    this.data
  });

  factory MessageDetailModel.fromJson(Map<String, dynamic> json) => _$MessageDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageDetailModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num msgId;
  String msgTitle;
  String msgContent;
  num userMsgState;
  String releaseTime;
  String mtime;
  DataEntity({
    this.msgId,
    this.msgTitle,
    this.msgContent,
    this.userMsgState,
    this.releaseTime,
    this.mtime
  });

  factory DataEntity.fromJson(Map<String, dynamic> json) => _$DataEntityFromJson(json);
  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}