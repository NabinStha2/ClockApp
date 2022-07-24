import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_analog_clock/flutter_analog_clock.dart';

class ClockView extends StatefulWidget {
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  bool showAutoTimeZone = true;
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // debugPrint(timer.tick.toString());
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dateTime = DateTime.now();
    var formattedTime = DateFormat.jms().format(dateTime);
    var formattedDate = DateFormat("E, d MMMM").format(dateTime);
    var timeZoneOffset = dateTime.timeZoneOffset.toString().split(".").first;
    var offsetSign = "";
    if (!timeZoneOffset.startsWith("-")) {
      offsetSign = "+";
    }

    return TweenAnimationBuilder(
      duration: Duration(seconds: 2),
      tween: Tween(
        begin: 2.0,
        end: 0.0,
      ),
      curve: Curves.bounceOut,
      builder: (BuildContext context, dynamic value, _) {
        // debugPrint(value.toString());
        return Transform(
          alignment: FractionalOffset.centerLeft,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY((pi / 4) * value),
          child: Center(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    // color: Colors.red,
                    height: 300,
                    width: 500,
                    child: Transform.rotate(
                      angle: -pi / 2,
                      child: CustomPaint(
                        painter: MyCustomPainter(),
                      ),
                      // child: FlutterAnalogClock(),/
                      // child: FlutterAnalogClock(),/
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "TimeZone",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.language),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "UTC$offsetSign$timeZoneOffset(IST)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 20.0,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Automatic Timezone",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 24.0,
                  //       ),
                  //     ),
                  //     Switch.adaptive(
                  //       activeColor: Colors.green,
                  //       activeTrackColor: Colors.grey[600],
                  //       inactiveThumbColor: Colors.grey,
                  //       value: showAutoTimeZone,
                  //       onChanged: (val) {
                  //         setState(() {
                  //           showAutoTimeZone = val;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    DateTime dateTime = DateTime.now();
    // debugPrint(size.center(Offset(50, 50)).toString());
    // debugPrint(size.bottomCenter(Offset(0, 0)).toString());

    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    // var radius = min(centerX, centerY);

    Paint paintCircle1 = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 4.0
      ..isAntiAlias = true;

    Paint paintCircle2 = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..isAntiAlias = true;

    Paint paintCircle3 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16.0
      ..isAntiAlias = true;

    Paint secHandBrush = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 5.0
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    Paint minHandBrush = Paint()
      ..shader = RadialGradient(
        colors: [Colors.lightBlue, Colors.pink],
      ).createShader(
        Rect.fromCircle(center: center, radius: 100),
      )
      ..strokeWidth = 10.0
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    Paint hourHandBrush = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white, Colors.blue],
      ).createShader(
        Rect.fromCircle(center: center, radius: 100),
      )
      // ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 8.0
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    var dashBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    canvas.drawCircle(center, 100.0, paintCircle1);
    canvas.drawCircle(center, 100.0, paintCircle3);

    var hourHandX = centerX +
        60 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerX +
        60 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minHandX = centerX + 75 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerX + 75 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX = centerX + 80 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerX + 80 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, 15.0, paintCircle2);

    var outerCircleRadius = 120;
    var innerCircleRadius = 150 - 18;
    for (double i = 0; i < 360; i += 6) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
