import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repository/schedule_repository_impl.dart';
import '../model/schedules_state.dart';
import '../model/schedule.dart';

final scheduleListProvider =
    StateNotifierProvider<ScheduleStateNotifier, SchedulesState>(
        (ref) => ScheduleStateNotifier(ref.read));

class ScheduleStateNotifier extends StateNotifier<SchedulesState> {
  final Reader _reader;
  late final scheduleRepository = _reader(scheduleRepositoryProvider);
  ScheduleStateNotifier(this._reader) : super(SchedulesState());

  void clearSchedule() {
    state = state.update((_) => []);
  }

  Future<bool> fetchSchedule(User? user) async {
    if (user == null) {
      return false;
    }

    if (!await scheduleRepository.authUserRepository(user)) {
      return false;
    }

    final schedules = await scheduleRepository.getSchedules();
    state = state.update((_) => []);
    _insertSchedulesToState(schedules);

    return true;
  }

  Future<bool> addSchedule(Schedule schedule) async {
    if (!await scheduleRepository.addSchedule(schedule)) {
      return false;
    }

    _insertScheduleToState(schedule);
    return true;
  }

  void _insertSchedulesToState(List<Schedule> schedules) {
    for (final schedule in schedules) {
      _insertScheduleToState(schedule);
    }
  }

  void _insertScheduleToState(Schedule schedule) {
    for (int i = 0; i < state.schedules.length; i++) {
      if (state.schedules[i].startDateTime.isAfter(schedule.startDateTime)) {
        state = state.update((schedules) => schedules..insert(i, schedule));
        _updateDoubleBooking(schedule);
        return;
      }
    }
    state = state.update((schedules) => schedules..add(schedule));

    _updateDoubleBooking(schedule);
  }

  Future<bool> updateSchedule(Schedule schedule, int index) async {
    if (!await scheduleRepository.updateSchedule(schedule)) {
      return false;
    }

    _updateScheduleToState(schedule, index);
    return true;
  }

  void _updateScheduleToState(Schedule schedule, int index) {
    deleteSchedule(index);
    addSchedule(schedule);
  }

  void _updateDoubleBooking(Schedule schedule) {
    _addDoubleBooking(schedule);
    _removeDoubleBooking(schedule);
  }

  void _addDoubleBooking(Schedule schedule) {
    for (int i = 0; i < state.schedules.length; i++) {
      if (state.schedules[i].isDoubleBooked(schedule)) {
        state = state.updateAt(
            i, (_schedule) => _schedule..addDoubleBookedSchedule(schedule));
        state = state.updateAt(
            state.schedules.indexOf(schedule),
            (_schedule) =>
                _schedule..addDoubleBookedSchedule(state.schedules[i]));
      }
    }
  }

  void _removeDoubleBooking(Schedule schedule, {bool isForce = false}) {
    for (int i = 0; i < state.schedules.length; i++) {
      if (!state.schedules[i].isDoubleBooked(schedule) || isForce) {
        state = state.updateAt(
            i, (_schedule) => _schedule..removeDoubleBookedSchedule(schedule));
        state = state.updateAt(
            state.schedules.indexOf(schedule),
            (_schedule) =>
                _schedule..removeDoubleBookedSchedule(state.schedules[i]));
      }
    }
  }

  Future<bool> deleteSchedule(int index) async {
    if (!await scheduleRepository.deleteSchedule(state.schedules[index])) {
      return false;
    }

    _deleteScheduleFromState(index);
    return true;
  }

  void _deleteScheduleFromState(int index) {
    _removeDoubleBooking(state.schedules[index], isForce: true);
    state = state.update((schedules) => schedules..removeAt(index));
  }
}
