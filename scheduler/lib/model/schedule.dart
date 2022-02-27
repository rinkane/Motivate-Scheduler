import 'package:intl/intl.dart';

class Schedule {
  String name = "";
  int motivation = 0;

  DateTime startDateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  DateTime endDateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);

  var doubleBookingSchedules = <Schedule>[];

  Schedule();
  Schedule.of(this.name, this.motivation, this.startDateTime, this.endDateTime);

  void addDoubleBookingSchedule(Schedule schedule) {
    if (!doubleBookingSchedules.contains(schedule)) {
      doubleBookingSchedules.add(schedule);
    }
  }

  bool isDuring(Schedule schedule) {
    return (startDateTime.isAfter(schedule.startDateTime) &&
            startDateTime.isBefore(schedule.endDateTime)) ||
        (endDateTime.isAfter(schedule.startDateTime) &&
            endDateTime.isBefore(schedule.endDateTime));
  }

  String getDurationText() {
    return DateFormat("yyyy-MM-dd HH:mm").format(startDateTime) +
        " ~ " +
        DateFormat("yyyy-MM-dd HH:mm").format(endDateTime);
  }

  String getDoubleBookingWarning() {
    if (doubleBookingSchedules.isEmpty) return "";

    String warning = "It's double-booked with ";
    for (var doubleBookingSchedule in doubleBookingSchedules) {
      warning += '"' + doubleBookingSchedule.name + '"';
      warning += " , ";
    }
    warning = warning.replaceRange(warning.length - 3, null, '.');
    return warning;
  }
}
