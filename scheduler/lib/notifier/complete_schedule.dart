import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/repository/schedule_repository_impl.dart';

import '../model/schedule.dart';
import '../model/schedules_state.dart';

final completeScheduleListProvider =
    StateNotifierProvider<CompleteScheduleState, SchedulesState>((ref) {
  return CompleteScheduleState(ref.read);
});

class CompleteScheduleState extends StateNotifier<SchedulesState> {
  final Reader _reader;
  late final scheduleRepository = _reader(scheduleRepositoryProvider);

  CompleteScheduleState(this._reader) : super(SchedulesState());

  Future<bool> fetchSchedule(String? userEmail) async {
    if (userEmail == null) {
      return false;
    }

    if (!await scheduleRepository.authUserRepository(userEmail)) {
      return false;
    }

    final schedules = await scheduleRepository.getCompleteSchedules();
    _insertSchedulesToState(schedules);

    return true;
  }

  Future<bool> addCompleteSchedule(Schedule schedule) async {
    if (!await scheduleRepository.addCompleteSchedule(schedule)) {
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
        return;
      }
    }
    state = state.update((schedules) => schedules..add(schedule));
  }

  Future<bool> deleteCompleteSchedule(int index) async {
    if (!await scheduleRepository
        .deleteCompleteSchedule(state.schedules[index])) {
      return false;
    }

    _deleteScheduleFromState(index);
    return true;
  }

  void _deleteScheduleFromState(int index) {
    state = state.update((schedules) => schedules..removeAt(index));
  }
}
