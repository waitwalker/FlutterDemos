// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendModel _$RecommendModelFromJson(Map<String, dynamic> json) {
  return RecommendModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : RecommendData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$RecommendModelToJson(RecommendModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

RecommendData _$RecommendDataFromJson(Map<String, dynamic> json) {
  return RecommendData(
      aiActivationStatus: json['aiActivationStatus'] as num,
      aiRecommendId: json['aiRecommendId'] as num,
      aiCourseId: json['aiCourseId'] as num,
      versionId: json['versionId'] as num,
      aiSubjectId: json['aiSubjectId'] as num,
      aiName: json['aiName'] as String,
      aiTitle: json['aiTitle'] as String,
      aiSubtitle: json['aiSubtitle'] as String,
      zxActivationStatus: json['zxActivationStatus'] as num,
      zxRecommendId: json['zxRecommendId'] as num,
      zxFrom: json['zxFrom'] as String,
      resName: json['resName'] as String,
      resType: json['resType'] as num,
      courseCardId: json['courseCardId'] as num,
      zxName: json['zxName'] as String,
      zxTitle: json['zxTitle'] as String,
      zxSubtitle: json['zxSubtitle'] as String,
      liveStatus: json['liveStatus'] as num,
      gradeId: json['gradeId'] as num,
      subjectId: json['subjectId'] as num,
      liveUrl: json['liveUrl'] as String,
      nextLiveTime: json['nextLiveTime'] as String,
      liveName: json['liveName'] as String,
      liveTitle: json['liveTitle'] as String,
      liveSubtitle: json['liveSubtitle'] as String);
}

Map<String, dynamic> _$RecommendDataToJson(RecommendData instance) =>
    <String, dynamic>{
      'aiActivationStatus': instance.aiActivationStatus,
      'aiRecommendId': instance.aiRecommendId,
      'aiCourseId': instance.aiCourseId,
      'versionId': instance.versionId,
      'aiSubjectId': instance.aiSubjectId,
      'aiName': instance.aiName,
      'aiTitle': instance.aiTitle,
      'aiSubtitle': instance.aiSubtitle,
      'zxActivationStatus': instance.zxActivationStatus,
      'zxRecommendId': instance.zxRecommendId,
      'zxFrom': instance.zxFrom,
      'resName': instance.resName,
      'resType': instance.resType,
      'courseCardId': instance.courseCardId,
      'zxName': instance.zxName,
      'zxTitle': instance.zxTitle,
      'zxSubtitle': instance.zxSubtitle,
      'liveStatus': instance.liveStatus,
      'gradeId': instance.gradeId,
      'subjectId': instance.subjectId,
      'liveUrl': instance.liveUrl,
      'nextLiveTime': instance.nextLiveTime,
      'liveName': instance.liveName,
      'liveTitle': instance.liveTitle,
      'liveSubtitle': instance.liveSubtitle
    };
