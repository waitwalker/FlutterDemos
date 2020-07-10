import 'dart:async';
import 'dart:io';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/path_utils.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'edit_error_item_page.dart';


List<CameraDescription> cameras;


///
/// @name UploadCameraErrorItemPage
/// @description 通过拍照上传错题
/// @author liuca
/// @date 2020-01-11
///
class UploadCameraErrorItemPage extends StatefulWidget {
  @override
  _UploadCameraErrorItemPageState createState() => _UploadCameraErrorItemPageState();
}

class _UploadCameraErrorItemPageState extends State<UploadCameraErrorItemPage> {
  CameraController controller;

  File croppedFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _requestPermissionAndInitCamera();
  }

  /// Camera plugin's permission requestion has BUG!
  /// see https://github.com/flutter/flutter/issues/43266
  /// SO 我自己申请权限
  void _requestPermissionAndInitCamera() {
    // PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.contacts);
    _checkPermission().then((hasPer) {
      if (hasPer) {
        initCamera();
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                onWillPop: () => Future.value(false),
                child: AlertDialog(
                    title: new Text('提示'),
                    content: new Text('拍照上传错题，需要使用相机，请重试'),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('继续'),
                          onPressed: () {
                            // if (!wifi_only) {
                            Navigator.of(context).pop(true);
                            // }
                          }),
                      FlatButton(
                        child: Text('取消'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      )
                    ]),
              );
            }).then((agree) {
          if (agree) {
            _requestPermissionAndInitCamera();
          } else {
            Navigator.of(context).pop(false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    if (!(controller?.value?.isInitialized ?? false)) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(children: <Widget>[
          CameraPreview(controller),
          Positioned.directional(
              textDirection: TextDirection.ltr,
              start: 16,
              end: 16,
              bottom: 23,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                      child: ClipOval(
                          child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              color: Color(0XFFD8D8D8),
                              child: Icon(MyIcons.WRONG,
                                  color: Colors.white, size: 20))),
                      onTap: () {
                        Navigator.of(context).pop(false);
                      }),
                  InkWell(
                      child: ClipOval(
                          child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              color: Colors.blue,
                              child: Icon(MyIcons.RIGHT,
                                  color: Colors.white, size: 20))),
                      onTap: () async {
                        var imagePath = await getImagePath();
                        controller.takePicture(imagePath).then((_) {
                          doCrop(imagePath).then((f) {
                            if (f == null) return;
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (_) =>
                                        EditErrorItemPage(image: croppedFile)))
                                .then((exit) =>
                                    exit ? Navigator.of(context).pop(true) : null);
                          });
                        });
                      }),
                ],
              )),
        ]));
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    try {
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((e) {});
    } on Exception catch (e) {
      // TODO
    }
  }

  getImagePath() async {
    var dir = await getLocalPath('Pictures');
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    return '$dir/$time.jpg';
  }

  doCrop(String image) async {
    croppedFile = await ImageCropper.cropImage(
        sourcePath: image,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '剪切图片',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return croppedFile;
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.camera);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}
