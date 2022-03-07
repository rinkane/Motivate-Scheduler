import 'package:flutter/material.dart';
import 'package:scheduler/ui/widgets/button/dialog_action_button.dart';
import 'package:scheduler/ui/widgets/text/dialog_title_text.dart';

import '../../model/schedule.dart';
import '../widgets/date_time_picker.dart';
import '../widgets/slider/labeled_slider.dart';
import '../widgets/text/one_line_text.dart';

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
  late Schedule completeSchedule;

  @override
  void initState() {
    super.initState();

    completeSchedule = Schedule.of(
        widget.initialSchedule.id,
        widget.initialSchedule.name,
        widget.initialSchedule.motivation,
        widget.initialSchedule.startDateTime,
        widget.initialSchedule.endDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DialogTitleText(
        ellipsisText: completeSchedule.name,
        text: "を完了しますか？",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DateTimePicker(schedule: completeSchedule),
            ],
          ),
          LabeledSlider(
              label: "モチベーション", value: completeSchedule.motivation.toInt()),
        ],
      ),
      actions: <Widget>[
        DialogActionButton(
          title: "完了",
          onPressed: () => Navigator.pop(context, completeSchedule),
        ),
        DialogActionButton(
          title: "キャンセル",
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
