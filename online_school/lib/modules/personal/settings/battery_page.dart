import 'dart:async';
import 'dart:io';

//import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'package:online_school/modules/widgets/style.dart';

class BatteryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BatteryState();
  }
}

class _BatteryState extends State<BatteryPage> {

  int batteryLevel;

  @override
  void initState() {
    getBatteryLevel();
    super.initState();
  }

  getBatteryLevel() async {
//    Battery _battery = Battery();
//    batteryLevel = await _battery.batteryLevel;
//
//    print("batteryLevel:$batteryLevel");
//    setState(() {
//
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text("电池"),
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS ? true : false,
      ),
      backgroundColor: Color(MyColors.background),
      body: Center(
        child: Text("电池电量:$batteryLevel%"),
      ),
    );
  }
}