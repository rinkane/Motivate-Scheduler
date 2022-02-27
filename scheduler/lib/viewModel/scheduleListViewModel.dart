import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/schedule.dart';

class ScheduleListViewModel with ChangeNotifier {
  List<Schedule> schedules = [];
  QueryDocumentSnapshot<Map<String, dynamic>>? userDocument;

  Future<bool> fetchScheduleFromFirestore(String? userEmail) async {
    schedules = [];

    if (userEmail == null) {
      return false;
    }

    try {
      await initFirestoreDocument(userEmail);
    } catch (e) {
      userDocument = null;
      return false;
    }

    try {
      final userSnapshot =
          await userDocument!.reference.collection("schedules").get();

      for (var userSchedule in userSnapshot.docs) {
        final newSchedule = Schedule.of(
            userSchedule["id"],
            userSchedule["name"],
            userSchedule["motivate"],
            userSchedule["startTime"].toDate(),
            userSchedule["endTime"].toDate());
        insertScheduleToSchedules(newSchedule);
      }
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<void> initFirestoreDocument(String userEmail) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("users").get();
      userDocument =
          snapshot.docs.firstWhere((doc) => doc["mail"] == userEmail);
    } catch (e) {
      rethrow;
    }
  }

  bool addSchedule(Schedule schedule) {
    if (!insertScheduleToFirestore(schedule)) {
      return false;
    }

    insertScheduleToSchedules(schedule);
    return true;
  }

  bool insertScheduleToFirestore(Schedule schedule) {
    if (userDocument == null) {
      return false;
    }

    try {
      final newDocId = userDocument!.reference.collection("schedules").doc().id;
      userDocument!.reference.collection("schedules").doc(newDocId).set({
        "id": newDocId,
        "name": schedule.name,
        "motivate": schedule.motivation,
        "startTime": schedule.startDateTime,
        "endTime": schedule.endDateTime,
      });
    } catch (e) {
      return false;
    }

    return true;
  }

  void insertScheduleToSchedules(Schedule schedule) {
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

  bool updateSchedule(Schedule schedule, int index) {
    if (!updateScheduleToFirestore(schedule)) {
      return false;
    }

    updateScheduleToSchedules(schedule, index);
    return true;
  }

  bool updateScheduleToFirestore(Schedule schedule) {
    if (userDocument == null) {
      return false;
    }

    try {
      userDocument!.reference.collection("schedules").doc(schedule.id).set({
        "name": schedule.name,
        "motivate": schedule.motivation,
        "startTime": schedule.startDateTime,
        "endTime": schedule.endDateTime,
      }, SetOptions(merge: true));
    } catch (e) {
      return false;
    }

    return true;
  }

  void updateScheduleToSchedules(Schedule schedule, int index) {
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

  bool deleteSchedule(int index) {
    if (!deleteScheduleFromFirestore(schedules[index])) {
      return false;
    }

    deleteScheduleFromSchedules(index);
    return true;
  }

  bool deleteScheduleFromFirestore(Schedule schedule) {
    if (userDocument == null) {
      return false;
    }

    try {
      userDocument!.reference.collection("schedules").doc(schedule.id).delete();
    } catch (e) {
      return false;
    }
    return true;
  }

  void deleteScheduleFromSchedules(int index) {
    schedules.removeAt(index);
    notifyListeners();
  }
}
