import 'package:flutter/material.dart';

class ShowCustomWidgets {
  BuildContext context;
  ShowCustomWidgets(this.context);

  Future<DateTime?> scheduleStartDatePicker(DateTime initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(
        const Duration(days: 1000),
      ),
    );
  }

  Future<DateTime?> scheduleEndDatePicker(
      DateTime initialDate, DateTime startDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: startDate,
      lastDate: startDate.add(
        const Duration(days: 366),
      ),
    );
  }

  Future<TimeOfDay?> scheduleTimePicker(DateTime initialTime) async {
    return showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: initialTime.hour, minute: initialTime.minute),
    );
  }
}
