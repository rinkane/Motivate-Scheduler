import 'package:firebase_auth/firebase_auth.dart';

import '../model/schedule.dart';

abstract class ScheduleRepository {
  Future<bool> authUserRepository(User user);

  Future<List<Schedule>> getSchedules();

  Future<List<Schedule>> getCompleteSchedules();

  Future<bool> addSchedule(Schedule schedule);

  Future<bool> addCompleteSchedule(Schedule schedule);

  Future<bool> updateSchedule(Schedule schedule);

  Future<bool> deleteSchedule(Schedule schedule);

  Future<bool> deleteCompleteSchedule(Schedule schedule);

  void signOutRepository();
}
