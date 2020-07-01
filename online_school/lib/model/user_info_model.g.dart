// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) {
  return UserInfoModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      userId: json['userId'] as num,
      userName: json['userName'] as String,
      userPhoto: json['userPhoto'] as String,
      sex: json['sex'] as num,
      birthday: json['birthday'] as String,
      vipStatus: json['vipStatus'] as num,
      bindingStatus: json['bindingStatus'] as num,
      address: json['address'] as String,
      email: json['email'] as String,
      realName: json['realName'] as String,
      autoType: json['autoType'] as num,
      stateType: json['stateType'] as num,
      gradeId: json['gradeId'] as num,
      schoolType: json['schoolType'] as num,
      mobile: json['mobile'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userPhoto': instance.userPhoto,
      'sex': instance.sex,
      'birthday': instance.birthday,
      'vipStatus': instance.vipStatus,
      'bindingStatus': instance.bindingStatus,
      'address': instance.address,
      'email': instance.email,
      'realName': instance.realName,
      'autoType': instance.autoType,
      'stateType': instance.stateType,
      'gradeId': instance.gradeId,
      'mobile': instance.mobile,
      'schoolType': instance.schoolType
    };
