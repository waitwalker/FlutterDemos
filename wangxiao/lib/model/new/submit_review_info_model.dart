
///
/// @name SubmitReviewInfoModel
/// @description 提交审核信息model
/// @author liuca
/// @date 2020-02-25
///
class SubmitReviewInfoModel {
  int code;
  String msg;
  Data data;

  SubmitReviewInfoModel({this.code, this.msg, this.data});

  SubmitReviewInfoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int stateId;
  String mobile;
  Infos infos;

  Data({this.stateId, this.mobile, this.infos});

  Data.fromJson(Map<String, dynamic> json) {
    stateId = json['stateId'];
    mobile = json['mobile'];
    infos = json['infos'] != null ? new Infos.fromJson(json['infos']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stateId'] = this.stateId;
    data['mobile'] = this.mobile;
    if (this.infos != null) {
      data['infos'] = this.infos.toJson();
    }
    return data;
  }
}

class Infos {
  String realName;
  int gradeId;
  String cityName;
  String schoolName;
  String imgUrl;
  int stateId;

  Infos(
      {this.realName,
        this.gradeId,
        this.cityName,
        this.schoolName,
        this.imgUrl,
        this.stateId});

  Infos.fromJson(Map<String, dynamic> json) {
    realName = json['realName'];
    gradeId = json['gradeId'];
    cityName = json['cityName'];
    schoolName = json['schoolName'];
    imgUrl = json['imgUrl'];
    stateId = json['stateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['realName'] = this.realName;
    data['gradeId'] = this.gradeId;
    data['cityName'] = this.cityName;
    data['schoolName'] = this.schoolName;
    data['imgUrl'] = this.imgUrl;
    data['stateId'] = this.stateId;
    return data;
  }
}