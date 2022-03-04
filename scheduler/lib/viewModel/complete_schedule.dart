import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scheduler/model/schedule_repository_impl.dart';

import '../model/schedule.dart';

final completeScheduleListProvider =
    StateNotifierProvider<CompleteScheduleListViewModel, List<Schedule>>((ref) {
  return CompleteScheduleListViewModel(ref.read);
});

class CompleteScheduleListViewModel extends StateNotifier<List<Schedule>> {
  final Reader _reader;
  late final scheduleRepository = _reader(scheduleRepositoryProvider);

  CompleteScheduleListViewModel(this._reader) : super([]);

  Future<bool> fetchSchedule(String? userEmail) async {
    if (userEmail == null) {
      return false;
    }

    if (!await scheduleRepository.authUserRepository(userEmail)) {
      state = [];
      return false;
    }

    final schedules = await scheduleRepository.getCompleteSchedules();
    _insertSchedulesToState(schedules);

    return state.isNotEmpty;
  }

  Future<bool> addCompleteSchedule(Schedule schedule) async {
    if (!await scheduleRepository.addCompleteSchedules(schedule)) {
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
    for (int i = 0; i < state.length; i++) {
      if (state[i].startDateTime.isAfter(schedule.startDateTime)) {
        state.insert(i, schedule);
        return;
      }
    }
    state.add(schedule);
  }
}
