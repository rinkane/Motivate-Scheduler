import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/schedule.dart';
import 'showCustomWidgets.dart';

class ScheduleSettingDialog extends StatefulWidget {
  final ScheduleSettingMethod initialMethod;
  final Schedule? initialSchedule;

  const ScheduleSettingDialog({
    Key? key,
    required this.initialMethod,
    this.initialSchedule,
  }) : super(key: key);

  @override
  ScheduleSettingDialogState createState() => ScheduleSettingDialogState();
}

enum ScheduleSettingMethod {
  add,
  fix,
}

class ScheduleSettingDialogState extends State<ScheduleSettingDialog> {
  late Schedule schedule;
  late ScheduleSettingMethod method;

  @override
  void initState() {
    super.initState();
    schedule =
        widget.initialSchedule != null ? widget.initialSchedule! : Schedule();
    method = widget.initialMethod;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("スケジュールの追加"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    initialValue: schedule.name,
                    decoration: const InputDecoration(hintText: "何をする予定ですか？"),
                    onChanged: (String s) {
                      changeTextField(s);
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: () => selectDate(context, true),
                            child: Text(DateFormat("yyyy-MM-dd")
                                .format(schedule.startDateTime)),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(6, 0, 3, 0),
                            ),
                          ),
                          SizedBox(
                            width: 44,
                            child: TextButton(
                              onPressed: () => selectTime(context, true),
                              child: Text(DateFormat("HH:mm")
                                  .format(schedule.startDateTime)),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.fromLTRB(3, 0, 6, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.black45,
                        size: 16,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: () => selectDate(context, false),
                            child: Text(DateFormat("yyyy-MM-dd")
                                .format(schedule.endDateTime)),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(6, 0, 3, 0),
                            ),
                          ),
                          SizedBox(
                            width: 44,
                            child: TextButton(
                              onPressed: () => selectTime(context, false),
                              child: Text(DateFormat("HH:mm")
                                  .format(schedule.endDateTime)),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.fromLTRB(3, 0, 6, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 60,
                  margin: const EdgeInsets.fromLTRB(0, 28, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: const Text("モチベーション"),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.fromLTRB(120, 30, 50, 0),
                  alignment: Alignment.center,
                  child: Slider(
                    value: schedule.motivation,
                    max: 100,
                    min: -100,
                    onChanged: changeSlider,
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.fromLTRB(0, 30, 20, 0),
                  alignment: Alignment.centerRight,
                  child: Text(schedule.motivation.toString()),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          SizedBox(
            width: 100,
            height: 60,
            child: TextButton(
              child: method == ScheduleSettingMethod.add
                  ? const Text("追加")
                  : const Text("修正"),
              onPressed: () {
                Navigator.pop(context, schedule);
              },
            ),
          ),
          SizedBox(
            width: 100,
            height: 60,
            child: TextButton(
              child: const Text("キャンセル"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ]);
  }

  void changeSlider(double value) {
    setState(() {
      schedule.motivation = value.roundToDouble();
    });
  }

  void changeTextField(String value) {
    setState(() {
      schedule.name = value;
    });
  }

  void selectDate(BuildContext context, bool isStart) async {
    DateTime scheduleDate =
        isStart ? schedule.startDateTime : schedule.endDateTime;
    final DateTime? date =
        await ShowCustomWidgets(context).scheduleDatePicker(scheduleDate);
    if (date != null) {
      final DateTime newDate = createDate(scheduleDate, date);
      setState(() {
        if (isStart) {
          schedule.startDateTime = newDate;
        } else {
          schedule.endDateTime = newDate;
        }
      });
    }
  }

  DateTime createDate(DateTime destination, DateTime source) {
    DateTime dateTime = DateTime(
      source.year,
      source.month,
      source.day,
      destination.hour,
      destination.minute,
    );
    return dateTime;
  }

  void selectTime(BuildContext context, bool isStart) async {
    DateTime scheduleTime =
        isStart ? schedule.startDateTime : schedule.endDateTime;
    final TimeOfDay? time =
        await ShowCustomWidgets(context).scheduleTimePicker(scheduleTime);
    if (time != null) {
      final DateTime newTime = createTime(scheduleTime, time);
      setState(() {
        if (isStart) {
          schedule.startDateTime = newTime;
        } else {
          schedule.endDateTime = newTime;
        }
      });
    }
  }

  DateTime createTime(DateTime destination, TimeOfDay source) {
    DateTime dateTime = DateTime(destination.year, destination.month,
        destination.day, source.hour, source.minute);
    return dateTime;
  }
}
