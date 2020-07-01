import 'dart:async';
import 'package:flutter/material.dart';

import 'first.dart';


void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('被调用被调用被调用被调用被调用1111111111111111${details.toString()}');
  };
  runZoned(() => runApp(MyApp()), onError: (Object obj, StackTrace stack) {
    print('被调用被调用被调用被调用被调用2222222222222222${stack.toString()}');
  });
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
