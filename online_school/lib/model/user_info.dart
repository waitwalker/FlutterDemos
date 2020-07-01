import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  num code;
  String msg;
  DataEntity data;

  UserInfo({this.code, this.msg, this.data});

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable()
class DataEntity {
  num userId;
  String realName;
  num gradeId;
  String grade;
  String province;
  String city;
  num schoolId;
  String schoolName;
  num isOnlineCourseVip;
  String photoName;
  num isFiveFour;
  num originGradeId;
  String onlineCourseVipInfo;

  DataEntity(
      {this.userId,
      this.realName,
      this.gradeId,
      this.grade,
      this.province,
      this.city,
      this.schoolId,
      this.schoolName,
      this.isOnlineCourseVip,
      this.photoName,
      this.isFiveFour,
      this.originGradeId,
      this.onlineCourseVipInfo});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
