import 'package:flutter/material.dart';


class RedisPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RedisState();
  }
}

class _RedisState extends State<RedisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Redis"),
      ),
      body: Container(),
    );
  }
}
