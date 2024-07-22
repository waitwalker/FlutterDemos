import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool reverse = false; // 用于控制动画方向

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Center(
              child: MirrorAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: 0.0), // 定义从1到0再到1的透明度渐变
                duration: const Duration(seconds: 3), // 动画持续时间
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.amberAccent,
                    ), // 替换为你的图片路径
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            LoopAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0), // 定义从0到1的透明度渐变
              duration: const Duration(seconds: 5), // 动画持续时间
              builder: (context, value, child) {
                // 计算图片A和图片B的透明度
                double opacityA;
                double opacityB;

                // 将动画分为四个阶段：
                // 0.0 -> 0.25: A从1到0，B从0到1
                // 0.25 -> 0.5: 停顿
                // 0.5 -> 0.75: B从1到0，A从0到1
                // 0.75 -> 1.0: 停顿

                if (value <= 0.25) {
                  opacityA = 1 - (value * 4); // A 从 1 到 0
                  opacityB = value * 4; // B 从 0 到 1
                } else if (value <= 0.5) {
                  opacityA = 0; // A 保持透明
                  opacityB = 1; // B 保持不透明
                } else if (value <= 0.75) {
                  opacityA = (value - 0.5) * 4; // A 从 0 到 1
                  opacityB = 1 - (value - 0.5) * 4; // B 从 1 到 0
                } else {
                  opacityA = 1; // A 保持不透明
                  opacityB = 0; // B 保持透明
                }

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: opacityA,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.red,
                      ), // 替换为你的A图片路径
                    ),
                    Opacity(
                      opacity: opacityB,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.lightBlue,
                      ), // 替换为你的B图片路径
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
