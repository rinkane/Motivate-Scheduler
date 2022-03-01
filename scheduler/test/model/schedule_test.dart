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
    test("Same schedule", () {
      bool isDuring = schedule.isDuring(anotherSchedule);
      expect(isDuring, true);
    });

    test("When schedule finishes, other schedule starts.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      anotherSchedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 2), DateTime(2022, 1, 3));

      bool isDuring = schedule.isDuring(anotherSchedule);
      expect(isDuring, false);
      isDuring = anotherSchedule.isDuring(schedule);
      expect(isDuring, false);
    });

    test("Same schedule and schedule is a moment.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 1));
      anotherSchedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 1));

      bool isDuring = schedule.isDuring(anotherSchedule);
      expect(isDuring, false);
      isDuring = anotherSchedule.isDuring(schedule);
      expect(isDuring, false);
    });

    test("Schedule isn't between other schedule.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      anotherSchedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 3), DateTime(2022, 1, 4));

      bool isDuring = schedule.isDuring(anotherSchedule);
      expect(isDuring, false);
    });
  });
}
