import 'package:flutter_test/flutter_test.dart';

import '../../lib/model/schedule.dart';

void main() {
  late Schedule schedule;
  late Schedule anotherSchedule;
  setUp(() {
    schedule = Schedule.of(
        "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
    anotherSchedule = Schedule.of(
        "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
  });
  group("AddDoubleBookingSchedule Test", () {
    test("add one schedule that double-booking schedule.", () {
      schedule.addDoubleBookingSchedule(anotherSchedule);

      expect(schedule.doubleBookingSchedules.length, 1);
      expect(schedule.doubleBookingSchedules, <Schedule>[anotherSchedule]);
    });

    test("add two schedule that not double-booking schedule.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      anotherSchedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 3), DateTime(2022, 1, 4));

      schedule.addDoubleBookingSchedule(anotherSchedule);

      expect(schedule.doubleBookingSchedules.length, 0);
      expect(schedule.doubleBookingSchedules, <Schedule>[]);
    });
  });

  group("IsDuring Test", () {
    test("Same DateTime", () {
      bool isDuring = schedule.isDuring(anotherSchedule);

      expect(isDuring, true);
    });
  });
}