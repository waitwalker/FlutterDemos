// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDetailModel _$MessageDetailModelFromJson(Map<String, dynamic> json) {
  return MessageDetailModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MessageDetailModelToJson(MessageDetailModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      msgId: json['msgId'] as num,
      msgTitle: json['msgTitle'] as String,
      msgContent: json['msgContent'] as String,
      userMsgState: json['userMsgState'] as num,
      releaseTime: json['releaseTime'] as String,
      mtime: json['mtime'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'msgId': instance.msgId,
      'msgTitle': instance.msgTitle,
      'msgContent': instance.msgContent,
      'userMsgState': instance.userMsgState,
      'releaseTime': instance.releaseTime,
      'mtime': instance.mtime
    };
