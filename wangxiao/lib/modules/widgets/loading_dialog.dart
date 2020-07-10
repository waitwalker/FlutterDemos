import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///
/// @name showLoadingDialog
/// @description 加载中组件
/// @parameters
/// @return
/// @author liuca
/// @date 2020-01-11
///
Future<Null> showLoadingDialog(BuildContext context,{String message = "加载中..."}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new Material(
            color: Colors.transparent,
            child: WillPopScope(
              onWillPop: () => new Future.value(false),
              child: Center(
                child: new Container(
                  width: 200.0,
                  height: 200.0,
                  padding: new EdgeInsets.all(4.0),
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    //用一个BoxDecoration装饰器提供背景图片
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          child: SpinKitDoubleBounce(color: Colors.white)),
                      new Container(height: 10.0),
                      new Container(child: new Text(message)),
                    ],
                  ),
                ),
              ),
            ));
      });
}


///
/// @name LoadingDialog
/// @description 加载中
/// @author liuca
/// @date 2020-01-11
///
class LoadingDialog extends Dialog {
  String text;

  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 120.0,
          height: 120.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
                new Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: new Text(
                    text,
                    style: new TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


///
/// @name UploadCompleteDialog
/// @description 上传进度
/// @author liuca
/// @date 2020-01-11
///
typedef void OnPress();
class UploadCompleteDialog extends Dialog {
  String text;
  OnPress onCancel, onContinue;

  UploadCompleteDialog(
      {Key key, @required this.text, this.onCancel, this.onContinue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
          decoration: ShapeDecoration(
            color: Color(0x00ffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
          ),
          child: buildDialog(),
        ),
      ),
    );
  }

  Widget buildDialog() {
    var old = Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(8.0),
            ),
          ),
        ),
        padding: EdgeInsets.fromLTRB(26, 0, 26, 18),
        height: 230,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 30,
              ),
              child: new Text(
                text,
                style: textStyleNormal666,
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                      child: Container(
                        child: Text('返回',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            )),
                        width: 115,
                        height: 39,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Colors.blue),
                        ),
                      ),
                      onTap: onCancel),
                  InkWell(
                      child: Container(
                        child: Text('继续传题',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            )),
                        width: 115,
                        height: 39,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      onTap: onContinue),
                ]),
          ],
        ));

    return Container(
      height: 230,
      width: 315,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.directional(
            start: 0,
            end: 0,
            top: 0,
            textDirection: TextDirection.ltr,
            child: Image.asset('static/images/errorbook_dialog.png', fit: BoxFit.fill,),
          ),
          Positioned.fill(
            top: 79,
            child: old,
          ),
          Column(children: <Widget>[]),
        ],
      ),
    );
  }
}
