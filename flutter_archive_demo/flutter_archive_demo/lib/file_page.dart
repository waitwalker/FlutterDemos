import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';

class FilePage extends StatefulWidget {

  final List <FileSystemEntity> fileEntityList;
  final String title;

  FilePage(this.fileEntityList,{this.title = "文件列表"});

  @override
  State<StatefulWidget> createState() {
    return _FileState();
  }
}

class _FileState extends State<FilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: ListView.builder(itemBuilder: _itemBuilder,itemCount: widget.fileEntityList.length,))
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    FileSystemEntity fileSystemEntity = widget.fileEntityList[index];

    if (fileSystemEntity != null) {
      String fileName = fileSystemEntity.path.split("/").last;
      return InkWell(
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Icon(fileSystemEntity is Directory ? Icons.folder : Icons.insert_drive_file,size: 40,color: fileSystemEntity is Directory ? Colors.lightBlue : Colors.deepOrangeAccent,),
                  Text(fileName,style: TextStyle(fontSize: 22),)
                ],
              ),
              Padding(padding: EdgeInsets.only(right: 20),child: Icon(Icons.arrow_forward_ios,color: Colors.lightBlue,size: 15,),),
            ],
          ),
        ),
        onTap: () async {
          // 文件夹
          if (fileSystemEntity is Directory) {
            final files = fileSystemEntity.listSync();
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return FilePage(files,title: fileName,);
            }));
          } else {
            // 文件
            final result = await OpenFile.open(fileSystemEntity.path);
            
            print("open result:$result}");
          }
        },
      );
    } else {
      return Container();
    }
  }


}