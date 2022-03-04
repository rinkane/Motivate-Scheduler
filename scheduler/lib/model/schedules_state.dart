import 'package:flutter/cupertino.dart';

import 'schedule.dart';

class SchedulesState {
  final List<Schedule> schedules;
  SchedulesState({this.schedules = const []});

  SchedulesState update(List<Schedule> Function(List<Schedule>)? builder) {
    return SchedulesState(
        schedules: builder == null ? schedules : builder(List.of(schedules)));
  }

  SchedulesState updateAt(int index, Schedule Function(Schedule)? builder) {
    if (builder == null) {
      return SchedulesState(schedules: schedules);
    }

    List<Schedule> clone = List.of(schedules);
    clone[index] = builder(clone[index]);
    return SchedulesState(schedules: clone);
  }
}
