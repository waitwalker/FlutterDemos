import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'app_update_check.g.dart';

@JsonSerializable()
class AppUpdateCheck extends BaseModel {
  UpdateData data;

  AppUpdateCheck({result, this.data, message}) : super(result, message);

  factory AppUpdateCheck.fromJson(Map<String, dynamic> json) =>
      _$AppUpdateCheckFromJson(json);

  Map<String, dynamic> toJson() => _$AppUpdateCheckToJson(this);
}

@JsonSerializable()
class UpdateData {
  int forceType;
  String title;
  String message;
  String url;

  UpdateData({this.forceType, this.title, this.message, this.url});

  factory UpdateData.fromJson(Map<String, dynamic> json) =>
      _$UpdateDataFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateDataToJson(this);
}
