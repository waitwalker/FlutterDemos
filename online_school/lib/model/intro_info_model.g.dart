// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intro_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntroInfoModel _$IntroInfoModelFromJson(Map<String, dynamic> json) {
  return IntroInfoModel(
      subjectId: json['subjectId'] as num,
      subject: json['subject'] as String,
      teacher: json['teacher'] as String,
      avatar: json['avatar'] as String,
      teacherDesc: json['teacherDesc'] as String,
      subjectDesc: json['subjectDesc'] as String,
      ai: (json['ai'] as List)
          ?.map((e) =>
              e == null ? null : ZxEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      zx: (json['zx'] as List)
          ?.map((e) =>
              e == null ? null : ZxEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      video: json['video'] as String);
}

Map<String, dynamic> _$IntroInfoModelToJson(IntroInfoModel instance) =>
    <String, dynamic>{
      'subjectId': instance.subjectId,
      'subject': instance.subject,
      'teacher': instance.teacher,
      'avatar': instance.avatar,
      'teacherDesc': instance.teacherDesc,
      'subjectDesc': instance.subjectDesc,
      'ai': instance.ai,
      'zx': instance.zx,
      'video': instance.video
    };

ZxEntity _$ZxEntityFromJson(Map<String, dynamic> json) {
  return ZxEntity(
      title: json['title'] as String,
      type: json['type'] as num,
      resId: json['resId'] as num,
      url: json['url'] as String,
      list: (json['list'] as List)
          ?.map((e) =>
              e == null ? null : ZxEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ZxEntityToJson(ZxEntity instance) => <String, dynamic>{
      'title': instance.title,
      'type': instance.type,
      'resId': instance.resId,
      'url': instance.url,
      'list': instance.list
    };
