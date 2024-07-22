import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isolate_full/stream_provider.dart';
import 'package:stream_transform/stream_transform.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    Stream<int> intStream = StreamProvider().createStream();

    // Stream xStream = intStream.throttle(const Duration(milliseconds: 250));
    // xStream.listen((event) {
    //   print("经过节流操作后的元素:$event");
    // });

    Stream yStream = intStream.debounce(const Duration(milliseconds: 250));
    yStream.listen((event) {
      print("经过防抖过滤后的元素:$event");
    });
    // Stream<String> stringStream = intStream.map((x) => "$x");
    // intStream.listen((e) {
    //   print(e);
    // });
    // stringStream.listen((e) {
    //   print("e type:${e.runtimeType} e:$e");
    // });

    // Stream<int> distinctStream = intStream.distinct((int a, int b)=>a==b);
    // distinctStream.listen((event) {
    //   print(event);
    // });
    // Stream<int> whereStream = intStream.where((e) => e < 500);
    // whereStream.listen((e) {
    //   print("经过条件过滤后的元素:$e");
    // });
    // Stream<int> takeStream = intStream.take(3);
    // takeStream.listen((e) {
    //   print("截取后的元素：$e");
    // });

    // Stream<int> takeWhileStream = intStream.takeWhile((element) => element < 500);
    // takeWhileStream.listen((e) {
    //   print("条件截取后的元素:$e");
    // });

    // Stream<int> skipStream = intStream.skip(5);
    // skipStream.listen((e) {
    //   print("跳过skip元素后:$e");
    // });

    // Stream<int> skipWhileStream = intStream.skipWhile((element) => element > 500);
    // skipWhileStream.listen((e) {
    //   print("跳过元素大于500的元素后:$e");
    // });

    // Stream<String> castStream = intStream.cast<String>();
    // castStream.listen((event) {
    //   print("对元素类型进制强制转换后$event ${event.runtimeType}");
    // });

    // Stream<int> expandStream = intStream.expand((element) => [element * 10]);
    // expandStream.listen((event) {
    //   print(event);
    // });

    // Stream<List<int>> newStream = intStream
    //     .map((event) => event.toString())
    //     .transform(const AsciiEncoder());
    // newStream.listen((event) {
    //   print("转换后$event");
    // });
    // List a = [1,23,4,56,7,88,9];
    // a.map((e) => "$e").toList();
    // a = a.take(3).toList();
    // print(a);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("第一页"),
      ),
      body: Column(
        children: const [
          ColoredBox(color: Colors.amber),
        ],
      ),
    );
  }
}
