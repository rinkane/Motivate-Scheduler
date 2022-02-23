import 'package:flutter/material.dart';

import 'view/scheduleListView.dart';
import 'view/motivationGraphView.dart';
import 'model/schedule.dart';

const String appName = "Motivate Scheduler";

List<Schedule> schedules = [
  Schedule.of(
      "予定1",
      10,
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          DateTime.now().hour, DateTime.now().minute),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              DateTime.now().hour, DateTime.now().minute)
          .add(const Duration(days: 1))),
  Schedule.of(
      "予定2",
      -30,
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              DateTime.now().hour, DateTime.now().minute)
          .add(const Duration(days: -1)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              DateTime.now().hour, DateTime.now().minute)
          .add(const Duration(days: 2))),
  Schedule.of(
      "予定3",
      40,
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              DateTime.now().hour, DateTime.now().minute)
          .add(const Duration(days: -2)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              DateTime.now().hour, DateTime.now().minute)
          .add(const Duration(days: 0)))
];
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => ScheduleListView(
              title: appName,
              schedules: schedules,
            ),
        '/motivation': (BuildContext context) => MotivationGraphView(
              title: appName,
              schedules: schedules,
            ),
      },
      home: ScheduleListView(
        title: appName,
        schedules: schedules,
      ),
    );
  }
}
