import 'package:flutter/cupertino.dart';

class ColorProvider extends InheritedWidget {
  const ColorProvider({Key? key, required this.color, required Widget child})
      : super(key: key, child: child);

  final Color color;

  @override
  bool updateShouldNotify(covariant ColorProvider oldWidget) {
    return oldWidget.color != color;
  }

  static Color? of(BuildContext context) {
    final ColorProvider? widget = context.dependOnInheritedWidgetOfExactType<ColorProvider>();
    return widget?.color;
  }
}
