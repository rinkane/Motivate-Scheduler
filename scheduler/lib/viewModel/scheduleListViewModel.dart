import 'package:flutter/foundation.dart';

import '../model/schedule.dart';

class ScheduleListViewModel with ChangeNotifier {
  List<Schedule> schedules = [];

  void addSchedule(Schedule schedule) {
    for (int i = 0; i < schedules.length; i++) {
      if (schedules[i].startDateTime.isAfter(schedule.startDateTime)) {
        schedules.insert(i, schedule);
        notifyListeners();
        checkDoubleBooking(schedule);
        return;
      }
    }
    schedules.add(schedule);
    notifyListeners();

    checkDoubleBooking(schedule);
  }

  void fixSchedule(Schedule schedule, int index) {
    schedules[index] = schedule;
    notifyListeners();

    checkDoubleBooking(schedule);
  }

  void checkDoubleBooking(Schedule schedule) {
    for (int i = 0; i < schedules.length; i++) {
      if (schedules[i].isDuring(schedule) || schedule.isDuring(schedules[i])) {
        schedule.addDoubleBookingSchedule(schedules[i]);
        schedules[i].addDoubleBookingSchedule(schedule);
        notifyListeners();
      } else {
        schedule.doubleBookingSchedules.remove(schedules[i]);
        schedules[i].doubleBookingSchedules.remove(schedule);
        notifyListeners();
      }
    }
  }

  void deleteScheduleDelegate(int index) {
    schedules.removeAt(index);
    notifyListeners();
  }
}
