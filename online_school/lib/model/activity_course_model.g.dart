// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityCourseModel _$ActivityCourseModelFromJson(Map<String, dynamic> json) {
  return ActivityCourseModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ActivityCourseModelToJson(
        ActivityCourseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      gradeId: json['gradeId'] as num,
      gradeName: json['gradeName'] as String,
      signUpType: json['signUpType'] as String,
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
      subjectName: json['subjectName'] as String,
      registerCourseStartTime: json['registerCourseStartTime'] as String,
      registerCourseEndTime: json['registerCourseEndTime'] as String,
      courseContent: json['courseContent'] as String,
      classTime: json['classTime'] as String,
      signUp: json['signUp'] as num,
      source: json['source'] as String,
      classes: json['classes'] == null
          ? null
          : ClassesEntity.fromJson(json['classes'] as Map<String, dynamic>),
      overdueStatus: json['overdueStatus'] as num,
      courseCover: json['courseCover'] as String,
      courseList: (json['courseList'] as List)
          ?.map((e) => e == null
              ? null
              : CourseListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      teacherList: (json['teacherList'] as List)
          ?.map((e) => e == null
              ? null
              : TeacherListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..activityCourseSwitchStatus = json['activityCourseSwitchStatus'] as num;
}

Map<String, dynamic> _$RegisterCourseListEntityToJson(
        RegisterCourseListEntity instance) =>
    <String, dynamic>{
      'activityCourseSwitchStatus': instance.activityCourseSwitchStatus,
      'registerCourseId': instance.registerCourseId,
      'registerCourseName': instance.registerCourseName,
      'subjectId': instance.subjectId,
      'subjectName': instance.subjectName,
      'registerCourseStartTime': instance.registerCourseStartTime,
      'registerCourseEndTime': instance.registerCourseEndTime,
      'courseContent': instance.courseContent,
      'classTime': instance.classTime,
      'signUp': instance.signUp,
      'source': instance.source,
      'classes': instance.classes,
      'overdueStatus': instance.overdueStatus,
      'courseCover': instance.courseCover,
      'courseList': instance.courseList,
      'teacherList': instance.teacherList
    };

ClassesEntity _$ClassesEntityFromJson(Map<String, dynamic> json) {
  return ClassesEntity(
      classId: json['classId'] as num,
      className: json['className'] as String,
      classType: json['classType'] as num,
      qqGroup: json['qqGroup'] as String,
      classQrCode: json['classQrCode'] as String);
}

Map<String, dynamic> _$ClassesEntityToJson(ClassesEntity instance) =>
    <String, dynamic>{
      'classId': instance.classId,
      'className': instance.className,
      'classType': instance.classType,
      'qqGroup': instance.qqGroup,
      'classQrCode': instance.classQrCode
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
      endTime: json['endTime'] as String,
      reportState: json['reportState'] as num);
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
      'reportState': instance.reportState
    };

TeacherListEntity _$TeacherListEntityFromJson(Map<String, dynamic> json) {
  return TeacherListEntity(
      teacherId: json['teacherId'] as num,
      teacherName: json['teacherName'] as String,
      teacherType: json['teacherType'] as num,
      photoUrl: json['photoUrl'] as String,
      content: json['content'] as String);
}

Map<String, dynamic> _$TeacherListEntityToJson(TeacherListEntity instance) =>
    <String, dynamic>{
      'teacherId': instance.teacherId,
      'teacherName': instance.teacherName,
      'teacherType': instance.teacherType,
      'photoUrl': instance.photoUrl,
      'content': instance.content
    };
