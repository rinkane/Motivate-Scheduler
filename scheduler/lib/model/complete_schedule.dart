import 'schedule.dart';

class CompleteSchedule extends Schedule {
  String imagePath = "";

  CompleteSchedule(DateTime now) : super(now);
  CompleteSchedule.of(
      id, name, motivation, startDateTime, endDateTime, this.imagePath)
      : super.of(id, name, motivation, startDateTime, endDateTime);
}
