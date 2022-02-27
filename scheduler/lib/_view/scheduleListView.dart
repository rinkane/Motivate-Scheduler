import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../_model/schedule.dart';
import '../_viewModel/scheduleListViewModel.dart';

const String dateTimeformat = "yyyy-MM-dd HH:mm";

class ScheduleListView extends StatelessWidget {
  const ScheduleListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final scheduleListViewModel = Provider.of<ScheduleListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("motivate-scheduler"),
      ),
      body: Center(
        child: Text(
          scheduleListViewModel.schedules.toString(),
          style: TextStyle(fontSize: 100),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scheduleListViewModel.addSchedule(
              Schedule.of("testSch", 0, DateTime.now(), DateTime.now()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
