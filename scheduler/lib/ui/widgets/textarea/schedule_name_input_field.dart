import 'package:flutter/material.dart';

import '../../../model/schedule.dart';

class ScheduleNameInputField extends StatefulWidget {
  final Schedule schedule;
  final String hintText;
  final double width;
  final double fontSize;

  const ScheduleNameInputField(
      {Key? key,
      required this.schedule,
      this.hintText = "",
      this.width = 400,
      this.fontSize = 16})
      : super(key: key);

  @override
  ScheduleNameInputFieldState createState() => ScheduleNameInputFieldState();
}

class ScheduleNameInputFieldState extends State<ScheduleNameInputField> {
  late Schedule schedule;
  late String hintText;
  late double width;
  late double fontSize;

  @override
  void initState() {
    super.initState();

    schedule = widget.schedule;
    hintText = widget.hintText;
    width = widget.width;
    fontSize = widget.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: schedule.name,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(hintText: hintText),
        onChanged: (String s) {
          changeTextField(s);
        },
      ),
    );
  }

  void changeTextField(String value) {
    setState(() {
      schedule.name = value;
    });
  }
}
