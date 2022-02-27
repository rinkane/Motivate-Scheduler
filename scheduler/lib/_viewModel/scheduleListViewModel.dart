import 'package:flutter/foundation.dart';

import '../_model/schedule.dart';

class ScheduleListViewModel with ChangeNotifier {
  List<Schedule> schedules = [];

  void addSchedule(Schedule schedule) {
    schedules.add(schedule);
    notifyListeners();
  }
}
