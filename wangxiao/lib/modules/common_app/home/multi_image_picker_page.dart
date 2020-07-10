import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CommonMultiImagePickerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonMultiImagePickerState();
  }
}

class _CommonMultiImagePickerState extends State<CommonMultiImagePickerPage> {

  List<Asset> images = List<Asset>();
  String _error = "No Error Dectected";

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(asset: asset, width: 300, height: 300);
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = "No Error Dectected";
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "多选",
          allViewTitle: "所有照片",
          useDetailsView: true,
          selectCircleStrokeColor: "#000000"
        ),
      );
    } on Exception catch(e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("导航跳转动画"),
      ),
      body: Column(
        children: <Widget>[
          Center(child: Text('Error: $_error')),
          RaisedButton(
            child: Text("Pick images"),
            onPressed: loadAssets,
          ),
          Expanded(
            child: buildGridView(),
          )
        ],
      ),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("图片多选"),
//      ),
//      body: Center(
//        child: Text("图片多选iOS和Swift冲突,暂未处理"),
//      ),
//    );
//  }
}