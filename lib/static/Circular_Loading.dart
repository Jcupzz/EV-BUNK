import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Circular_Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    ThemeData themeData;
    return Container(
        color: Colors.white,
        child: Center(
          child: SpinKitChasingDots(
            color: brightness == Brightness.light
                ? Color.fromARGB(255, 0, 0, 0)
                : Colors.white,
            size: 100.0,
          ),
        ));
  }
}
