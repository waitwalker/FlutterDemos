// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveScheduleModel _$LiveScheduleModelFromJson(Map<String, dynamic> json) {
  return LiveScheduleModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LiveScheduleModelToJson(LiveScheduleModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      list: (json['list'] as List)
          ?.map((e) =>
              e == null ? null : ListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      classCode: json['classCode'] as String,
      coursewareUrl: json['coursewareUrl'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'list': instance.list,
      'classCode': instance.classCode,
      'coursewareUrl': instance.coursewareUrl
    };

ListEntity _$ListEntityFromJson(Map<String, dynamic> json) {
  return ListEntity(
      courseId: json['courseId'] as num,
      courseName: json['courseName'] as String,
      courseDesc: json['courseDesc'] as String,
      gradeId: json['gradeId'] as num,
      subjectId: json['subjectId'] as num,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      partnerName: json['partnerName'] as String,
      partnerRoomId: json['partnerRoomId'] as String,
      hdResourceId: json['hdResourceId'] as num,
      liveCourseId: json['liveCourseId'] as num,
      teacherId: json['teacherId'] as num,
      teacherName: json['teacherName'] as String,
      showName: json['showName'] as String,
      teacherType: json['teacherType'] as num,
      teacherIntroduce: json['teacherIntroduce'] as String,
      teacherPic: json['teacherPic'] as String,
      weekDay: json['weekDay'] as String,
      stateId: json['stateId'] as num,
      workStatus: json['workStatus'] as num);
}

Map<String, dynamic> _$ListEntityToJson(ListEntity instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'courseDesc': instance.courseDesc,
      'gradeId': instance.gradeId,
      'subjectId': instance.subjectId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'partnerName': instance.partnerName,
      'partnerRoomId': instance.partnerRoomId,
      'hdResourceId': instance.hdResourceId,
      'liveCourseId': instance.liveCourseId,
      'teacherId': instance.teacherId,
      'teacherName': instance.teacherName,
      'showName': instance.showName,
      'teacherType': instance.teacherType,
      'teacherIntroduce': instance.teacherIntroduce,
      'teacherPic': instance.teacherPic,
      'weekDay': instance.weekDay,
      'stateId': instance.stateId,
      'workStatus': instance.workStatus
    };
