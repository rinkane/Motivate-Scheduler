import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../_model/schedule.dart';
import '../_viewModel/scheduleListViewModel.dart';
import '../_view/scheduleSettingDialog.dart';

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
        onPressed: () async {
          final schedule = await showDialog<Schedule>(
            context: context,
            builder: (context) => const ScheduleSettingDialog(
              initialMethod: ScheduleSettingMethod.add,
            ),
          );
          if (schedule != null) {
            scheduleListViewModel.addSchedule(schedule);
          }
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
    final schedule = scheduleListViewModel.schedules[index];
    return Card(
      child: ListTile(
        title: Text(schedule.name),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: 30,
              child: Text(schedule.motivation.toString()),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                schedule.getDurationText(),
              ),
            ),
            Visibility(
              visible: schedule.doubleBookingSchedules.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: DefaultTextStyle(
                  child: Text(schedule.getDoubleBookingWarning()),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.yellow.shade600,
                  ),
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.mode_edit),
              onPressed: () async {
                final _schedule = await showDialog<Schedule>(
                  context: context,
                  builder: (context) => ScheduleSettingDialog(
                      initialMethod: ScheduleSettingMethod.fix,
                      initialSchedule: schedule),
                );
                if (_schedule != null) {
                  scheduleListViewModel.fixSchedule(_schedule, index);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  scheduleListViewModel.deleteScheduleDelegate(index),
            ),
          ],
        ),
      ),
    );
  }
}
