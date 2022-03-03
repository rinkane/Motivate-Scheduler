import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:charts_flutter/flutter.dart';

import '../model/complete_schedule.dart';
import '../model/schedule.dart';
import '../viewModel/complete_schedule.dart';
import '../viewModel/schedule_list.dart';
import 'view_select_drawer.dart';

class MotivationGraphView extends HookConsumerWidget {
  const MotivationGraphView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(scheduleListProvider).schedules;
    final completeSchedules =
        ref.watch(completeScheduleListProvider).completeSchedules;
    final allSchedules = createSchedulesCopy(schedules, completeSchedules);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Motivation Scheduler"),
      ),
      drawer: const ViewSelectDrawer(),
      body: Center(
        child: Container(
            margin: const EdgeInsets.all(30),
            height: 500,
            child: createChart(allSchedules)),
      ),
    );
  }

  TimeSeriesChart createChart(List<Schedule> schedules) {
    schedules.sort((a, b) => a.endDateTime.compareTo(b.endDateTime));

    List<MotivationData> motivations = createMotivationDatas(schedules);

    return TimeSeriesChart(
      [
        Series<MotivationData, DateTime>(
          id: "Motivations",
          data: motivations,
          colorFn: (_, __) => MaterialPalette.purple.shadeDefault,
          domainFn: (motivation, _) => motivation.dateTime,
          measureFn: (motivation, _) => motivation.motivation,
        )
      ],
      animate: false,
      behaviors: [
        RangeAnnotation(
          [
            for (int i = 0; i < motivations.length; i++)
              LineAnnotationSegment(
                motivations[i].dateTime,
                RangeAnnotationAxisType.domain,
                startLabel: DateFormat("yyyy-MM-dd HH:mm")
                    .format(motivations[i].dateTime),
                labelPosition: AnnotationLabelPosition.inside,
              ),
          ],
        ),
      ],
    );
  }

  List<Schedule> createSchedulesCopy(
      List<Schedule> schedules, List<CompleteSchedule> completeSchedules) {
    List<Schedule> _schedules = <Schedule>[];
    for (int i = 0; i < schedules.length; i++) {
      _schedules.add(Schedule.of(
          schedules[i].id,
          schedules[i].name,
          schedules[i].motivation,
          schedules[i].startDateTime,
          schedules[i].endDateTime));
    }
    for (int i = 0; i < completeSchedules.length; i++) {
      _schedules.add(Schedule.of(
          completeSchedules[i].id,
          completeSchedules[i].name,
          completeSchedules[i].motivation,
          completeSchedules[i].startDateTime,
          completeSchedules[i].endDateTime));
    }

    return _schedules;
  }

  List<MotivationData> createMotivationDatas(List<Schedule> schedules) {
    List<MotivationData> motivations = <MotivationData>[];
    if (schedules.isEmpty) {
      return [];
    }
    motivations.add(MotivationData(schedules[0].startDateTime, 0));
    for (int i = 0; i < schedules.length; i++) {
      if (i == 0) {
        motivations.add(
            MotivationData(schedules[0].endDateTime, schedules[0].motivation));
      } else {
        motivations.add(MotivationData(schedules[i].endDateTime,
            motivations[i].motivation + schedules[i].motivation));
      }
    }
    return motivations;
  }
}

class MotivationData {
  final DateTime dateTime;
  final int motivation;

  MotivationData(this.dateTime, this.motivation);
}
