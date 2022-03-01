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

    test("Schedule isn't during other schedule.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      anotherSchedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 3), DateTime(2022, 1, 4));

      bool isDuring = schedule.isDuring(anotherSchedule);
      expect(isDuring, false);
    });
  });

  group("isCompleteAt Test", () {
    test("schedule is complete at the time.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      DateTime afterScheduleTime = DateTime(2022, 1, 3);
      bool isComplete = schedule.isCompleteAt(afterScheduleTime);

      expect(isComplete, true);
    });

    test("schedule is during the time.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 3));
      DateTime duringScheduleTime = DateTime(2022, 1, 2);
      bool isComplete = schedule.isCompleteAt(duringScheduleTime);

      expect(isComplete, false);
    });

    test("schedule has not been started yet.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 2), DateTime(2022, 1, 3));
      DateTime beforeScheduleTime = DateTime(2022, 1, 1);
      bool isComplete = schedule.isCompleteAt(beforeScheduleTime);

      expect(isComplete, false);
    });

    test("schedule just completed at the time.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      DateTime scheduleCompleteTime = DateTime(2022, 1, 2);
      bool isComplete = schedule.isCompleteAt(scheduleCompleteTime);

      expect(isComplete, true);
    });
  });
}
