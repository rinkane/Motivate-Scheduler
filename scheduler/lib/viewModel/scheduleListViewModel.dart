import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/schedule.dart';

class ScheduleListViewModel with ChangeNotifier {
  List<Schedule> schedules = <Schedule>[];
  List<DocumentSnapshot> documents = [];

  void fetchSchedules(User user) {
    schedules = [];
    QuerySnapshot<Map<String, dynamic>> snapshot;

    Future(() async {
      snapshot = await FirebaseFirestore.instance.collection("users").get();
      documents = snapshot.docs;

      final userDoc = documents.firstWhere((doc) => doc["mail"] == user?.email);
      final userSnapshot =
          await userDoc.reference.collection("schedules").get();

      for (var userSchedule in userSnapshot.docs) {
        final newSchedule = Schedule.of(
            userSchedule["name"],
            userSchedule["motivate"],
            userSchedule["startTime"].toDate(),
            userSchedule["endTime"].toDate());
        insertSchedule(newSchedule);
        checkDoubleBooking(newSchedule);
      }
    });
  }

  void insertSchedule(Schedule schedule) {
    for (int i = 0; i < schedules.length; i++) {
      if (schedules[i].startDateTime.isAfter(schedule.startDateTime)) {
        schedules.insert(i, schedule);
        notifyListeners();
        return;
      }
    }
    schedules.add(schedule);
    notifyListeners();
  }

  void checkDoubleBooking(Schedule schedule) {
    for (int i = 0; i < schedules.length; i++) {
      if (schedules[i].isDuring(schedule) || schedule.isDuring(schedules[i])) {
        schedule.addDoubleBookingSchedule(schedules[i]);
        schedules[i].addDoubleBookingSchedule(schedule);
        notifyListeners();
      } else {
        schedule.doubleBookingSchedule.remove(schedules[i]);
        schedules[i].doubleBookingSchedule.remove(schedule);
        notifyListeners();
      }
    }
  }
}
