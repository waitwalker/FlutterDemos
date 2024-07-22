import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'first_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [

    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double result = 0;

  int cost = 0;
  double progress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _doTask() async {
    final receivePort = RawReceivePort();
    /// 处理接收消息
    receivePort.handler = handleMessage;
    /// 处理耗时任务&将任务处理结果发送回来
    await Isolate.spawn(_doTaskInCompute, receivePort.sendPort,
        onError: receivePort.sendPort, onExit: receivePort.sendPort);
  }

  void handleMessage(dynamic msg) {
    print("=======msg===========");
    if (msg is TaskResult) {
      progress = 1;
      setState(() {
        result = msg.result;
        cost = msg.cost;
      });
    }

    if (msg is double) {
      setState(() {
        progress = msg;
      });
    }
  }

  static Random random = Random();

  /// 在新isolate要处理的耗时任务，第二个参数是任务的入参，这里把新isolate的发送端口传过去，方便发送消息
  static void _doTaskInCompute(SendPort sendPort) async {
    int count = 100000000;
    double r = 0;
    int c = 0;
    int sum = 0;
    int startTime = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < count; i++) {
      sum += random.nextInt(10000);
      if (i % 1000000 == 0) {
        sendPort.send(i / count);
      }
    }
    int endTime = DateTime.now().millisecondsSinceEpoch;
    r = sum / count;
    c = endTime - startTime;
    Isolate.exit(sendPort, TaskResult(cost: c, result: r));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("耗时测试"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "1 亿随机数平均测试",
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              '计算结果:$result',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 30,
            ),
            Text("总耗时：$cost ms"),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const Spacer(),
                Expanded(
                    child: LinearProgressIndicator(
                  value: progress,
                )),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text("当前进度:${(progress * 100).toStringAsFixed(2)}"),

            ElevatedButton(onPressed: (){

              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                return const FirstPage();
              }));

            }, child: const Text("下一页"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _doTask,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TaskResult {
  final int cost;
  final double result;

  TaskResult({required this.cost, required this.result});
}
