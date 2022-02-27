import 'package:intl/intl.dart';

class CompleteSchedule {
  String id = "";
  String name = "";
  int motivation = 0;

  DateTime startDateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  DateTime endDateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute);

  String imagePath = "";

  CompleteSchedule();
  CompleteSchedule.of(this.id, this.name, this.motivation, this.startDateTime,
      this.endDateTime, this.imagePath);

  bool isDuring(CompleteSchedule schedule) {
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
}
