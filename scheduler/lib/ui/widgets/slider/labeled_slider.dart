import 'package:flutter/material.dart';

import '../../../model/schedule.dart';

class ScheduleMotivationSlider extends StatefulWidget {
  final Schedule schedule;
  final String label;

  const ScheduleMotivationSlider(
      {Key? key, required this.schedule, required this.label})
      : super(key: key);

  @override
  ScheduleMotivationSliderState createState() =>
      ScheduleMotivationSliderState();
}

class ScheduleMotivationSliderState extends State<ScheduleMotivationSlider> {
  late Schedule schedule;
  late String label;

  @override
  void initState() {
    super.initState();

    schedule = widget.schedule;
    label = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 28, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(label),
        ),
        Container(
          width: 450,
          margin: const EdgeInsets.fromLTRB(0, 30, 50, 0),
          alignment: Alignment.center,
          child: Slider(
            value: schedule.motivation.toDouble(),
            max: 100,
            min: -100,
            onChanged: changeSlider,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 30, 20, 0),
          alignment: Alignment.centerRight,
          child: Text(schedule.motivation.toString()),
        ),
      ],
    );
  }

  void changeSlider(double value) {
    setState(() {
      schedule.motivation = value.toInt();
    });
  }
}
