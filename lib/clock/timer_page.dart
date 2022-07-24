import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:numberpicker/numberpicker.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  CountDownController _controller = CountDownController();
  int hour = 0;
  int min = 5;
  int sec = 0;
  int timeForTimer = 0;
  Timer? _timer;
  int? timeRemaining;
  bool isStarted = false;
  bool isPause = false;
  bool isCount = false;

  void starts() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeForTimer == 0 || isPause == true) {
          // debugPrint("timer1");
          timer.cancel();
        } else {
          // debugPrint("timeForTimer1");
          timeForTimer = timeForTimer - 1;
        }
      });
    });
  }

  @override
  void dispose() {
    // if (_timer != null) {
      _timer!.cancel();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(seconds: 2),
      tween: Tween(
        begin: 2.0,
        end: 0.0,
      ),
      curve: Curves.bounceOut,
      builder: (BuildContext context, dynamic value, _) {
        return Transform(
          alignment: FractionalOffset.centerLeft,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY((pi / 4) * value),
          child: isCount
              ? countDownTimer()
              : Center(
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Container(
                      alignment: Alignment.center,
                      // color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Hour",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  NumberPicker(
                                    minValue: 0,
                                    maxValue: 23,
                                    value: hour,
                                    infiniteLoop: true,
                                    zeroPad: true,
                                    textStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    itemCount: 5,
                                    selectedTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        hour = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Min",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  NumberPicker(
                                    minValue: 0,
                                    maxValue: 59,
                                    value: min,
                                    infiniteLoop: true,
                                    zeroPad: true,
                                    textStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    itemCount: 5,
                                    selectedTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        min = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Sec",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  NumberPicker(
                                    minValue: 0,
                                    maxValue: 59,
                                    value: sec,
                                    infiniteLoop: true,
                                    zeroPad: true,
                                    textStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    itemCount: 5,
                                    selectedTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        sec = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            alignment: Alignment.center,
                            iconSize: 40.0,
                            color: Colors.red,
                            focusColor: Colors.red,
                            splashRadius: 30.0,
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // debugPrint("start");
                              setState(() {
                                isStarted = true;
                                isPause = false;
                                isCount = true;
                              });
                              timeForTimer =
                                  (hour * 60 * 60) + (min * 60) + sec;
                              starts();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget countDownTimer() {
    // debugPrint(timeForTimer.toString());
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularCountDownTimer(
            duration: timeForTimer,
            controller: _controller,
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
            ringColor: Colors.grey[300]!,
            ringGradient: null,
            fillColor: Colors.purpleAccent[100]!,
            fillGradient: LinearGradient(
              colors: [Color(0xFFFE6197), Color(0xFFFFB463)],
            ),
            backgroundColor: Colors.purple[500],
            backgroundGradient: LinearGradient(
              colors: [Color(0xFFFFA738), Color(0xFFFFE130)],
            ),
            strokeWidth: 20.0,
            strokeCap: StrokeCap.round,
            textStyle: TextStyle(
                fontSize: 33.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            textFormat: CountdownTextFormat.HH_MM_SS,
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: true,
            onStart: () {
              // print('Countdown Started');
            },
            onComplete: () {
              setState(() {
                isCount = false;
              });
            },
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                iconSize: 40.0,
                alignment: Alignment.center,
                splashRadius: 30.0,
                icon: Icon(
                  isPause ? Icons.play_arrow : Icons.pause,
                  color: Colors.blue,
                ),
                onPressed: () {
                  if (!isPause) {
                    // debugPrint("pause");
                    setState(() {
                      isPause = true;
                    });
                    _controller.pause();
                  } else {
                    // debugPrint("resume");
                    setState(() {
                      isPause = false;
                    });
                    _controller.resume();
                    starts();
                  }
                },
              ),
              IconButton(
                iconSize: 40.0,
                splashRadius: 30.0,
                alignment: Alignment.center,
                icon: Icon(
                  Icons.stop,
                  color: Colors.blue,
                ),
                onPressed: () {
                  // debugPrint("stop");
                  setState(() {
                    isStarted = false;
                    isPause = true;
                    isCount = false;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
