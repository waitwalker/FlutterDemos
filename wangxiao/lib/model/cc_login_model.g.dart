// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cc_login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CcLoginModel _$CcLoginModelFromJson(Map<String, dynamic> json) {
  return CcLoginModel(
      access_token: json['access_token'] as String,
      expiresIn: json['expiresIn'] as num,
      refresh_token: json['refresh_token'] as String,
      expiration: json['expiration'] as num);
}

Map<String, dynamic> _$CcLoginModelToJson(CcLoginModel instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'expiresIn': instance.expiresIn,
      'refresh_token': instance.refresh_token,
      'expiration': instance.expiration
    };
