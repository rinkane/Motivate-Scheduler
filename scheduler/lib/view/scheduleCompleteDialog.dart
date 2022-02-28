import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/schedule.dart';
import '../model/completeSchedule.dart';
import 'dateTimePicker.dart';

const String dateFormat = "yyyy-MM-dd";
const String timeFormat = "HH:mm";

class ScheduleCompleteDialog extends StatefulWidget {
  final Schedule initialSchedule;

  const ScheduleCompleteDialog({
    Key? key,
    required this.initialSchedule,
  }) : super(key: key);

  @override
  ScheduleCompleteDialogState createState() => ScheduleCompleteDialogState();
}

class ScheduleCompleteDialogState extends State<ScheduleCompleteDialog> {
  late CompleteSchedule completeSchedule;

  @override
  void initState() {
    super.initState();

    completeSchedule = CompleteSchedule.of(
        widget.initialSchedule.id,
        widget.initialSchedule.name,
        widget.initialSchedule.motivation,
        widget.initialSchedule.startDateTime,
        widget.initialSchedule.endDateTime,
        "");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${completeSchedule.name}を完了しますか？"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DateTimePicker(schedule: completeSchedule),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        SizedBox(
          width: 100,
          height: 60,
          child: TextButton(
              child: const Text("完了"),
              onPressed: completeSchedule.isCorrectSchedulePeriod
                  ? () {
                      Navigator.pop(context, completeSchedule);
                    }
                  : null),
        ),
        SizedBox(
          width: 100,
          height: 60,
          child: TextButton(
            child: const Text("キャンセル"),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
