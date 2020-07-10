import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

class CommonSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonSearchState();
  }
}

class _CommonSearchState extends State<CommonSearchPage> {

  MethodChannel _methodChannel = const MethodChannel("com.etiantian/flutter_channel");
  bool isProxy = false;
  bool isIOSCanDebug = true;
  bool isDeviceLongBright = false;
  @override
  void initState() {
    proxyValue();
    super.initState();
  }

  proxyValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String ip = sharedPreferences.getString("proxy_ip");
    bool _isIOSCanDebug = sharedPreferences.getBool("isIOSCanDebug");
    bool _isDeviceLongBright = sharedPreferences.getBool("isDeviceLongBright");
    if (ip != null && ip.length > 0) {
      setState(() {
        isProxy = true;
      });
    }

    if (_isDeviceLongBright != null) {
      setState(() {
        isDeviceLongBright = _isDeviceLongBright;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("搜索"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 20, right: 10),
            child: Container(
              height: 44,
              child: Row(
                children: <Widget>[
                  Text("代理"),
                  CupertinoSwitch(
                    activeColor: Color(0xFF52D257),
                    value: isProxy,
                    onChanged: (bool current) {
                      isProxy = current;
                      setState(() {
                        if (isProxy) {
                          var ipController = TextEditingController(text: SharedPrefsUtils.get('proxy_ip', ''));
                          var portController = TextEditingController(text: SharedPrefsUtils.get('proxy_port', ''));

                          Future.delayed(Duration(milliseconds: 500), () {
                            showCupertinoDialog<bool>(context: context, builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('设置代理'),
                                content: Material(
                                  color: Colors.transparent,
                                  child: Column(
                                    children: <Widget>[
                                      CupertinoTextField(
                                        prefix: Icon(Icons.computer, size: 16, color: Colors.grey),
                                        placeholderStyle: TextStyle(fontSize: 14),
                                        controller: ipController,
                                        placeholder: "电脑IP",
                                        keyboardType: TextInputType.url,
                                        suffix: InkWell(
                                          child: Icon(Icons.close, size: 16,),
                                          onTap: (){
                                            ipController.text = "";
                                          },
                                        ),
                                        suffixMode: OverlayVisibilityMode.editing,
                                        style: TextStyle(fontSize: 16),
                                        textAlignVertical: TextAlignVertical.center,
                                      ),
                                      SizedBox(height: 10,),
                                      CupertinoTextField(
                                        prefix: Icon(Icons.confirmation_number, size: 20, color: Colors.grey,),
                                        placeholderStyle: TextStyle(fontSize: 14),
                                        controller: portController,
                                        placeholder: "端口",
                                        keyboardType: TextInputType.number,
                                        suffix: InkWell(
                                          child: Icon(Icons.close, size: 16,),
                                          onTap: (){
                                            portController.text = "";
                                          },
                                        ),
                                        suffixMode: OverlayVisibilityMode.editing,
                                        style: TextStyle(fontSize: 16),
                                        textAlignVertical: TextAlignVertical.center,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  CupertinoButton(
                                    child: Text('设置'),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                  CupertinoButton(
                                    child: Text('取消'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                ],
                              );
                            },
                            ).then((b) {
                              if (b) {
                                var ip = ipController.text;
                                var port = portController.text;
                                SharedPrefsUtils.put('proxy_ip', ip);
                                SharedPrefsUtils.put('proxy_port', port);
                              }
                            });
                          });
                        } else {
                          SharedPrefsUtils.put('proxy_ip', "");
                          SharedPrefsUtils.put('proxy_port', "");
                        }
                      });
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
          ),

          Padding(padding: EdgeInsets.only(left: 20, right: 10),
            child: Container(
              height: 44,
              child: Row(
                children: <Widget>[
                  Text("Debug开关"),
                  CupertinoSwitch(
                    activeColor: Color(0xFF52D257),
                    value: isIOSCanDebug,
                    onChanged: (bool current) async {
                      isIOSCanDebug = current;
                      if (isIOSCanDebug) {
                        SharedPrefsUtils.put('isIOSCanDebug', true);
                      } else {
                        SharedPrefsUtils.put('isIOSCanDebug', false);
                      }
                      var argument = {"canDebug":isIOSCanDebug};
                      var result = await _methodChannel.invokeMethod("iosDebug", argument);
                      print("调用调试Debug开关回调结果:$result");
                      setState(() {
                      });
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
          ),

          Padding(padding: EdgeInsets.only(left: 20, right: 10),
            child: Container(
              height: 44,
              child: Row(
                children: <Widget>[
                  Text("屏幕长亮开关"),
                  CupertinoSwitch(
                    activeColor: Color(0xFF52D257),
                    value: isDeviceLongBright,
                    onChanged: (bool current) async {
                      isDeviceLongBright = current;
                      if (isDeviceLongBright) {
                        Wakelock.enable();
                        SharedPrefsUtils.put('isDeviceLongBright', true);
                      } else {
                        Wakelock.disable();
                        SharedPrefsUtils.put('isDeviceLongBright', false);
                      }
                      setState(() {
                      });
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
          ),
        ],
      ),
    );
  }
}