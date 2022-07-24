import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class StopWatchPage extends StatefulWidget {
  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  int hour = 0;
  int min = 0;
  int sec = 0;
  bool start = false;
  bool pause = true;
  String countedTime = "00:00:00:00";
  Stopwatch watch = new Stopwatch();
  Timer? _timer;

  @override
  void dispose() {
    // if (_timer != null) {
      _timer!.cancel();
    // }
    super.dispose();
  }

  startTimer() {
    watch.start();
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      // debugPrint(watch.elapsed.inMinutes.toString());
      // debugPrint(watch.elapsed.inSeconds.toString());

      setState(() {
        if (pause) {
          // debugPrint("timer1");
          timer.cancel();
        }
        if (watch.isRunning) {
          // debugPrint("timerStart1");
          countedTime = watch.elapsed.inHours.toString().padLeft(2, "0") +
              ":" +
              watch.elapsed.inMinutes.remainder(60).toString().padLeft(2, "0") +
              ":" +
              watch.elapsed.inSeconds.remainder(60).toString().padLeft(2, "0") +
              ":" +
              watch.elapsed.inMilliseconds
                  .remainder(1000)
                  .toString()
                  .padLeft(2, "0");
        }
      });
    });
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
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.3,
              // color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    countedTime,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  start
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              iconSize: 40.0,
                              alignment: Alignment.center,
                              splashRadius: 30.0,
                              icon: Icon(
                                pause ? Icons.play_arrow : Icons.pause,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                if (!pause) {
                                  // debugPrint("pause");
                                  setState(() {
                                    pause = true;
                                  });
                                  watch.stop();
                                } else {
                                  // debugPrint("resume");
                                  setState(() {
                                    pause = false;
                                  });
                                  startTimer();
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
                                watch
                                  ..reset()
                                  ..stop();
                                setState(() {
                                  countedTime = "00:00:00:00";
                                  start = false;
                                  pause = true;
                                });
                              },
                            ),
                          ],
                        )
                      : IconButton(
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
                              start = true;
                              pause = false;
                            });
                            startTimer();
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
