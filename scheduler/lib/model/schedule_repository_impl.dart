import 'package:scheduler/model/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/model/schedule_repository.dart';

final scheduleRepositoryProvider = Provider((_) => ScheduleRepositoryImpl());

class ScheduleRepositoryImpl implements ScheduleRepository {
  QueryDocumentSnapshot<Map<String, dynamic>>? _userDocument;
  bool get isAuth => _userDocument != null;

  @override
  Future<bool> authUserRepository(String email) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("users").get();
      _userDocument = snapshot.docs.firstWhere((doc) => doc["mail"] == email);
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
          await _userDocument!.reference.collection("schedules").get();
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
          await _userDocument!.reference.collection("completeSchedules").get();
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
  Future<bool> addSchedules(Schedule schedule) async {
    if (!isAuth) {
      return false;
    }

    try {
      await _userDocument!.reference
          .collection("schedules")
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
  Future<bool> addCompleteSchedules(Schedule schedule) async {
    if (!isAuth) {
      return false;
    }

    try {
      await _userDocument!.reference
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
}
