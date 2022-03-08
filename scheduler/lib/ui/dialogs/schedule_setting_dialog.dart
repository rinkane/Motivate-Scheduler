import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/schedule.dart';
import '../widgets/button/dialog_action_button.dart';
import '../widgets/date_time_picker.dart';
import '../widgets/slider/labeled_slider.dart';

const String dateFormat = "yyyy-MM-dd";
const String timeFormat = "HH:mm";

class ScheduleSettingDialog extends StatefulHookConsumerWidget {
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

class ScheduleSettingDialogState extends ConsumerState<ScheduleSettingDialog> {
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
        ? Schedule.of(
            widget.initialSchedule!.id,
            widget.initialSchedule!.name,
            widget.initialSchedule!.motivation,
            widget.initialSchedule!.startDateTime,
            widget.initialSchedule!.endDateTime)
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
              SizedBox(
                width: 400,
                child: TextFormField(
                  initialValue: schedule.name,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(hintText: "何をする予定ですか？"),
                  onChanged: (String s) {
                    changeTextField(s);
                  },
                ),
              ),
              DateTimePicker(schedule: schedule),
            ],
          ),
          ScheduleMotivationSlider(
            schedule: schedule,
            label: "モチベーション",
          ),
        ],
      ),
      actions: <Widget>[
        DialogActionButton(
          title: method == ScheduleSettingMethod.add ? "追加" : "修正",
          onPressed: schedule.name != ""
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

  void changeTextField(String value) {
    setState(() {
      schedule.name = value;
    });
  }
}
