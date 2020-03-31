import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

import 'package:mifi_ui/utilities.dart';

class MifiImage extends StatefulWidget {
  final String image;
  final double width;
  final double height;
  final AnimationLoadCallback callback;

  MifiImage({
    Key key,
    this.image,
    this.width = 0.0,
    this.height,
    this.callback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MifiImageState();
  }
}

class MifiImageState extends State<MifiImage> {
 // ImageStreamListener _imageStreamListener;
  ImageProvider _imageProvider;
  double _imageHeight;

  @override
  void initState() {
    super.initState();
    _imageHeight = widget.height ?? 0.0;
   // _imageStreamListener = ImageStreamListener(_imageHeightListener);
  }

//  void _imageHeightListener(ImageInfo info, bool _) {
//    if (this.mounted) {
//      double newHeight = widget.width /
//          info.image.width.toDouble() *
//          info.image.height.toDouble();
//
//      if (widget.callback != null) {
//        log('yangcaiqin log 我要走回调啦, newHeight is $newHeight');
//        widget.callback(newHeight);
//      }
//      setState(() {
//        _imageHeight = newHeight;
//      });
//    }
//  }

  ImageProvider _getBgImageProvider() {
    if (_imageProvider == null) {
      ImageProvider imageProvider = ImageHelper.networkImage(widget.image,
          width: widget.width, context: context);

      ImageStream imageStream = imageProvider.resolve(ImageConfiguration());
      imageStream.addListener(ImageStreamListener((ImageInfo info, bool _) {
        if (this.mounted) {
          double newHeight = widget.width /
              info.image.width.toDouble() *
              info.image.height.toDouble();

          if (widget.callback != null) {
            //log('yangcaiqin log 我要走回调啦, newHeight is $newHeight');
            widget.callback(newHeight);
          }
          setState(() {
            if(widget.height == null) {
              //log('yangcaiqin log in _getBgImageProvider setState');
            }
            _imageProvider = imageProvider;
            _imageHeight = newHeight;
          });
        }
      }));

      return imageProvider;
//      imageStream.addListener(_imageStreamListener);
//      if (this.mounted) {
//       setState(() {
//          if(widget.height == null) {
//            log('yangcaiqin log in _getBgImageProvider 我是新的啦');
//          }
//          _imageProvider = imageProvider;
//        });
//      }
//      return imageProvider;
    } else {
      if(widget.height == null) {
        log('yangcaiqin log in _getBgImageProvider 我是旧的啦');
      }
      return _imageProvider;
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.height == null) {
      //log('yangcaiqin log in build _imageHeight is $_imageHeight');
    }
    return FadeInImage(
      placeholder:
          MemoryImage(image080001AF),
      image: _getBgImageProvider(),
      width: widget.width,
      height: widget.height ?? _imageHeight,
    );
  }
}
