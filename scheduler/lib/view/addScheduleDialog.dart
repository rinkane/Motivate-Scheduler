import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/schedule.dart';
import 'showCustomWidgets.dart';

class AddScheduleDialog extends StatefulWidget {
  const AddScheduleDialog({Key? key}) : super(key: key);

  @override
  AddScheduleDialogState createState() => AddScheduleDialogState();
}

class AddScheduleDialogState extends State<AddScheduleDialog> {
  late Schedule schedule;

  @override
  void initState() {
    super.initState();
    schedule = Schedule();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("スケジュールの追加"),
        content: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(hintText: "追加したい予定"),
              onChanged: (String s) {
                changeTextField(s);
              },
            ),
            Text(schedule.motivation.toString()),
            Slider(
              value: schedule.motivation,
              max: 100,
              min: -100,
              onChanged: changeSlider,
            ),
            Text(DateFormat("yyyy-MM-dd H:m").format(schedule.startDateTime)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text("日付選択"),
                  onPressed: () => selectDate(context, true),
                ),
                ElevatedButton(
                  child: const Text("時間選択"),
                  onPressed: () => selectTime(context, true),
                ),
              ],
            ),
            Text(DateFormat("yyyy-MM-dd H:m").format(schedule.endDateTime)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("日付選択"),
                  onPressed: () => selectDate(context, false),
                ),
                ElevatedButton(
                  child: const Text("時間選択"),
                  onPressed: () => selectTime(context, false),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("追加"),
            onPressed: () {
              Navigator.pop(context, schedule);
            },
          ),
          ElevatedButton(
            child: const Text("キャンセル"),
            onPressed: () {
              Navigator.pop(context);
            },
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
