import 'package:flutter/material.dart';

import '../../model/schedule.dart';
import '../widgets/button/dialog_action_button.dart';
import '../widgets/date_time_picker.dart';
import '../widgets/slider/labeled_slider.dart';
import '../widgets/textarea/input_text_area.dart';

const String dateFormat = "yyyy-MM-dd";
const String timeFormat = "HH:mm";

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

  bool get isCorrectSchedulePeriod =>
      !schedule.endDateTime.isBefore(schedule.startDateTime);

  bool get isEmptyScheduleName => schedule.name == "";

  bool get canCompleteSettingSchedule =>
      isCorrectSchedulePeriod && !isEmptyScheduleName;

  @override
  void initState() {
    super.initState();
    schedule = widget.initialSchedule != null
        ? widget.initialSchedule!
        : Schedule(DateTime.now());
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
              TextInputField(
                text: schedule.name,
                hintText: "何をする予定ですか？",
                fontSize: 16,
                width: 400,
              ),
              DateTimePicker(schedule: schedule),
            ],
          ),
          LabeledSlider(
            value: schedule.motivation,
            label: "モチベーション",
          ),
        ],
      ),
      actions: <Widget>[
        DialogActionButton(
          title: method == ScheduleSettingMethod.add ? "追加" : "修正",
          onPressed: canCompleteSettingSchedule
              ? () => Navigator.pop(context, schedule)
              : null,
        ),
        DialogActionButton(
          title: "キャンセル",
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
