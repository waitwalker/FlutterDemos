import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CommonDottedBorderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonDottedBorderState();
  }
}

class _CommonDottedBorderState extends State<CommonDottedBorderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("原点边框"),
      ),
      body: Center(
        child: DottedBorder(
          child: Container(
            color: Colors.lightGreen,
            height: 300,
            width: 300,
          ),
          strokeCap: StrokeCap.round,
          strokeWidth: 5.5,
          dashPattern: [1,5],
        ),
      ),
    );
  }
}