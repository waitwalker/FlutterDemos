// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveDetailModel _$LiveDetailModelFromJson(Map<String, dynamic> json) {
  return LiveDetailModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LiveDetailModelToJson(LiveDetailModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      classId: json['classId'] as num,
      className: json['className'] as String,
      classType: json['classType'] as num,
      qqGroup: json['qqGroup'] as String,
      classQrCode: json['classQrCode'] as String,
      liveCourseResultDTOList: (json['liveCourseResultDTOList'] as List)
          ?.map((e) => e == null
              ? null
              : LiveCourseResultDTOListEntity.fromJson(
                  e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'classId': instance.classId,
      'className': instance.className,
      'classType': instance.classType,
      'qqGroup': instance.qqGroup,
      'classQrCode': instance.classQrCode,
      'liveCourseResultDTOList': instance.liveCourseResultDTOList
    };

LiveCourseResultDTOListEntity _$LiveCourseResultDTOListEntityFromJson(
    Map<String, dynamic> json) {
  return LiveCourseResultDTOListEntity(
      courseName: json['courseName'] as String,
      onlineCourseId: json['onlineCourseId'] as num,
      onlineCourseTitle: json['onlineCourseTitle'] as String,
      roomId: json['roomId'] as String,
      liveState: json['liveState'] as num,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      teacherName: json['teacherName'] as String,
      teacherPhoneUrl: json['teacherPhoneUrl'] as String,
      downloadStatus: json['downloadStatus'] as num);
}

Map<String, dynamic> _$LiveCourseResultDTOListEntityToJson(
        LiveCourseResultDTOListEntity instance) =>
    <String, dynamic>{
      'courseName': instance.courseName,
      'onlineCourseId': instance.onlineCourseId,
      'onlineCourseTitle': instance.onlineCourseTitle,
      'roomId': instance.roomId,
      'liveState': instance.liveState,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'teacherName': instance.teacherName,
      'teacherPhoneUrl': instance.teacherPhoneUrl,
      'downloadStatus': instance.downloadStatus
    };
