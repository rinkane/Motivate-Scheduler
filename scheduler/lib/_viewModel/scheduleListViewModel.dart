import 'package:flutter/foundation.dart';

class ScheduleListViewModel with ChangeNotifier {
  int count = 0;

  ScheduleListViewModel() {
    count = 0;
  }

  void incrementCount() {
    count++;
    notifyListeners();
  }
}
