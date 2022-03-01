import 'package:intl/intl.dart';

class Schedule {
  String id = "";
  String name = "";
  int motivation = 0;

  DateTime startDateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  DateTime endDateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);

  bool get isCorrectSchedulePeriod => !endDateTime.isBefore(startDateTime);

  var doubleBookingSchedules = <Schedule>[];
  Schedule();
  Schedule.of(this.id, this.name, this.motivation, this.startDateTime,
      this.endDateTime);

  void addDoubleBookingSchedule(Schedule schedule) {
    if (doubleBookingSchedules.contains(schedule)) {
      return;
    }

    if (!isDuring(schedule)) {
      return;
    }

    doubleBookingSchedules.add(schedule);
  }

  bool isDuring(Schedule schedule) {
    if (startDateTime.isAtSameMomentAs(endDateTime) ||
        schedule.startDateTime.isAtSameMomentAs(schedule.endDateTime)) {
      return false;
    }

    if (startDateTime.isAfter(schedule.startDateTime) &&
        startDateTime.isBefore(schedule.endDateTime)) {
      return true;
    }

    if (endDateTime.isAfter(schedule.startDateTime) &&
        endDateTime.isBefore(schedule.endDateTime)) {
      return true;
    }

    if (startDateTime.isAtSameMomentAs(schedule.startDateTime) &&
        endDateTime.isAtSameMomentAs(schedule.endDateTime)) {
      return true;
    }

    return false;
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

  bool isCompleteAt(DateTime now) {
    if (now.isAfter(endDateTime)) {
      return true;
    }
    if (now.isAtSameMomentAs(endDateTime)) {
      return true;
    }
    return false;
  }
}
