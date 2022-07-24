import 'package:hive/hive.dart';
part "alarm_model.g.dart";

@HiveType(typeId: 0)
class AlarmModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  DateTime alarmDateTime;
  @HiveField(3)
  bool isPending;
  @HiveField(4)
  int gradientColorIndex;
  // @HiveField(5)
  // String sound;

  AlarmModel({
    required this.id,
    required this.title,
    required this.alarmDateTime,
    required this.isPending,
    required this.gradientColorIndex,
  });
}
