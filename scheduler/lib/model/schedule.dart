class Schedule {
  String name = "";
  int motivation = 0;

  DateTime startDateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);

  DateTime endDateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);

  var doubleBookingSchedule = <Schedule>[];

  Schedule();
  Schedule.of(this.name, this.motivation, this.startDateTime, this.endDateTime);

  void addDoubleBookingSchedule(Schedule schedule) {
    if (!doubleBookingSchedule.contains(schedule)) {
      doubleBookingSchedule.add(schedule);
    }
  }

  bool isDuring(Schedule schedule) {
    return (startDateTime.isAfter(schedule.startDateTime) &&
            startDateTime.isBefore(schedule.endDateTime)) ||
        (endDateTime.isAfter(schedule.startDateTime) &&
            endDateTime.isBefore(schedule.endDateTime));
  }
}
