import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/common/tools/image_compress.dart';
import 'package:online_school/common/tools/timer_tool.dart';
import 'package:online_school/model/error_book_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/modules/widgets/loading_dialog.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:online_school/modules/widgets/setting_row.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/list_type_loading_placehold_widget.dart';
import 'edit_error_item_page.dart';
import 'errorbook_item_list_page.dart';
import 'errorbook_web_item_list_page.dart';
import 'package:redux/redux.dart';


///
/// @name ErrorBookSubjectListPage
/// @description 错题本学科列表页面
/// @author liuca
/// @date 2020-01-11
///
class ErrorBookSubjectListPage extends StatefulWidget {
  /// 显示拍照上传按钮
  bool showCamera;
  bool fromShuXiao;

  ErrorBookSubjectListPage({this.showCamera = false, this.fromShuXiao = false});

  @override
  State<StatefulWidget> createState() {
    return _ErrorBookSubjectListPageState();
  }
}

class _ErrorBookSubjectListPageState extends State<ErrorBookSubjectListPage> with WidgetsBindingObserver {
  AsyncMemoizer _memoizer = AsyncMemoizer();
  File croppedFile;
  TimerTool _timerTool;
  bool haveCameraPermission = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _startCountDown();
    requestCameraPermission();
    super.initState();
  }

  requestCameraPermission() async{
    /// 申请权限
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);

    /// 申请结果
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    if (permission == PermissionStatus.granted) {
      haveCameraPermission = true;
    } else {
      haveCameraPermission = false;
    }
  }

  ///
  /// @name 倒计时
  /// @description
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-01-15
  ///
  void _startCountDown() {
    _timerTool = TimerTool(mTotalTime: 24 * 60 * 60 * 1000);
    _timerTool.setOnTimerTickCallback((int tick) {

      if (SingletonManager.sharedInstance.errorBookCameraState == 1){
        setState(() {
          SingletonManager.sharedInstance.errorBookCameraState = 0;
          _memoizer = AsyncMemoizer();
        });
      } else if (SingletonManager.sharedInstance.errorBookCameraState == 2) {
        setState(() {
          SingletonManager.sharedInstance.errorBookCameraState = 0;
          _memoizer = AsyncMemoizer();
        });
        takePhoto();
      }

    });
    _timerTool.startCountDown();
  }

  takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    doCrop(image.path).then((f) {
      if (f == null) return;
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return EditErrorItemPage(image: croppedFile);
      })).then((value) => (){
        print("$value");
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerTool != null) _timerTool.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // went to Background
      print("回到后台");
    }
    if (state == AppLifecycleState.resumed) {
      // came back to Foreground
      print("回到前台");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store){
      String title = MTTLocalization.of(context).currentLocalized.error_book_page_navigator_title;
      if (widget.showCamera) {
        title = MTTLocalization.of(context).currentLocalized.error_book_page_upload_error_item;
      } else {
        if (widget.fromShuXiao) {
          title = MTTLocalization.of(context).currentLocalized.error_book_page_digital_campus_error_item;
        } else {
          title = MTTLocalization.of(context).currentLocalized.error_book_page_system_error_item;
        }
      }

      return Scaffold(
          appBar: AppBar(
            title: Text(title),
            elevation: 1.0,
            backgroundColor: Colors.white,
            centerTitle: Platform.isIOS ? true : false,
          ),
          body: Stack(alignment: Alignment.center, children: <Widget>[
            FutureBuilder(
              future: _getSubjectList(),
              builder: _builder,
            ),
            if (widget.showCamera)
              Positioned.directional(
                bottom: 20,
                textDirection: TextDirection.ltr,
                child: InkWell(
                    child: _buildCamera(),
                    onTap: () {
                      requestPermission();
                    }),
              ),
          ]));
    });

  }

  Future requestPermission() async {
    if (haveCameraPermission) {
      SingletonManager.sharedInstance.errorBookCameraState = 0;
      print("权限申请通过");
      var image = await ImagePicker.pickImage(source: ImageSource.camera);

      showLoadingDialog(context,message: "处理中...");
      if (image == null) {
        Navigator.pop(context);
      }

//      File compressedFile = await ImageCompressManager.compressImage(image);
//      int scaleImageSize = await compressedFile.length();
//      print("压缩图片的原生尺寸:${scaleImageSize / 1024.0 / 1024.0}MB");
//      if (compressedFile == null) {
//        Navigator.pop(context);
//      }

      doCrop(image.path).then((f) {
        Navigator.pop(context);
        if (f == null) return;
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return EditErrorItemPage(image: croppedFile);
        })).then((value) => (){
          print("$value");
        });
      });
    } else {
      print("权限申请被拒绝");
      Fluttertoast.showToast(msg: "请允许拍照权限后再重试");
    }
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


  Column _buildCamera() {
    return Column(children: <Widget>[
      Container(
          height: 56,
          width: 56,
          decoration: new BoxDecoration(
            color: Color(0xFF6B8DFF),
            //用一个BoxDecoration装饰器提供背景图片
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x66A1A1A1),
                  offset: Offset(0, -2),
                  blurRadius: 4.0,
                  spreadRadius: 0.0)
            ],
          ),
          child: Icon(MyIcons.CAMERA, color: Colors.white)),
      const SizedBox(height: 8),
      Text(MTTLocalization.of(context).currentLocalized.error_book_page_take_photo, style: TextStyle(fontSize: 10, color: Color(MyColors.black333))),
    ]);
  }

  _getSubjectList() =>
      _memoizer.runOnce(() => CourseDaoManager.errorBookList(widget.showCamera
          ? ErrorBookType.CAMERA
          : widget.fromShuXiao ? ErrorBookType.SHUXIAO : ErrorBookType.WEB));

  Widget _builder(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: LoadingListWidget(),
        );
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        var model = snapshot.data.model as ErrorBookModel;
        if (model?.data == null) {
          return EmptyPlaceholderPage(assetsPath: 'static/images/empty.png', message: MTTLocalization.of(context).currentLocalized.common_no_data);
        }
        if (model.code == 1 && model.data != null) {
          return _buildList(model.data);
        }
        return Expanded(child: Text('什么也没有呢'));
      // Text('Error: ${liveDetailModel.msg}');
      default:
        return EmptyPlaceholderPage(assetsPath: 'static/images/empty.png', message: MTTLocalization.of(context).currentLocalized.common_no_data);
    }
  }

  ///
  /// @name _onPressSubject
  /// @description 跳转到原生错题本详情
  /// @parameters
  /// @return
  /// @author lca
  /// @date 2019-12-20
  ///
  _onPressSubject(int subjectId) {
    print('PRESSED $subjectId');
    if (widget.showCamera) {
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (_) => ErrorBookItemListPage(subjectId: subjectId)))
          .then((_) {
        setState(() {
          _memoizer = AsyncMemoizer();
        });
      });
    } else {
      /// 跳转到网页错题本详情 数校和网校
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        var url = widget.fromShuXiao
            ? APIConst.errorBookShuXiao
            : APIConst.errorBook;
        var token = NetworkManager.getAuthorization();
        return ErrorbookWebItemListPage(
          initialUrl: '$url?token=$token&subjectid=$subjectId',
          subjectId: subjectId,
          fromShuXiao: widget.fromShuXiao,
        );
      }));
    }
  }

  _buildCount(int cnt) {
    return Container(
        child: Text('$cnt', style: textStyleHint),
        padding: EdgeInsets.only(right: 10));
  }

  _buildList(List<DataEntity> data) {
    return Column(
      children: <Widget>[
        ...data.map(_buildItem).expand((l) => l),
      ],
    );
  }

  List<Widget> _buildItem(DataEntity l) {
    return [
      Divider(height: 0.5, color: Colors.black12),
      SettingRow(
        l.subjectName,
        textStyle: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 16, color: Color(MyColors.black333)),
        icon: _subjectIdIconMapping(l.subjectId),
        rightCustomWidget: _buildCount(l.cnt),
        onPress: () => _onPressSubject(l.subjectId),
      ),
    ];
  }

  _subjectIdIconMapping(int sid) {
    switch (sid) {
      case 1:
        return MyIcons.SUBJECT_YUWEN;
      case 2:
        return MyIcons.SUBJECT_SHUXUE;
      case 3:
        return MyIcons.SUBJECT_YINGYU;
      case 4:
        return MyIcons.SUBJECT_WULI;
      case 5:
        return MyIcons.SUBJECT_HUAXUE;
      case 6:
        return MyIcons.SUBJECT_SHENGWU;
      case 7:
        return MyIcons.SUBJECT_ZHENGZHI;
      case 8:
        return MyIcons.SUBJECT_LISHI;
      case 9:
        return MyIcons.SUBJECT_DILI;
      default:
        return Icons.error;
    }
  }
}
