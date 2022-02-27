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
        child: ScheduleList(schedules: scheduleListViewModel.schedules),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scheduleListViewModel.addSchedule(
              Schedule.of("testSch", 0, DateTime.now(), DateTime.now()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ScheduleList extends StatelessWidget {
  final List<Schedule> schedules;

  const ScheduleList({Key? key, required this.schedules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) => ScheduleCard(schedule: schedules[index]),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(schedule.name),
        leading: Text(schedule.motivation.toString()),
      ),
    );
  }
}
