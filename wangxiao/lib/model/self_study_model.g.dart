// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_study_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfStudyModel _$SelfStudyModelFromJson(Map<String, dynamic> json) {
  return SelfStudyModel(
      code: json['code'] as num,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      msg: json['msg'] as String);
}

Map<String, dynamic> _$SelfStudyModelToJson(SelfStudyModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      nodeId: json['nodeId'] as num,
      nodeName: json['nodeName'] as String,
      resourceIdList: (json['resourceIdList'] as List)
          ?.map((e) => e == null
              ? null
              : ResourceIdListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..children = (json['children'] as List)
        ?.map((e) =>
            e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..type = json['type'] as int;
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'nodeId': instance.nodeId,
      'nodeName': instance.nodeName,
      'resourceIdList': instance.resourceIdList,
      'children': instance.children,
      'type': instance.type
    };

ResourceIdListEntity _$ResourceIdListEntityFromJson(Map<String, dynamic> json) {
  return ResourceIdListEntity(
      cTime: json['cTime'] as String,
      clicks: json['clicks'] as num,
      diffType: json['diffType'] as num,
      downloadnum: json['downloadnum'] as num,
      fileSize: json['fileSize'] as num,
      fileSuffixname: json['fileSuffixname'] as String,
      fileType: json['fileType'] as num,
      grade: json['grade'] as num,
      mTime: json['mTime'] as String,
      netShareStatus: json['netShareStatus'] as num,
      reportnum: json['reportnum'] as num,
      resDegree: json['resDegree'] as num,
      resId: json['resId'] as num,
      resIntroduce: json['resIntroduce'] as String,
      resName: json['resName'] as String,
      resScore: json['resScore'] as num,
      resSource: json['resSource'] as num,
      resStatus: json['resStatus'] as num,
      resType: json['resType'] as num,
      shareStatus: json['shareStatus'] as num,
      storenum: json['storenum'] as num,
      subject: json['subject'] as num,
      totalShareStatus: json['totalShareStatus'] as num,
      userId: json['userId'] as num);
}

Map<String, dynamic> _$ResourceIdListEntityToJson(
        ResourceIdListEntity instance) =>
    <String, dynamic>{
      'cTime': instance.cTime,
      'clicks': instance.clicks,
      'diffType': instance.diffType,
      'downloadnum': instance.downloadnum,
      'fileSize': instance.fileSize,
      'fileSuffixname': instance.fileSuffixname,
      'fileType': instance.fileType,
      'grade': instance.grade,
      'mTime': instance.mTime,
      'netShareStatus': instance.netShareStatus,
      'reportnum': instance.reportnum,
      'resDegree': instance.resDegree,
      'resId': instance.resId,
      'resIntroduce': instance.resIntroduce,
      'resName': instance.resName,
      'resScore': instance.resScore,
      'resSource': instance.resSource,
      'resStatus': instance.resStatus,
      'resType': instance.resType,
      'shareStatus': instance.shareStatus,
      'storenum': instance.storenum,
      'subject': instance.subject,
      'totalShareStatus': instance.totalShareStatus,
      'userId': instance.userId
    };
