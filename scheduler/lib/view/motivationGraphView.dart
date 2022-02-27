import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:provider/provider.dart';

import '../model/schedule.dart';
import '../viewModel/scheduleListViewModel.dart';
import 'viewSelectDrawer.dart';

class MotivationGraphView extends StatelessWidget {
  const MotivationGraphView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Motivation Scheduler"),
      ),
      drawer: const ViewSelectDrawer(),
      body: Center(
        child: Container(
            margin: const EdgeInsets.all(30),
            height: 500,
            child: createChart(
                Provider.of<ScheduleListViewModel>(context).schedules)),
      ),
    );
  }

  TimeSeriesChart createChart(List<Schedule> schedules) {
    List<Schedule> _schedules = createSchedulesCopy(schedules);
    _schedules.sort((a, b) => a.endDateTime.compareTo(b.endDateTime));

    List<MotivationData> motivations = createMotivationDatas(_schedules);

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

  List<Schedule> createSchedulesCopy(List<Schedule> schedules) {
    List<Schedule> _schedules = <Schedule>[];
    for (int i = 0; i < schedules.length; i++) {
      _schedules.add(Schedule.of(schedules[i].name, schedules[i].motivation,
          schedules[i].startDateTime, schedules[i].endDateTime));
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
