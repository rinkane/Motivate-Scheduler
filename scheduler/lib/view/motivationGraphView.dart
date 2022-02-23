import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      drawer: ViewSelectDrawer(schedules: schedules),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(title: Text(widget.title)),
        ],
      ),
    );
  }
}
