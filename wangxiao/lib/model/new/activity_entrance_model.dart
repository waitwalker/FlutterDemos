class ActivityEntranceModel {
  int code;
  String msg;
  Data data;

  ActivityEntranceModel({this.code, this.msg, this.data});

  ActivityEntranceModel.fromJson(Map<String, dynamic> json) {
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
  String picture;
  String url;
  int isOpen;
  int tagType;

  Data({this.description, this.picture, this.url, this.isOpen, this.tagType});

  Data.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    picture = json['picture'];
    url = json['url'];
    isOpen = json['isOpen'];
    tagType = json['tagType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['picture'] = this.picture;
    data['url'] = this.url;
    data['isOpen'] = this.isOpen;
    data['tagType'] = this.tagType;
    return data;
  }
}