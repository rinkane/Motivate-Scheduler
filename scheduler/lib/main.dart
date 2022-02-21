import 'package:flutter/material.dart';

import 'view/scheduleListView.dart';
import 'model/schedule.dart';

const String appName = "Motivate Scheduler";

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
      home: ScheduleListView(
        title: appName,
        schedules: <Schedule>[
          Schedule.of(
              "予定1",
              10,
              DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  DateTime.now().hour,
                  DateTime.now().minute),
              DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      DateTime.now().hour,
                      DateTime.now().minute)
                  .add(const Duration(days: 1))),
          Schedule.of(
              "予定2",
              -30,
              DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      DateTime.now().hour,
                      DateTime.now().minute)
                  .add(const Duration(days: -1)),
              DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      DateTime.now().hour,
                      DateTime.now().minute)
                  .add(const Duration(days: 2))),
          Schedule.of(
              "予定3",
              40,
              DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      DateTime.now().hour,
                      DateTime.now().minute)
                  .add(const Duration(days: -2)),
              DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      DateTime.now().hour,
                      DateTime.now().minute)
                  .add(const Duration(days: 0))),
        ],
      ),
    );
  }
}
