import 'package:scheduler/model/schedule.dart';

abstract class ScheduleRepository {
  Future<bool> authUserRepository(String email);

  Future<List<Schedule>> getSchedules();

  Future<List<Schedule>> getCompleteSchedules();

  Future<bool> addSchedule(Schedule schedule);

  Future<bool> addCompleteSchedule(Schedule schedule);

  Future<bool> updateSchedule(Schedule schedule);

  Future<bool> deleteSchedule(Schedule schedule);
}
