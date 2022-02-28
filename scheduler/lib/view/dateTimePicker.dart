import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'showCustomWidgets.dart';

const String dateFormat = "yyyy-MM-dd";
const String timeFormat = "HH:mm";

class DateTimePicker extends StatefulWidget {
  final DateTime startDateTime;
  final DateTime endDateTime;

  const DateTimePicker(
      {Key? key, required this.startDateTime, required this.endDateTime})
      : super(key: key);

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  late DateTime startDateTime;
  late DateTime endDateTime;

  bool get isCorrectSchedulePeriod => !endDateTime.isBefore(startDateTime);

  @override
  void initState() {
    super.initState();

    startDateTime = widget.startDateTime;
    endDateTime = widget.endDateTime;
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
                child: Text(DateFormat(dateFormat).format(startDateTime)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(6, 0, 3, 0),
                ),
              ),
              SizedBox(
                width: 44,
                child: TextButton(
                  onPressed: () => selectTime(context, true),
                  child: Text(DateFormat(timeFormat).format(startDateTime)),
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
                child: Text(DateFormat(dateFormat).format(endDateTime)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(6, 0, 3, 0),
                ),
              ),
              SizedBox(
                width: 44,
                child: TextButton(
                  onPressed: () => selectTime(context, false),
                  child: Text(DateFormat(timeFormat).format(endDateTime)),
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
    DateTime scheduleDate = isStart ? startDateTime : endDateTime;
    final DateTime? date = isStart
        ? await ShowCustomWidgets(context).scheduleStartDatePicker(scheduleDate)
        : await ShowCustomWidgets(context)
            .scheduleEndDatePicker(scheduleDate, startDateTime);
    if (date != null) {
      final DateTime newDate = createUpdatedDate(scheduleDate, date);
      setState(() {
        if (isStart) {
          startDateTime = newDate;
          validateScheduleEndDateTime();
        } else {
          endDateTime = newDate;
          validateScheduleStartDateTime();
        }
      });
    }
  }

  void selectTime(BuildContext context, bool isStart) async {
    DateTime scheduleTime = isStart ? startDateTime : endDateTime;
    final TimeOfDay? time =
        await ShowCustomWidgets(context).scheduleTimePicker(scheduleTime);
    if (time != null) {
      final DateTime newTime = createUpdatedTime(scheduleTime, time);
      setState(() {
        if (isStart) {
          startDateTime = newTime;
          validateScheduleEndDateTime();
        } else {
          endDateTime = newTime;
          validateScheduleStartDateTime();
        }
      });
    }
  }

  void validateScheduleStartDateTime() {
    if (!isCorrectSchedulePeriod) {
      setState(() {
        startDateTime = startDateTime.add(const Duration(days: -1));
      });
    }
  }

  void validateScheduleEndDateTime() {
    if (!isCorrectSchedulePeriod) {
      setState(() {
        endDateTime = createUpdatedDate(endDateTime, startDateTime);
      });
    }

    if (!isCorrectSchedulePeriod) {
      setState(() {
        endDateTime = endDateTime.add(const Duration(days: 1));
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
