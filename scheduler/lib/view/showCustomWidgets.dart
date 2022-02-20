import 'package:flutter/material.dart';

class ShowCustomWidgets {
  BuildContext context;
  ShowCustomWidgets(this.context);

  Future<DateTime?> scheduleDatePicker(DateTime initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(
        const Duration(days: 1000),
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
