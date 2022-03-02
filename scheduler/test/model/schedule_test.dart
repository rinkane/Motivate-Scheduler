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

  group("constructor", () {
    test("default constructor", () {
      schedule = Schedule(DateTime(2022, 3, 2, 9, 39, 20, 1, 1));

      expect(schedule.id, "");
      expect(schedule.name, "");
      expect(schedule.motivation, 0);
      expect(schedule.startDateTime, DateTime(2022, 3, 2, 9, 39));
      expect(schedule.endDateTime, DateTime(2022, 3, 2, 9, 39));
    });

    test("of() constructor", () {
      schedule = Schedule.of(
          "TestID123",
          "ScheduleName1あ亜ア",
          -35,
          DateTime(2022, 3, 2, 9, 4, 5, 1, 1),
          DateTime(2022, 12, 24, 12, 55, 37, 10, 10));

      expect(schedule.id, "TestID123");
      expect(schedule.name, "ScheduleName1あ亜ア");
      expect(schedule.motivation, -35);
      expect(schedule.startDateTime, DateTime(2022, 3, 2, 9, 4));
      expect(schedule.endDateTime, DateTime(2022, 12, 24, 12, 55));
    });
  });

  group("AddDoubleBookingSchedule Test", () {
    test("add one schedule that double-booking schedule.", () {
      schedule.addDoubleBookedSchedule(anotherSchedule);

      expect(schedule.doubleBookedCount, 1);
    });

    test("add two schedule that not double-booking schedule.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      anotherSchedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 3), DateTime(2022, 1, 4));

      schedule.addDoubleBookedSchedule(anotherSchedule);

      expect(schedule.doubleBookedCount, 0);
    });
  });

  group("removeDoubleBookingSchedule Test", () {
    test("remove one schedule", () {
      schedule.addDoubleBookedSchedule(anotherSchedule);
      schedule.addDoubleBookedSchedule(Schedule(DateTime(2022, 1, 1, 12)));
      schedule.removeDoubleBookedSchedule(anotherSchedule);
      String warning = schedule.getDoubleBookedWarningText();

      expect(schedule.doubleBookedCount, 1);
      expect(warning, "It's double-booked with " '"".');
    });

    test("remove zero schedule", () {
      schedule.removeDoubleBookedSchedule(anotherSchedule);
      String warning = schedule.getDoubleBookedWarningText();

      expect(schedule.doubleBookedCount, 0);
      expect(warning, "");
    });
  });

  group("IsDuring Test", () {
    test("Same schedule", () {
      bool isDuring = schedule.isDoubleBooked(anotherSchedule);
      expect(isDuring, true);
    });

    test("When schedule finishes, other schedule starts.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      anotherSchedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 2), DateTime(2022, 1, 3));

      bool isDuring = schedule.isDoubleBooked(anotherSchedule);
      expect(isDuring, false);
      isDuring = anotherSchedule.isDoubleBooked(schedule);
      expect(isDuring, false);
    });

    test("Same schedule and schedule is a moment.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 1));
      anotherSchedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 1));

      bool isDuring = schedule.isDoubleBooked(anotherSchedule);
      expect(isDuring, false);
      isDuring = anotherSchedule.isDoubleBooked(schedule);
      expect(isDuring, false);
    });

    test("moment and during", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      anotherSchedule = Schedule.of("ID1", "schedule1", 0,
          DateTime(2022, 1, 1, 12), DateTime(2022, 1, 1, 12));

      bool isDuring = schedule.isDoubleBooked(anotherSchedule);
      expect(isDuring, true);
      isDuring = anotherSchedule.isDoubleBooked(schedule);
      expect(isDuring, true);
    });

    test("during", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      anotherSchedule = Schedule.of("ID1", "schedule1", 0,
          DateTime(2022, 1, 1, 10), DateTime(2022, 1, 1, 14));

      bool isDuring = schedule.isDoubleBooked(anotherSchedule);
      expect(isDuring, true);
      isDuring = anotherSchedule.isDoubleBooked(schedule);
      expect(isDuring, true);
    });

    test("double booked", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 3));
      anotherSchedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 2), DateTime(2022, 1, 4));

      bool isDuring = schedule.isDoubleBooked(anotherSchedule);
      expect(isDuring, true);
      isDuring = anotherSchedule.isDoubleBooked(schedule);
      expect(isDuring, true);
    });

    test("Schedule isn't during other schedule.", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      anotherSchedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 3), DateTime(2022, 1, 4));

      bool isDuring = schedule.isDoubleBooked(anotherSchedule);
      expect(isDuring, false);
    });
  });

  group("getDurationText Test", () {
    test("a digit", () {
      schedule = Schedule.of("ID1", "schedule1", 0, DateTime(2022, 1, 2, 3, 4),
          DateTime(2022, 5, 6, 7, 8));
      String durationText = schedule.getDurationText();

      expect(durationText, "2022-01-02 03:04 ~ 2022-05-06 07:08");
    });

    test("two digits", () {
      schedule = Schedule.of("ID1", "schedule1", 0,
          DateTime(2022, 10, 11, 12, 13), DateTime(2022, 11, 22, 23, 59));
      String durationText = schedule.getDurationText();

      expect(durationText, "2022-10-11 12:13 ~ 2022-11-22 23:59");
    });

    test("zero", () {
      schedule = Schedule.of("ID1", "schedule1", 0, DateTime(2022, 1, 1, 0, 0),
          DateTime(2022, 1, 2, 0, 0));
      String durationText = schedule.getDurationText();

      expect(durationText, "2022-01-01 00:00 ~ 2022-01-02 00:00");
    });
  });

  group("getDoubleBookingWarningText Test", () {
    test("empty", () {
      String warning = schedule.getDoubleBookedWarningText();

      expect(warning, "");
    });

    test("a double-booking schedule", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      anotherSchedule = Schedule.of(
          "ID2", "schedule2", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));

      schedule.addDoubleBookedSchedule(anotherSchedule);
      String warning = schedule.getDoubleBookedWarningText();
      expect(warning, "It's double-booked with " '"schedule2".');
    });

    test("two double-booking schedule", () {
      schedule = Schedule.of(
          "ID1", "schedule1", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      anotherSchedule = Schedule.of(
          "ID2", "schedule2", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));
      Schedule thirdSchedule = Schedule.of(
          "ID3", "schedule3", 0, DateTime(2022, 1, 1), DateTime(2022, 1, 2));

      schedule.addDoubleBookedSchedule(anotherSchedule);
      schedule.addDoubleBookedSchedule(thirdSchedule);
      String warning = schedule.getDoubleBookedWarningText();
      expect(warning, "It's double-booked with " '"schedule2" , "schedule3".');
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
