// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      userId: json['userId'] as num,
      realName: json['realName'] as String,
      gradeId: json['gradeId'] as num,
      grade: json['grade'] as String,
      province: json['province'] as String,
      city: json['city'] as String,
      schoolId: json['schoolId'] as num,
      schoolName: json['schoolName'] as String,
      isOnlineCourseVip: json['isOnlineCourseVip'] as num,
      photoName: json['photoName'] as String,
      isFiveFour: json['isFiveFour'] as num,
      originGradeId: json['originGradeId'] as num,
      onlineCourseVipInfo: json['onlineCourseVipInfo'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'realName': instance.realName,
      'gradeId': instance.gradeId,
      'grade': instance.grade,
      'province': instance.province,
      'city': instance.city,
      'schoolId': instance.schoolId,
      'schoolName': instance.schoolName,
      'isOnlineCourseVip': instance.isOnlineCourseVip,
      'photoName': instance.photoName,
      'isFiveFour': instance.isFiveFour,
      'originGradeId': instance.originGradeId,
      'onlineCourseVipInfo': instance.onlineCourseVipInfo
    };
