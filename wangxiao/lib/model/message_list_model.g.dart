// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageListModel _$MessageListModelFromJson(Map<String, dynamic> json) {
  return MessageListModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MessageListModelToJson(MessageListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      currentPage: json['currentPage'] as num,
      pageSize: json['pageSize'] as num,
      totalCount: json['totalCount'] as num,
      totalPage: json['totalPage'] as num,
      list: (json['list'] as List)
          ?.map((e) =>
              e == null ? null : Message.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      firstPage: json['firstPage'] as bool,
      lastPage: json['lastPage'] as bool);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'totalPage': instance.totalPage,
      'list': instance.list,
      'firstPage': instance.firstPage,
      'lastPage': instance.lastPage
    };

Message _$ListEntityFromJson(Map<String, dynamic> json) {
  return Message(
      msgId: json['msgId'] as num,
      msgTitle: json['msgTitle'] as String,
      msgContent: json['msgContent'] as String,
      userMsgState: json['userMsgState'] as num,
      mtime: json['mtime'] as String);
}

Map<String, dynamic> _$ListEntityToJson(Message instance) =>
    <String, dynamic>{
      'msgId': instance.msgId,
      'msgTitle': instance.msgTitle,
      'msgContent': instance.msgContent,
      'userMsgState': instance.userMsgState,
      'mtime': instance.mtime
    };
