import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom LineChart with Ellipses'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(1, 1),
                    FlSpot(2, 3),
                    FlSpot(3, 2),
                    FlSpot(4, 5),
                    FlSpot(5, 3.1),
                  ],
                  isCurved: false,
                  barWidth: 0,
                  belowBarData: BarAreaData(show: false),
                  aboveBarData: BarAreaData(show: false),
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 10,
                        color: Colors.blue,
                        strokeWidth: 1,
                        strokeColor: Colors.black,
                      );
                    },
                  ),
                ),
              ],
              // titlesData: FlTitlesData(
              //   leftTitles: AxisTitles(
              //     sideTitles: SideTitles(showTitles: true),
              //   ),
              //   bottomTitles: AxisTitles(
              //     sideTitles: SideTitles(showTitles: true),
              //   ),
              // ),
              gridData: FlGridData(show: false),
              // borderData: FlBorderData(show: true),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:chart_demo/cubits/app/app_cubit.dart';
// import 'package:chart_demo/presentation/resources/app_colors.dart';
// import 'package:chart_demo/presentation/resources/app_texts.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'presentation/router/app_router.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AppCubit>(create: (BuildContext context) => AppCubit()),
//       ],
//       child: MaterialApp.router(
//         title: AppTexts.appName,
//         theme: ThemeData(
//           brightness: Brightness.dark,
//           useMaterial3: true,
//           textTheme: GoogleFonts.assistantTextTheme(
//             Theme.of(context).textTheme.apply(
//                   bodyColor: AppColors.mainTextColor3,
//                 ),
//           ),
//           scaffoldBackgroundColor: AppColors.pageBackground,
//         ),
//         routerConfig: appRouterConfig,
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:get/get.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: WavePage());
//   }
// }
//
// class WavePage extends StatefulWidget {
//   const WavePage({super.key});
//
//   @override
//   State<WavePage> createState() => _WavePageState();
// }
//
// class _WavePageState extends State<WavePage> {
//   @override
//   void initState() {
//     super.initState();
//     addDummyData();
//   }
//
//   var cardList = <CardData>[].obs;
//   List<CardData> cards = [];
//
//   String wave =
//       "55,44,60,50,21,49,57,35,59,60,60,53,52,37,50,50,59,42|51,62,58,57,16,45,54,31,59,59,57,53,56,21,46,46,69,38|31,42,38,37,16,25,34,1,39,29,17,33,26,11,46,16,39,18";
//
//   // 添加一些假数据
//   void addDummyData() {
//     List<String> waveStr = wave.split("|");
//
//     double scale = 0.1;
//     List<List<Offset>> linePoints = [];
//     List<List<Offset>> aniLinePoints = [];
//
//     for (int i = 0; i < waveStr.length; i++) {
//       List<String> pointsStr = waveStr[i].split(",");
//       List<Offset> points = [];
//       List<Offset> aniPoints = [];
//       double prev = 0;
//       int j = 0;
//       for (String value in pointsStr) {
//         double rawY = double.tryParse(value) ?? 0;
//         points.add(Offset(double.parse("$j"), rawY));
//         if (rawY > prev) {
//           rawY *= 1.0 + scale;
//         } else if (rawY < prev) {
//           rawY *= 1.0 - scale;
//         } else {
//           rawY *= i % 2 == 0 ? 1.0 + scale : 1.0 - scale;
//         }
//         aniPoints.add(Offset(double.parse("$j"), rawY));
//         prev = rawY;
//         j++;
//       }
//       linePoints.add(points);
//       aniLinePoints.add(aniPoints);
//       cards.add(CardData(linePoints, aniLinePoints));
//     }
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("波形")),
//       body: ListView.builder(
//         itemCount: cards.length,
//         itemBuilder: (context, index) {
//           return CardWidget(cards[index]);
//         },
//       ),
//     );
//   }
// }
//
// // 数据模型，表示卡片中的数据
// class CardData {
//   final List<List<Offset>> points;
//   final List<List<Offset>> animatedPoints;
//
//   CardData(this.points, this.animatedPoints);
// }
//
// // 控制器，用于管理和更新卡片列表数据
// class CardController extends GetxController {
//   var cardList = <CardData>[].obs;
//   List<CardData> cards = [];
//
//   String wave =
//       "55,44,60,50,21,49,57,35,59,60,60,53,52,37,50,50,59,42|51,62,58,57,16,45,54,31,59,59,57,53,56,21,46,46,69,38|31,42,38,37,16,25,34,1,39,29,17,33,26,11,46,16,39,18";
//
//   // 添加一些假数据
//   void addDummyData() {
//     List<String> waveStr = wave.split("|");
//
//     double scale = 0.1;
//     List<List<Offset>> linePoints = [];
//     List<List<Offset>> aniLinePoints = [];
//
//     for (int i = 0; i < waveStr.length; i++) {
//       List<String> pointsStr = waveStr[i].split(",");
//       List<Offset> points = [];
//       List<Offset> aniPoints = [];
//       double prev = 0;
//       int j = 0;
//       for (String value in pointsStr) {
//         double rawY = double.tryParse(value) ?? 0;
//         points.add(Offset(double.parse("$j"), rawY));
//         if (rawY > prev) {
//           rawY *= 1.0 + scale;
//         } else if (rawY < prev) {
//           rawY *= 1.0 - scale;
//         } else {
//           rawY *= i % 2 == 0 ? 1.0 + scale : 1.0 - scale;
//         }
//         aniPoints.add(Offset(double.parse("$j"), rawY));
//         prev = rawY;
//         j++;
//       }
//       linePoints.add(points);
//       aniLinePoints.add(aniPoints);
//       cards.add(CardData(linePoints, aniLinePoints));
//     }
//   }
// }
//
// // 卡片组件
// class CardWidget extends StatelessWidget {
//   final CardData cardData;
//
//   CardWidget(this.cardData);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(8),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: RepaintBoundary(
//           child: JitteringLineChart(cardData.points, cardData.animatedPoints),
//         ),
//       ),
//     );
//   }
// }
//
// // 抖动效果的图表组件
// class JitteringLineChart extends StatefulWidget {
//   final List<List<Offset>> data;
//   final List<List<Offset>> animatedData;
//
//   JitteringLineChart(this.data, this.animatedData);
//
//   @override
//   _JitteringLineChartState createState() => _JitteringLineChartState();
// }
//
// class _JitteringLineChartState extends State<JitteringLineChart> {
//   late Timer _timer;
//   final _random = Random();
//   List<List<Offset>> layer1Data = [];
//   List<List<Offset>> layer2Data = [];
//   bool animating = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // 初始化抖动数据
//     _jitterData();
//     // 每100毫秒更新一次数据
//     _timer = Timer.periodic(Duration(milliseconds: 150), (timer) {
//       _jitterData();
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   // 为数据添加抖动效果
//   void _jitterData() {
//     if (animating) {
//       layer1Data = widget.animatedData;
//       layer2Data = widget.data;
//     } else {
//       layer1Data = widget.data;
//       layer2Data = widget.animatedData;
//     }
//     animating = !animating;
//   }
//
//   Color getRandomColor() {
//     final random = Random();
//     return Color.fromARGB(
//       255, // 固定 alpha 通道为 255（不透明）
//       random.nextInt(256), // 随机生成 0-255 之间的红色值
//       random.nextInt(256), // 随机生成 0-255 之间的绿色值
//       random.nextInt(256), // 随机生成 0-255 之间的蓝色值
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 360,
//       height: 200,
//       child: Stack(
//         children: [
//           LineChart(
//             LineChartData(
//               gridData: FlGridData(show: false),
//               titlesData: FlTitlesData(show: false),
//               borderData: FlBorderData(show: false),
//               lineBarsData: charts(),
//             ),
//             curve: Curves.linear,
//             duration: Duration(milliseconds: 100),
//           ),
//           Opacity(
//             opacity: 0.4,
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(show: false),
//                 titlesData: FlTitlesData(show: false),
//                 borderData: FlBorderData(show: false),
//                 lineBarsData: opacityCharts(),
//               ),
//               curve: Curves.linear,
//               duration: Duration(milliseconds: 150),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<LineChartBarData> charts() {
//     List<LineChartBarData> list = [];
//     Color color = Color(0xFF71E5FF);
//     for (int i = 0; i < layer1Data.length; i++) {
//       if (i == 1) {
//         color = Color(0xFFFFB185);
//       } else if (i == 2) {
//         color = Color(0xFF70E9A1);
//       }
//
//       list.add(LineChartBarData(
//         spots: layer1Data[i].map((point) => FlSpot(point.dx, point.dy)).toList(),
//         isCurved: true,
//         barWidth: 5,
//         color: color,
//         belowBarData: BarAreaData(show: false),
//         dotData: FlDotData(show: false),
//       ));
//     }
//     return list;
//   }
//
//   List<LineChartBarData> opacityCharts() {
//     List<LineChartBarData> list = [];
//     Color color = Color(0xFF71E5FF);
//     for (int i = 0; i < layer2Data.length; i++) {
//       if (i == 1) {
//         color = Color(0xFFFFB185);
//       } else if (i == 2) {
//         color = Color(0xFF70E9A1);
//       }
//
//       list.add(LineChartBarData(
//         spots: layer2Data[i].map((point) => FlSpot(point.dx, point.dy)).toList(),
//         isCurved: true,
//         barWidth: 5,
//         color: color,
//         belowBarData: BarAreaData(show: false),
//         dotData: FlDotData(show: false),
//       ));
//     }
//     return list;
//   }
// }
