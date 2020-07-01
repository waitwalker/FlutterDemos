// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListModel _$OrderListModelFromJson(Map<String, dynamic> json) {
  return OrderListModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$OrderListModelToJson(OrderListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      courseCardId: json['courseCardId'] as num,
      courseCardName: json['courseCardName'] as String,
      subjectId: json['subjectId'] as num,
      gardId: json['gardId'] as num,
      activationTime: json['activationTime'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'courseCardId': instance.courseCardId,
      'courseCardName': instance.courseCardName,
      'subjectId': instance.subjectId,
      'gardId': instance.gardId,
      'activationTime': instance.activationTime
    };
