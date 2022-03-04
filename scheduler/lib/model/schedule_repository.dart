import 'package:scheduler/model/schedule.dart';

abstract class ScheduleRepository {
  Future<bool> authUserRepository(String email);

  Future<List<Schedule>> getSchedules();

  Future<List<Schedule>> getCompleteSchedules();

  Future<bool> addSchedules(Schedule schedule);

  Future<bool> addCompleteSchedules(Schedule schedule);
}
