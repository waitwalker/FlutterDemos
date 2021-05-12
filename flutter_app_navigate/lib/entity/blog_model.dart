
import 'dart:convert';

class BlogModel{

  String title;
  String content;

  BlogModel({this.title, this.content});

  @override
  String toString() {
    var map = {
      "title":title,
      "content":content
    };
    return jsonEncode(map);
  }
}