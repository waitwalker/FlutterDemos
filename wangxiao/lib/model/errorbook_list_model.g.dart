// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'errorbook_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorbookListModel _$ErrorbookListModelFromJson(Map<String, dynamic> json) {
  return ErrorbookListModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ErrorbookListModelToJson(ErrorbookListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      currentPage: json['currentPage'] as num,
      pageSize: json['pageSize'] as num,
      totalCount: json['totalCount'] as num,
      totalPage: json['totalPage'] as num,
      list: (json['list'] as List)
          ?.map((e) =>
              e == null ? null : ListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      firstPage: json['firstPage'] as bool,
      lastPage: json['lastPage'] as bool);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'totalPage': instance.totalPage,
      'list': instance.list,
      'firstPage': instance.firstPage,
      'lastPage': instance.lastPage
    };

ListEntity _$ListEntityFromJson(Map<String, dynamic> json) {
  return ListEntity(
      wrongPhotoId: json['wrongPhotoId'] as num,
      subjectId: json['subjectId'] as num,
      subjectName: json['subjectName'] as String,
      gradeId: json['gradeId'] as num,
      gradeName: json['gradeName'] as String,
      photoUrl: json['photoUrl'] as String,
      wrongReason: json['wrongReason'] as String,
      uploadTime: json['uploadTime'] as String);
}

Map<String, dynamic> _$ListEntityToJson(ListEntity instance) =>
    <String, dynamic>{
      'wrongPhotoId': instance.wrongPhotoId,
      'subjectId': instance.subjectId,
      'subjectName': instance.subjectName,
      'gradeId': instance.gradeId,
      'gradeName': instance.gradeName,
      'photoUrl': instance.photoUrl,
      'wrongReason': instance.wrongReason,
      'uploadTime': instance.uploadTime
    };
