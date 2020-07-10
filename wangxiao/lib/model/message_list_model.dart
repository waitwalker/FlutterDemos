import 'package:json_annotation/json_annotation.dart';
part 'message_list_model.g.dart';

@JsonSerializable()
class MessageListModel {
  num code;
  String msg;
  DataEntity data;
  MessageListModel({
    this.code,
    this.msg,
    this.data
  });

  factory MessageListModel.fromJson(Map<String, dynamic> json) => _$MessageListModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageListModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num currentPage;
  num pageSize;
  num totalCount;
  num totalPage;
  List<Message> list;
  bool firstPage;
  bool lastPage;
  DataEntity({
    this.currentPage,
    this.pageSize,
    this.totalCount,
    this.totalPage,
    this.list,
    this.firstPage,
    this.lastPage
  });

  factory DataEntity.fromJson(Map<String, dynamic> json) => _$DataEntityFromJson(json);
  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}

@JsonSerializable()
class Message {
  num msgId;
  String msgTitle;
  String msgContent;
  num userMsgState;
  String mtime;
  Message({
    this.msgId,
    this.msgTitle,
    this.msgContent,
    this.userMsgState,
    this.mtime
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$ListEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ListEntityToJson(this);
}