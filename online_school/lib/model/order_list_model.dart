import 'package:json_annotation/json_annotation.dart';

part 'order_list_model.g.dart';

@JsonSerializable()
class OrderListModel {
  num code;
  String msg;
  List<DataEntity> data;

  OrderListModel({this.code, this.msg, this.data});

  factory OrderListModel.fromJson(Map<String, dynamic> json) =>
      _$OrderListModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num courseCardId;
  String courseCardName;
  num subjectId;
  num gardId;
  String activationTime;

  DataEntity(
      {this.courseCardId,
      this.courseCardName,
      this.subjectId,
      this.gardId,
      this.activationTime});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
