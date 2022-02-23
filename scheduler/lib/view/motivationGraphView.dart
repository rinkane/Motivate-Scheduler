import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

import '../model/schedule.dart';
import '../model/schedulesArguments.dart';
import 'viewSelectDrawer.dart';

class MotivationGraphView extends StatefulWidget {
  const MotivationGraphView(
      {Key? key, required this.title, required this.schedules})
      : super(key: key);

  final String title;
  final List<Schedule> schedules;

  @override
  State<MotivationGraphView> createState() => _MotivationGraphViewState();
}

class _MotivationGraphViewState extends State<MotivationGraphView> {
  late List<Schedule> schedules = <Schedule>[];
  @override
  void initState() {
    super.initState();

    schedules = widget.schedules;
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    if (args is SchedulesArguments) {
      schedules = args.schedules;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: ViewSelectDrawer(schedules: schedules),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(30),
            height: 500,
            child: TimeSeriesChart(createMotivationData()),
          ),
        ],
      ),
    );
  }

  List<Series<MotivationData, DateTime>> createMotivationData() {
    List<Schedule> _schedules = createSchedulesCopy(schedules);
    _schedules.sort((a, b) => a.endDateTime.compareTo(b.endDateTime));

    List<MotivationData> motivations = createMotivationDatas(_schedules);

    return [
      Series<MotivationData, DateTime>(
        id: "Motivations",
        data: motivations,
        colorFn: (_, __) => MaterialPalette.purple.shadeDefault,
        domainFn: (motivation, _) => motivation.dateTime,
        measureFn: (motivation, _) => motivation.motivation,
      )
    ];
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
