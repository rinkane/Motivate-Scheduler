import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/schedule.dart';
import 'show_custom_widgets.dart';

const String dateFormat = "yyyy-MM-dd";
const String timeFormat = "HH:mm";

class DateTimePicker extends StatefulWidget {
  final Schedule schedule;

  const DateTimePicker({Key? key, required this.schedule}) : super(key: key);

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  late Schedule schedule;
  @override
  void initState() {
    super.initState();

    schedule = widget.schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                child:
                    Text(DateFormat(dateFormat).format(schedule.startDateTime)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(6, 0, 3, 0),
                ),
              ),
              SizedBox(
                width: 44,
                child: TextButton(
                  onPressed: () => selectTime(context, true),
                  child: Text(
                      DateFormat(timeFormat).format(schedule.startDateTime)),
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
                child:
                    Text(DateFormat(dateFormat).format(schedule.endDateTime)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(6, 0, 3, 0),
                ),
              ),
              SizedBox(
                width: 44,
                child: TextButton(
                  onPressed: () => selectTime(context, false),
                  child:
                      Text(DateFormat(timeFormat).format(schedule.endDateTime)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(3, 0, 6, 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void selectDate(BuildContext context, bool isStart) async {
    DateTime scheduleDate =
        isStart ? schedule.startDateTime : schedule.endDateTime;
    final DateTime? date = isStart
        ? await ShowCustomWidgets(context).scheduleStartDatePicker(scheduleDate)
        : await ShowCustomWidgets(context)
            .scheduleEndDatePicker(scheduleDate, schedule.startDateTime);
    if (date != null) {
      final DateTime newDate = createUpdatedDate(scheduleDate, date);
      setState(() {
        if (isStart) {
          schedule.startDateTime = newDate;
          validateScheduleEndDateTime();
        } else {
          schedule.endDateTime = newDate;
          validateScheduleStartDateTime();
        }
      });
    }
  }

  void selectTime(BuildContext context, bool isStart) async {
    DateTime scheduleTime =
        isStart ? schedule.startDateTime : schedule.endDateTime;
    final TimeOfDay? time =
        await ShowCustomWidgets(context).scheduleTimePicker(scheduleTime);
    if (time != null) {
      final DateTime newTime = createUpdatedTime(scheduleTime, time);
      setState(() {
        if (isStart) {
          schedule.startDateTime = newTime;
          validateScheduleEndDateTime();
        } else {
          schedule.endDateTime = newTime;
          validateScheduleStartDateTime();
        }
      });
    }
  }

  void validateScheduleStartDateTime() {
    if (!schedule.isCorrectSchedulePeriod) {
      setState(() {
        schedule.startDateTime =
            schedule.startDateTime.add(const Duration(days: -1));
      });
    }
  }

  void validateScheduleEndDateTime() {
    if (!schedule.isCorrectSchedulePeriod) {
      setState(() {
        schedule.endDateTime =
            createUpdatedDate(schedule.endDateTime, schedule.startDateTime);
      });
    }

    if (!schedule.isCorrectSchedulePeriod) {
      setState(() {
        schedule.endDateTime =
            schedule.endDateTime.add(const Duration(days: 1));
      });
    }
  }

  DateTime createUpdatedDate(DateTime destination, DateTime source) {
    DateTime dateTime = DateTime(
      source.year,
      source.month,
      source.day,
      destination.hour,
      destination.minute,
    );
    return dateTime;
  }

  DateTime createUpdatedTime(DateTime destination, TimeOfDay source) {
    DateTime dateTime = DateTime(destination.year, destination.month,
        destination.day, source.hour, source.minute);
    return dateTime;
  }
}
