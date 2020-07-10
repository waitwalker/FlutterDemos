// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveInfoModel _$LiveInfoModelFromJson(Map<String, dynamic> json) {
  return LiveInfoModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : LiveInfoDataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LiveInfoModelToJson(LiveInfoModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

LiveInfoDataEntity _$LiveInfoDataEntityFromJson(Map<String, dynamic> json) {
  return LiveInfoDataEntity(
      liveUserId: json['liveUserId'] as String,
      roomId: json['roomId'] as String,
      liveName: json['liveName'] as String,
      liveDesc: json['liveDesc'] as String,
      liveStartTime: json['liveStartTime'] as String,
      liveState: json['liveState'] as num,
      userId: json['userId'] as String,
      username: json['username'] as String,
      viewToken: json['viewToken'] as String,
      classInfo: json['classInfo'] == null
          ? null
          : ClassInfoEntity.fromJson(
              json['classInfo'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LiveInfoDataEntityToJson(LiveInfoDataEntity instance) =>
    <String, dynamic>{
      'liveUserId': instance.liveUserId,
      'roomId': instance.roomId,
      'liveName': instance.liveName,
      'liveDesc': instance.liveDesc,
      'liveStartTime': instance.liveStartTime,
      'liveState': instance.liveState,
      'userId': instance.userId,
      'username': instance.username,
      'viewToken': instance.viewToken,
      'classInfo': instance.classInfo
    };

ClassInfoEntity _$ClassInfoEntityFromJson(Map<String, dynamic> json) {
  return ClassInfoEntity(
      classId: json['classId'] as num,
      className: json['className'] as String,
      classType: json['classType'] as String,
      qqGroup: json['qqGroup'] as String);
}

Map<String, dynamic> _$ClassInfoEntityToJson(ClassInfoEntity instance) =>
    <String, dynamic>{
      'classId': instance.classId,
      'className': instance.className,
      'classType': instance.classType,
      'qqGroup': instance.qqGroup
    };
