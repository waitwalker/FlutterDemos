class ETTPDFModel {
  Data data;
  String msg;
  List<String> objList;
  Presult presult;
  String type;

  ETTPDFModel({this.data, this.msg, this.objList, this.presult, this.type});

  ETTPDFModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
    objList = json['objList'].cast<String>();
    presult =
    json['presult'] != null ? new Presult.fromJson(json['presult']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['msg'] = this.msg;
    data['objList'] = this.objList;
    if (this.presult != null) {
      data['presult'] = this.presult.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Data {
  String downloadUrL;
  String previewUrl;
  String presentationName;

  Data({this.downloadUrL, this.previewUrl, this.presentationName});

  Data.fromJson(Map<String, dynamic> json) {
    downloadUrL = json['downloadUrL'];
    previewUrl = json['previewUrl'];
    presentationName = json['presentationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['downloadUrL'] = this.downloadUrL;
    data['previewUrl'] = this.previewUrl;
    data['presentationName'] = this.presentationName;
    return data;
  }
}

class Presult {
  int firstRec;
  Jqgridcondition jqgridcondition;
  List<String> list;
  String orderBy;
  int pageNo;
  int pageSize;
  int pageTotal;
  int recTotal;
  String sort;

  Presult(
      {this.firstRec,
        this.jqgridcondition,
        this.list,
        this.orderBy,
        this.pageNo,
        this.pageSize,
        this.pageTotal,
        this.recTotal,
        this.sort});

  Presult.fromJson(Map<String, dynamic> json) {
    firstRec = json['firstRec'];
    jqgridcondition = json['jqgridcondition'] != null
        ? new Jqgridcondition.fromJson(json['jqgridcondition'])
        : null;
    list = json['list'].cast<String>();
    orderBy = json['orderBy'];
    pageNo = json['pageNo'];
    pageSize = json['pageSize'];
    pageTotal = json['pageTotal'];
    recTotal = json['recTotal'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstRec'] = this.firstRec;
    if (this.jqgridcondition != null) {
      data['jqgridcondition'] = this.jqgridcondition.toJson();
    }
    data['list'] = this.list;
    data['orderBy'] = this.orderBy;
    data['pageNo'] = this.pageNo;
    data['pageSize'] = this.pageSize;
    data['pageTotal'] = this.pageTotal;
    data['recTotal'] = this.recTotal;
    data['sort'] = this.sort;
    return data;
  }
}

class Jqgridcondition {
  String jQGridConditionString;
  List<String> rules;

  Jqgridcondition({this.jQGridConditionString, this.rules});

  Jqgridcondition.fromJson(Map<String, dynamic> json) {
    jQGridConditionString = json['JQGridConditionString'];
    rules = json['rules'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JQGridConditionString'] = this.jQGridConditionString;
    data['rules'] = this.rules;
    return data;
  }
}