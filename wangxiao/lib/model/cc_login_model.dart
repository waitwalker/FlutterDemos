import 'package:json_annotation/json_annotation.dart';

part 'cc_login_model.g.dart';

@JsonSerializable()
class CcLoginModel {
  String access_token;
  num expiresIn;
  String refresh_token;
  num expiration;

  CcLoginModel(
      {this.access_token, this.expiresIn, this.refresh_token, this.expiration});

  factory CcLoginModel.fromJson(Map<String, dynamic> json) =>
      _$CcLoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$CcLoginModelToJson(this);
}
