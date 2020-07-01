import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


///
/// @name ImageBrowseWidget
/// @description 图片浏览组件
/// @author liuca
/// @date 2020-01-11
///
class ImageBrowseWidget extends StatelessWidget {
  var image;
  ImageBrowseWidget({this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: GestureDetector(
                child: PhotoView(
                  imageProvider: NetworkImage(image),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                })));
  }
}
