import 'dart:io';
import 'package:flutter/material.dart';
import 'package:online_school/modules/widgets/style.dart';

class ScanQRPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScanQRState();
  }
}

class _ScanQRState extends State<ScanQRPage> {

  String scanResult = "";
//  static final _possibleFormats = BarcodeFormat.values.toList()
//    ..removeWhere((e) => e == BarcodeFormat.unknown);
//
//  List<BarcodeFormat> selectedFormats = [..._possibleFormats];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text("二维码"),
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS ? true : false,
      ),
      backgroundColor: Color(MyColors.background),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("结果:"),
              Text(scanResult),
            ],
          ),

          Padding(padding: EdgeInsets.only(top: 20)),

          InkWell(
            child: Text("扫描"),
            onTap: (){}//scanAction,
          ),
        ],
      ),
    );
  }

//  scanAction() async {
//    try {
//      var options = ScanOptions(
//        strings: {
//          "cancel": "取消",
//          "flash_on": "手电筒开",
//          "flash_off": "手电筒关",
//        },
//        restrictFormat: selectedFormats,
//        useCamera: -1,
//        autoEnableFlash: true,
//        android: AndroidOptions(
//          aspectTolerance: 0.0,
//          useAutoFocus: true,
//        ),
//      );
//
//      var result = await BarcodeScanner.scan(options: options);
//    } on PlatformException catch (e) {
//      var result = ScanResult(
//        type: ResultType.Error,
//        format: BarcodeFormat.unknown,
//      );
//
//      if (e.code == BarcodeScanner.cameraAccessDenied) {
//        setState(() {
//          result.rawContent = 'The user did not grant the camera permission!';
//        });
//      } else {
//        result.rawContent = 'Unknown error: $e';
//      }
//      setState(() {
//        scanResult = result as String;
//      });
//    }
//  }
}