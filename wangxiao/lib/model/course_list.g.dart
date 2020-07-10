// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseList _$CourseListFromJson(Map<String, dynamic> json) {
  return CourseList(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CourseListToJson(CourseList instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      gradeId: json['gradeId'] as num,
      gradeName: json['gradeName'] as String,
      signUpType: json['signUpType'] as num,
      registerCourseList: (json['registerCourseList'] as List)
          ?.map((e) => e == null
              ? null
              : RegisterCourseListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'gradeId': instance.gradeId,
      'gradeName': instance.gradeName,
      'signUpType': instance.signUpType,
      'registerCourseList': instance.registerCourseList
    };

RegisterCourseListEntity _$RegisterCourseListEntityFromJson(
    Map<String, dynamic> json) {
  return RegisterCourseListEntity(
      registerCourseId: json['registerCourseId'] as num,
      registerCourseName: json['registerCourseName'] as String,
      subjectId: json['subjectId'] as num,
      registerCourseStartTime: json['registerCourseStartTime'] as String,
      registerCourseEndTime: json['registerCourseEndTime'] as String,
      classTime: json['classTime'] as String,
      signUp: json['signUp'] as num,
      source: json['source'] as num,
      classes: json['classes'] == null
          ? null
          : ClassesEntity.fromJson(json['classes'] as Map<String, dynamic>),
      courseList: (json['courseList'] as List)
          ?.map((e) => e == null
              ? null
              : CourseListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$RegisterCourseListEntityToJson(
        RegisterCourseListEntity instance) =>
    <String, dynamic>{
      'registerCourseId': instance.registerCourseId,
      'registerCourseName': instance.registerCourseName,
      'subjectId': instance.subjectId,
      'registerCourseStartTime': instance.registerCourseStartTime,
      'registerCourseEndTime': instance.registerCourseEndTime,
      'classTime': instance.classTime,
      'signUp': instance.signUp,
      'source': instance.source,
      'classes': instance.classes,
      'courseList': instance.courseList
    };

ClassesEntity _$ClassesEntityFromJson(Map<String, dynamic> json) {
  return ClassesEntity(
      classId: json['classId'] as num,
      className: json['className'] as String,
      classType: json['classType'] as num,
      qqGroup: json['qqGroup'] as String);
}

Map<String, dynamic> _$ClassesEntityToJson(ClassesEntity instance) =>
    <String, dynamic>{
      'classId': instance.classId,
      'className': instance.className,
      'classType': instance.classType,
      'qqGroup': instance.qqGroup
    };

CourseListEntity _$CourseListEntityFromJson(Map<String, dynamic> json) {
  return CourseListEntity(
      onlineCourseId: json['onlineCourseId'] as num,
      onlineCourseHour: json['onlineCourseHour'] as String,
      onlineCourseTitle: json['onlineCourseTitle'] as String,
      duration: json['duration'] as String,
      roomId: json['roomId'] as String,
      hasStudy: json['hasStudy'] as num,
      liveState: json['liveState'] as num,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String)
    ..parent = json['parent'] == null
        ? null
        : RegisterCourseListEntity.fromJson(
            json['parent'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CourseListEntityToJson(CourseListEntity instance) =>
    <String, dynamic>{
      'onlineCourseId': instance.onlineCourseId,
      'onlineCourseHour': instance.onlineCourseHour,
      'onlineCourseTitle': instance.onlineCourseTitle,
      'duration': instance.duration,
      'roomId': instance.roomId,
      'hasStudy': instance.hasStudy,
      'liveState': instance.liveState,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'parent': instance.parent
    };
