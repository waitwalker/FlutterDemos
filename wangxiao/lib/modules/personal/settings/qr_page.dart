import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPage extends StatefulWidget{
  @override
  createState() {
    return _QRState();
  }
}

class _QRState extends State<QRPage> {
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
      body: Center(
        child: QrImage(
          data: 'This QR code has an embedded image as well',
          version: QrVersions.auto,
          size: 320,
          gapless: false,
          embeddedImage: AssetImage('static/images/logo.png'),
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: Size(80, 80),
          ),
        ),
      ),
    );
  }
}