import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'schedule.dart';
import 'showCustomWidgets.dart';

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
      home: const MyHomePage(title: appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var schedules = <Schedule>[];

  void showAddScheduleDialog() async {
    final schedule = await showDialog<Schedule>(
        context: context,
        builder: (context) =>
            AddScheduleDialog(initialSchedule: Schedule("", 0.0)));
    if (schedule != null) {
      setState(() {
        schedules.add(schedule);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(title: Text(widget.title)),
        SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          return Card(
              child: ListTile(
                  leading: Text(schedules[index].motivation.toString()),
                  title: Text(schedules[index].name),
                  subtitle: Text(DateFormat("yyyy-MM-dd H:m")
                          .format(schedules[index].startDateTime) +
                      " ~ " +
                      DateFormat("yyyy-MM-dd H:m")
                          .format(schedules[index].endDateTime)),
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          schedules.removeAt(index);
                        });
                      })));
        }, childCount: schedules.length))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddScheduleDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddScheduleDialog extends StatefulWidget {
  final Schedule initialSchedule;

  const AddScheduleDialog({Key? key, required this.initialSchedule})
      : super(key: key);

  @override
  AddScheduleDialogState createState() => AddScheduleDialogState();
}

class AddScheduleDialogState extends State<AddScheduleDialog> {
  late Schedule schedule;

  @override
  void initState() {
    super.initState();
    schedule = widget.initialSchedule;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("スケジュールの追加"),
        content: Column(children: <Widget>[
          TextField(
              decoration: InputDecoration(hintText: "追加したい予定"),
              onChanged: changeTextField),
          Text(schedule.motivation.toString()),
          Slider(
            value: schedule.motivation,
            max: 100,
            min: -100,
            onChanged: changeSlider,
          ),
          Text(DateFormat("yyyy-MM-dd H:m").format(schedule.startDateTime)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            ElevatedButton(
                child: Text("日付選択"),
                onPressed: () => selectDate(context, true)),
            ElevatedButton(
                child: Text("時間選択"),
                onPressed: () => selectTime(context, true)),
          ]),
          Text(DateFormat("yyyy-MM-dd H:m").format(schedule.endDateTime)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                child: Text("日付選択"),
                onPressed: () => selectDate(context, false)),
            ElevatedButton(
                child: Text("時間選択"),
                onPressed: () => selectTime(context, false)),
          ]),
        ]),
        actions: <Widget>[
          ElevatedButton(
              child: Text("追加"),
              onPressed: () {
                Navigator.pop(context, schedule);
              }),
          ElevatedButton(
              child: Text("キャンセル"),
              onPressed: () {
                Navigator.pop(context);
              })
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
        if (isStart)
          schedule.startDateTime = newDate;
        else
          schedule.endDateTime = newDate;
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
        if (isStart)
          schedule.startDateTime = newTime;
        else
          schedule.endDateTime = newTime;
      });
    }
  }

  DateTime createTime(DateTime destination, TimeOfDay source) {
    DateTime dateTime = DateTime(destination.year, destination.month,
        destination.day, source.hour, source.minute);
    return dateTime;
  }
}
