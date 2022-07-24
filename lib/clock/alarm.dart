import 'dart:math';

import 'package:clock_app/clock/constant/theme.dart';
import 'package:clock_app/clock/models/alarm_model.dart';
import 'package:clock_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  late DateTime? _alarmTime;
  late String? _alarmTimeString;
  final alarmBox = Hive.box<AlarmModel>("alarm");
  final List<String> alarmSounds = [
    "edvard_grieg_morning_mood",
    "landras_dream",
    "morning_alarm",
    "music",
    // "slow_spring_board",
    // "tennesse_whiskey",
    // "beautiful_guitar_ringtone",
    // "beautiful_spring_melody",
    // "edvard_grieg_morning_mood",
    // "lovely_alarm_shining_stars",
    // "the_pirats_alarm",
    // "car_horn",
    // "boxing_ring",
    // "best_alarm",
    // "action_epic",
    // "quiet_sunrise",
    // "gentle_alarm_clock",
    // "pleasant_alarm_clock",
    // "alarm1",
    // "alarm2",
    // "music",
    // "suga_boom_boom",
  ];
  String selectedSound = "landras_dream";
  TextEditingController _titleController = new TextEditingController();
  String title = "";

  @override
  Widget build(BuildContext context) {
    // debugPrint(selectedSound);
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
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: alarmBox.listenable(),
                  builder: (context, Box<AlarmModel> box, _) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        // debugPrint(box.keys.toList().toString());
                        // debugPrint(box.values.toList()[index].sound.toString());
                        return Dismissible(
                          key: ValueKey(box.keys.toList()[index]),
                          background: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 14.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 14.0),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  top: 50,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (DismissDirection dismissed) =>
                              deleteAlarm(box.keys.toList()[index]),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 14.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 14.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: GradientTemplate
                                    .gradientTemplate[box.values
                                        .toList()[index]
                                        .gradientColorIndex]
                                    .colors,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(2, 4),
                                  color: GradientTemplate
                                      .gradientTemplate[box.values
                                          .toList()[index]
                                          .gradientColorIndex]
                                      .colors
                                      .first,
                                ),
                                BoxShadow(
                                  blurRadius: 10.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(2, 4),
                                  color: GradientTemplate
                                      .gradientTemplate[box.values
                                          .toList()[index]
                                          .gradientColorIndex]
                                      .colors
                                      .last,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.label,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          "${box.values.toList().cast<AlarmModel>()[index].title}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Switch.adaptive(
                                      activeColor: Colors.white,
                                      value:
                                          box.values.toList()[index].isPending,
                                      onChanged: (value) {
                                        onOrOffAlarm(index, value);
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  "Sun-Sat",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat("hh:mm aa")
                                          .format(box.values
                                              .toList()[index]
                                              .alarmDateTime)
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showBottomPanel(
                                            edit: true, index: index);
                                      },
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: box.keys.length,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                    );
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      overlayColor: MaterialStateProperty.all<Color>(
                        Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    onPressed: () {
                      showBottomPanel();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 45.0,
                        ),
                        Text(
                          "Add Alarm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showBottomPanel({bool? edit = false, int? index}) {
    _alarmTimeString = edit! && index != null
        ? DateFormat('hh:mm aa')
            .format(alarmBox.values.toList()[index].alarmDateTime)
        : DateFormat('hh:mm aa').format(DateTime.now());
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.78,
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () async {
                      var selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        helpText: "Click the time to set alarm",
                        useRootNavigator: true,
                      );
                      if (selectedTime != null) {
                        final now = DateTime.now();
                        var selectedDateTime = DateTime(now.year, now.month,
                            now.day, selectedTime.hour, selectedTime.minute);
                        _alarmTime = selectedDateTime;
                        setModalState(() {
                          _alarmTimeString =
                              DateFormat('hh:mm aa').format(selectedDateTime);
                        });
                      }
                    },
                    child: Text(
                      _alarmTimeString!,
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  ListTile(
                    title: Text('Sound'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      showModalBottomSheet(
                        useRootNavigator: true,
                        context: context,
                        clipBehavior: Clip.antiAlias,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 1.78,
                            padding: const EdgeInsets.all(32),
                            child: SingleChildScrollView(
                              child: Column(
                                children: alarmSounds.map((sound) {
                                  return ListTile(
                                    title: Text("$sound"),
                                    leading: Icon(
                                      Icons.music_note_rounded,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedSound = sound;
                                      });

                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListTile(
                    title: Text('Title'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        useRootNavigator: true,
                        context: context,
                        clipBehavior: Clip.antiAlias,
                        isScrollControlled: true,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 1.78,
                            padding: const EdgeInsets.all(32),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      hintText: "Enter title",
                                      labelText: "Title:",
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  ElevatedButton(
                                    child: Text("Save"),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        title = _titleController.text;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      onSaveAlarm(edit: edit, index: index);
                    },
                    icon: Icon(Icons.alarm),
                    label: edit ? Text('Edit') : Text("Save"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void scheduleAlarm(DateTime scheduleAlarmDateTime, AlarmModel alarmInfo,
      {bool? value}) async {
    // debugPrint(alarmInfo.sound);
    RawResourceAndroidNotificationSound notificationSound =
        RawResourceAndroidNotificationSound(selectedSound);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'clock',
      playSound: true,
      sound: notificationSound,
      largeIcon: DrawableResourceAndroidBitmap('clock'),
      fullScreenIntent: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (value != null) {
      if (!value) {
        await flutterLocalNotificationsPlugin.cancel(alarmInfo.id);
      }
    } else {
      await flutterLocalNotificationsPlugin.schedule(
        alarmInfo.id,
        "Alarm",
        alarmInfo.title,
        scheduleAlarmDateTime,
        platformChannelSpecifics,
      );
    }
  }

  void onOrOffAlarm(int index, bool value) async {
    var v = alarmBox.values.toList().cast<AlarmModel>()[index];
    var val = v
      ..id = v.id
      ..alarmDateTime = v.alarmDateTime
      ..gradientColorIndex = v.gradientColorIndex
      ..isPending = value
      ..title = v.title;

    await alarmBox.put(alarmBox.keyAt(index), val);

    var alarmInfo = alarmBox.values.toList()[index];

    // debugPrint(alarmInfo.isPending.toString());
    if (value) {
      scheduleAlarm(alarmInfo.alarmDateTime, alarmInfo);
    } else {
      scheduleAlarm(alarmInfo.alarmDateTime, alarmInfo, value: value);
    }
  }

  void onSaveAlarm({bool edit = false, int? index}) async {
    if (await askPermission(Permission.notification)) {
      // debugPrint(selectedSound);
      DateTime scheduleAlarmDateTime;
      if (_alarmTime!.isAfter(DateTime.now()))
        scheduleAlarmDateTime = _alarmTime!;
      else
        scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));

      if (edit) {
        var key = alarmBox.keyAt(index!);
        var value = alarmBox.getAt(index);
        var updatedValue = value!
          ..id = value.id
          ..alarmDateTime = scheduleAlarmDateTime
          ..title = title == "" ? value.title : title
          ..gradientColorIndex = value.gradientColorIndex
          ..isPending = value.isPending;

        await alarmBox.put(key, updatedValue);

        // debugPrint(alarmBox.values.toList()[index].sound);
        scheduleAlarm(scheduleAlarmDateTime, updatedValue);
      } else {
        var alarmInfo = AlarmModel(
          id: Random().nextInt(10000),
          alarmDateTime: scheduleAlarmDateTime,
          gradientColorIndex: Random().nextInt(5),
          isPending: true,
          title: title,
        );
        await alarmBox.add(alarmInfo);
        // debugPrint(alarmInfo.sound);

        scheduleAlarm(scheduleAlarmDateTime, alarmInfo);
      }
    }

    _titleController.text = "";
    Navigator.pop(context);
  }

  Future<bool> askPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus res = await permission.request();
      if (res == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  void deleteAlarm(int key) async {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
            '${DateFormat("hh:mm aa").format(alarmBox.get(key)!.alarmDateTime)} is deleted.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    await alarmBox.delete(key);
  }
}
