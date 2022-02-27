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
      body: const Center(
        child: ScheduleList(),
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
  const ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheduleListViewModel = Provider.of<ScheduleListViewModel>(context);
    return ListView.builder(
      itemCount: scheduleListViewModel.schedules.length,
      itemBuilder: (context, index) => ScheduleCard(index: index),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final int index;

  const ScheduleCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheduleListViewModel = Provider.of<ScheduleListViewModel>(context);
    return Card(
      child: ListTile(
        title: Text(scheduleListViewModel.schedules[index].name),
        leading:
            Text(scheduleListViewModel.schedules[index].motivation.toString()),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => scheduleListViewModel.deleteScheduleDelegate(index),
        ),
      ),
    );
  }
}
