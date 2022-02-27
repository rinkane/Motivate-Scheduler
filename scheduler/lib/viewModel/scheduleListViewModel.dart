import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/schedule.dart';

class ScheduleListViewModel with ChangeNotifier {
  List<Schedule> schedules = [];
  QueryDocumentSnapshot<Map<String, dynamic>>? userDoc;

  bool fetchSchedule(String? userEmail) {
    if (userEmail == null) {
      return false;
    }

    Future(() async {
      if (userDoc == null) {
        try {
          initSchedule(userEmail);
        } catch (e) {
          userDoc = null;
          return false;
        }
      }

      final userSnapshot =
          await userDoc!.reference.collection("schedules").get();

      for (var userSchedule in userSnapshot.docs) {
        final newSchedule = Schedule.of(
            userSchedule["name"],
            userSchedule["motivate"],
            userSchedule["startTime"].toDate(),
            userSchedule["endTime"].toDate());
        addSchedule(newSchedule);
      }
    });

    return true;
  }

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

  void initSchedule(String userEmail) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("users").get();
      userDoc = snapshot.docs.firstWhere((doc) => doc["mail"] == userEmail);
    } catch (e) {
      rethrow;
    }
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
