import 'package:intl/intl.dart';

class Schedule {
  String id = "";
  String name = "";
  int motivation = 0;

  late DateTime startDateTime;
  late DateTime endDateTime;

  bool get isCorrectSchedulePeriod => !endDateTime.isBefore(startDateTime);

  final _doubleBookedSchedules = <Schedule>[];

  int get doubleBookedCount => _doubleBookedSchedules.length;

  Schedule(DateTime now) {
    startDateTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);
    endDateTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }

  Schedule.of(this.id, this.name, this.motivation, DateTime _startDateTime,
      DateTime _endDateTime) {
    startDateTime = DateTime(_startDateTime.year, _startDateTime.month,
        _startDateTime.day, _startDateTime.hour, _startDateTime.minute);
    endDateTime = DateTime(_endDateTime.year, _endDateTime.month,
        _endDateTime.day, _endDateTime.hour, _endDateTime.minute);
  }

  void addDoubleBookedSchedule(Schedule schedule) {
    if (this == schedule) {
      return;
    }

    if (_doubleBookedSchedules.contains(schedule)) {
      return;
    }

    if (!isDoubleBooked(schedule)) {
      return;
    }

    _doubleBookedSchedules.add(schedule);
  }

  void removeDoubleBookedSchedule(Schedule schedule) {
    _doubleBookedSchedules.remove(schedule);
  }

  bool isDoubleBooked(Schedule schedule) {
    if (startDateTime.isAtSameMomentAs(endDateTime) &&
        schedule.startDateTime.isAtSameMomentAs(schedule.endDateTime)) {
      return false;
    }

    if (startDateTime.isAfter(schedule.startDateTime) &&
        startDateTime.isBefore(schedule.endDateTime)) {
      return true;
    }

    if (schedule.startDateTime.isAfter(startDateTime) &&
        schedule.startDateTime.isBefore(endDateTime)) {
      return true;
    }

    if (endDateTime.isAfter(schedule.startDateTime) &&
        endDateTime.isBefore(schedule.endDateTime)) {
      return true;
    }

    if (schedule.endDateTime.isAfter(startDateTime) &&
        schedule.endDateTime.isBefore(endDateTime)) {
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

  String getDoubleBookedWarningText() {
    if (_doubleBookedSchedules.isEmpty) return "";

    String warning =
        "It's double-booked with " + _getDoubleBookedSchedulesText();

    return warning;
  }

  String _getDoubleBookedSchedulesText() {
    String warning = "";
    for (var doubleBookingSchedule in _doubleBookedSchedules) {
      warning += '"' + doubleBookingSchedule.name + '"';
      warning += " , ";
    }
    return warning.replaceRange(warning.length - 3, null, '.');
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
