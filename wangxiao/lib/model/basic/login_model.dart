import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel extends BaseModel {
  LoginData data;

  LoginModel({result, msg, this.data}) : super(result, msg);

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}

@JsonSerializable()
class LoginData {
  int jid;
  int isHorizontal;
  String userName;
  String photo;
  int childJid;
  int gradeId;
  String city;
  String tigasePwd;
  int uType;
  int childBind;
  String childName;
  int schoolId;
  String schoolName;
  int shouldComplete;
  String realName;
  int isFiveFour;
  int hasClass;
  int stuHasClass;
  int sex;
  String childCode;
  String liveLessonUrl;
  String onlineTestUrl;
  String vodLessonUrl;
  int squareFlag;
  int classCircleFlag;
  int hbhxFlag;
  String accessToken;
  String expires;
  List<Identity> identityList;

  LoginData(
      this.jid,
      this.isHorizontal,
      this.userName,
      this.photo,
      this.childJid,
      this.gradeId,
      this.city,
      this.tigasePwd,
      this.uType,
      this.childBind,
      this.childName,
      this.schoolId,
      this.schoolName,
      this.shouldComplete,
      this.realName,
      this.isFiveFour,
      this.hasClass,
      this.stuHasClass,
      this.sex,
      this.childCode,
      this.liveLessonUrl,
      this.onlineTestUrl,
      this.vodLessonUrl,
      this.squareFlag,
      this.classCircleFlag,
      this.hbhxFlag,
      this.accessToken,
      this.expires,
      this.identityList);

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class Identity {
  int type;
  int jid;

  Identity(this.type, this.jid);

  factory Identity.fromJson(Map<String, dynamic> json) =>
      _$IdentityFromJson(json);

  Map<String, dynamic> toJson() => _$IdentityToJson(this);
}
