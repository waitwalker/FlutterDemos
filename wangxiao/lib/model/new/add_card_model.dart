
///
/// @name ETTAddCardModel
/// @description 加卡 model; App引流跳转过来
/// @author liuca
/// @date 2020-02-09
///
class ETTAddCardModel {
  int code;
  String msg;
  Data data;

  ETTAddCardModel({this.code, this.msg, this.data});

  ETTAddCardModel.fromJson(Map<String, dynamic> json) {
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
  String description;

  Data({this.description});

  Data.fromJson(Map<String, dynamic> json) {
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    return data;
  }
}