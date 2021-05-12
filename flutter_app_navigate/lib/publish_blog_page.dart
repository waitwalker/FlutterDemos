import 'package:flutter/material.dart';
import 'package:flutter_route_test/entity/blog_model.dart';

class PublishBlogPage extends StatefulWidget {

  final BlogModel blogModel;

  PublishBlogPage({this.blogModel});

  @override
  State createState() {
    return _PublishBlogState();
  }
}

class _PublishBlogState extends State<PublishBlogPage> {

  var titleController = TextEditingController();
  var contentController = TextEditingController();


  @override
  void initState() {
    super.initState();
    titleController.text = widget?.blogModel?.title ?? "";
    contentController.text = widget?.blogModel?.content ?? "";
  }

  @override
  Widget build(BuildContext context) {
    print('publish build');
    return Scaffold(
      appBar: AppBar(
        title: Text("发博客"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 10,),
              RaisedButton(
                child: Text("发表"),
                onPressed: (){
                  Navigator.pop(context,BlogModel(title:titleController.text,content: contentController.text));
                },
              ),
              SizedBox(width: 10,),
              RaisedButton(
                child: Text("关闭当前页面并返回结果"),
                onPressed: (){
//                  Navigator.of(context).pop();//关闭页面，不返回结果
                //可以返回任意数据类型
//                  Navigator.pop(context,"this is result");
//                  Navigator.pop(context,DateTime.now());
                  Navigator.pop(context,BlogModel(title:titleController.text,content: contentController.text));
                },
              ),
            ],
          ),
          TextFormField(
            maxLines: 1,
            controller:titleController ,
            decoration: InputDecoration(
              labelText: "标题",
              hintText: "请输入博客标题",
            ),
          ),
          TextFormField(
            minLines: 10,
            maxLines: 10,
            controller: contentController,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
                labelText: "博客内容",
                hintText:"输入博客内容，不得小于10个字",
            ),
          ),
        ],
      ),
    );
  }
}