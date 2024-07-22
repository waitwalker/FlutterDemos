import 'package:flutter/material.dart';
import 'package:provider_test/color_provider.dart';

class StfA extends StatefulWidget {
  const StfA({Key? key}) : super(key: key);

  @override
  State<StfA> createState() => _StfAState();
}

class _StfAState extends State<StfA> {
  
  @override
  void initState() {
    // Color? color = ColorProvider.of(context);
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Color? color = ColorProvider.of(context);
    print(color);
  }
  
  bool _red = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      color: ColorProvider.of(context),
    );
  }
  
  void toggle() {
    setState(() {
      _red = !_red;
    });
  }
}
