// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) {
  return LoginModel(
      result: json['result'],
      msg: json['msg'],
      data: json['data'] == null
          ? null
          : LoginData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'msg': instance.msg,
      'data': instance.data
    };

LoginData _$LoginDataFromJson(Map<String, dynamic> json) {
  return LoginData(
      json['jid'] as int,
      json['isHorizontal'] as int,
      json['userName'] as String,
      json['photo'] as String,
      json['childJid'] as int,
      json['gradeId'] as int,
      json['city'] as String,
      json['tigasePwd'] as String,
      json['uType'] as int,
      json['childBind'] as int,
      json['childName'] as String,
      json['schoolId'] as int,
      json['schoolName'] as String,
      json['shouldComplete'] as int,
      json['realName'] as String,
      json['isFiveFour'] as int,
      json['hasClass'] as int,
      json['stuHasClass'] as int,
      json['sex'] as int,
      json['childCode'] as String,
      json['liveLessonUrl'] as String,
      json['onlineTestUrl'] as String,
      json['vodLessonUrl'] as String,
      json['squareFlag'] as int,
      json['classCircleFlag'] as int,
      json['hbhxFlag'] as int,
      json['accessToken'] as String,
      json['expires'] as String,
      (json['identityList'] as List)
          ?.map((e) =>
              e == null ? null : Identity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'jid': instance.jid,
      'isHorizontal': instance.isHorizontal,
      'userName': instance.userName,
      'photo': instance.photo,
      'childJid': instance.childJid,
      'gradeId': instance.gradeId,
      'city': instance.city,
      'tigasePwd': instance.tigasePwd,
      'uType': instance.uType,
      'childBind': instance.childBind,
      'childName': instance.childName,
      'schoolId': instance.schoolId,
      'schoolName': instance.schoolName,
      'shouldComplete': instance.shouldComplete,
      'realName': instance.realName,
      'isFiveFour': instance.isFiveFour,
      'hasClass': instance.hasClass,
      'stuHasClass': instance.stuHasClass,
      'sex': instance.sex,
      'childCode': instance.childCode,
      'liveLessonUrl': instance.liveLessonUrl,
      'onlineTestUrl': instance.onlineTestUrl,
      'vodLessonUrl': instance.vodLessonUrl,
      'squareFlag': instance.squareFlag,
      'classCircleFlag': instance.classCircleFlag,
      'hbhxFlag': instance.hbhxFlag,
      'accessToken': instance.accessToken,
      'expires': instance.expires,
      'identityList': instance.identityList
    };

Identity _$IdentityFromJson(Map<String, dynamic> json) {
  return Identity(json['type'] as int, json['jid'] as int);
}

Map<String, dynamic> _$IdentityToJson(Identity instance) =>
    <String, dynamic>{'type': instance.type, 'jid': instance.jid};
