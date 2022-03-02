import 'package:flutter_test/flutter_test.dart';

import '../../lib/model/completeSchedule.dart';

void main() {
  group("constructor", () {
    test("default constructor", () {
      CompleteSchedule schedule =
          CompleteSchedule(DateTime(2022, 3, 2, 9, 39, 20, 1, 1));

      expect(schedule.id, "");
      expect(schedule.name, "");
      expect(schedule.motivation, 0);
      expect(schedule.startDateTime, DateTime(2022, 3, 2, 9, 39));
      expect(schedule.endDateTime, DateTime(2022, 3, 2, 9, 39));
      expect(schedule.imagePath, "");
    });

    test("of() constructor", () {
      CompleteSchedule schedule = CompleteSchedule.of(
          "TestID123",
          "ScheduleName1あ亜ア",
          -35,
          DateTime(2022, 3, 2, 9, 4, 5, 1, 1),
          DateTime(2022, 12, 24, 12, 55, 37, 10, 10),
          "test/image/path.png");

      expect(schedule.id, "TestID123");
      expect(schedule.name, "ScheduleName1あ亜ア");
      expect(schedule.motivation, -35);
      expect(schedule.startDateTime, DateTime(2022, 3, 2, 9, 4));
      expect(schedule.endDateTime, DateTime(2022, 12, 24, 12, 55));
      expect(schedule.imagePath, "test/image/path.png");
    });
  });
}
