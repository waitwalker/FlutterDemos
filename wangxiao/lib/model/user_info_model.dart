import 'package:json_annotation/json_annotation.dart';

part 'user_info_model.g.dart';

@JsonSerializable()
class UserInfoModel {
  num code;
  String msg;
  DataEntity data;

  UserInfoModel({this.code, this.msg, this.data});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num userId;
  String userName;
  String userPhoto;
  num sex;
  String birthday;
  num vipStatus;
  num bindingStatus;
  String address;
  String email;
  String realName;
  num autoType;
  num stateType;
  num gradeId;
  String mobile;
  num schoolType;

  DataEntity(
      {this.userId,
      this.userName,
      this.userPhoto,
      this.sex,
      this.birthday,
      this.vipStatus,
      this.bindingStatus,
      this.address,
      this.email,
      this.realName,
      this.autoType,
      this.stateType,
      this.gradeId,
      this.schoolType,
      this.mobile});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
