import 'package:scheduler/model/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'schedule_repository.dart';

final scheduleRepositoryProvider = Provider((_) => ScheduleRepositoryImpl());

class ScheduleRepositoryImpl implements ScheduleRepository {
  DocumentReference<Map<String, dynamic>>? _userDocument;
  User? user;
  bool get isAuth => _userDocument != null && user != null;

  @override
  Future<bool> authUserRepository(User user) async {
    if (isAuth) {
      return true;
    }

    try {
      this.user = user;
      _userDocument =
          FirebaseFirestore.instance.collection("users").doc(user.uid);
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  Future<List<Schedule>> getSchedules() async {
    if (!isAuth) {
      return [];
    }

    List<Schedule> schedules = [];
    try {
      final schedulesSnapshot =
          await _userDocument!.collection("schedules").get();
      for (var scheduleDoc in schedulesSnapshot.docs) {
        schedules.add(Schedule.of(
            scheduleDoc["id"],
            scheduleDoc["name"],
            scheduleDoc["motivate"],
            scheduleDoc["startTime"].toDate(),
            scheduleDoc["endTime"].toDate()));
      }
      return schedules;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Schedule>> getCompleteSchedules() async {
    if (!isAuth) {
      return [];
    }

    List<Schedule> completeSchedules = [];
    try {
      final completeSchedulesSnapshot =
          await _userDocument!.collection("completeSchedules").get();
      for (var completeScheduleDoc in completeSchedulesSnapshot.docs) {
        completeSchedules.add(Schedule.of(
            completeScheduleDoc["id"],
            completeScheduleDoc["name"],
            completeScheduleDoc["motivate"],
            completeScheduleDoc["startTime"].toDate(),
            completeScheduleDoc["endTime"].toDate()));
      }
      return completeSchedules;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> addSchedule(Schedule schedule) async {
    if (!isAuth) {
      return false;
    }

    try {
      final newDocId = user!.uid;
      schedule.id = newDocId;
      await _userDocument!.collection("schedules").doc(newDocId).set({
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

  @override
  Future<bool> addCompleteSchedule(Schedule schedule) async {
    if (!isAuth) {
      return false;
    }

    try {
      await _userDocument!
          .collection("completeSchedules")
          .doc(schedule.id)
          .set({
        "id": schedule.id,
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

  @override
  Future<bool> updateSchedule(Schedule schedule) async {
    if (!isAuth) {
      return false;
    }

    try {
      await _userDocument!.collection("schedules").doc(schedule.id).set({
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

  @override
  Future<bool> deleteSchedule(Schedule schedule) async {
    if (!isAuth) {
      return false;
    }

    try {
      await _userDocument!.collection("schedules").doc(schedule.id).delete();
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> deleteCompleteSchedule(Schedule schedule) async {
    if (!isAuth) {
      return false;
    }

    try {
      await _userDocument!
          .collection("completeSchedules")
          .doc(schedule.id)
          .delete();
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  void signOutRepository() {
    _userDocument = null;
  }
}
